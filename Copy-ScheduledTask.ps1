function Copy-ScheduledTask {
    $script:Tasks | Select-Object -ExcludeProperty Copy, URI | Format-Table -AutoSize

    # ID selection
    $Selected = @()
    foreach ($SelectedID in (Read-Host '[Q1/2] Please enter the task IDs to copy. Seperated by a comma, you can use also a ranged selection (eg: 12,30..40,7 | This will select the task with the ID 12, the tasks with the IDs from 30 to 40 and it will select the task with the ID 7)').Split(',')) {

        if ($SelectedID -like "*..*") {
            $Split = $SelectedID.Split('..')
            $Selected += $Split[0]..$Split[1]
        }
        else {
            $Selected += $SelectedID
        }
    }

    # path selection

    $UserSelectedPath = Read-Host '[Q2/2] If you want to copy the tasks to another folder please enter the targetfolder, if not just leave the field emnty.'
    if ($UserSelectedPath) {
        foreach ($Task in $script:Tasks) {
            $Task.TargetPath = $UserSelectedPath
        }
    }

    Use-ScheduledTaskEngine -ID $SelectedTasks -TargetFolder $UserSelectedPath
}

function Build-ScheduledTaskList {
    $script:Tasks = @()
    $ID = 1
    foreach ($Task in (Get-ScheduledTask)) {
        $script:Tasks += [PSCustomObject][ordered]@{
            'ID'         = $ID++
            'Name'       = $Task.TaskName
            'Path'       = $Task.TaskPath
            'State'      = $Task.State
            'URI'        = $Task.URI
            'Copy'       = $false
            'TargetPath' = $Task.TaskPath
        }
    }
}

function Use-ScheduledTaskEngine {
    param (
        [string]$ID = '\\\undefined',
        [string]$TargetFolder = '\\\undefined',
        [int]$CopyCounter = 1
    )

    

    ($CopyCounter - 1)..0 | Foreach-Object {
        try {
            Register-ScheduledTask -TaskName ($sTask.Name + ' - copy ' + [string](Get-Random)) -TaskPath $Path -Xml (Export-ScheduledTask $sTask.URI) -ErrorAction Stop
        }
        catch {
            Write-Error ('You need elevated privileges to copy the task: ' + $sTask.Name + '. Please re-start the powershell with a admin user or the user account that created/owns the task.')
        }
    }
}
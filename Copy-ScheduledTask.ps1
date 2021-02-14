function Build-ScheduledTaskList {
    $script:Tasks = @()
    $ID = 1
    foreach ($Task in (Get-ScheduledTask)) {
        $script:Tasks += [PSCustomObject][ordered]@{
            'ID'             = $ID++
            'Name'           = $Task.TaskName
            'Path'           = $Task.TaskPath
            'State'          = $Task.State
            'URI'            = $Task.URI
            'Copy'           = $false
            'CopyTargetPath' = $Task.TaskPath
        }
    }
}

function Copy-ScheduledTask {
    Build-ScheduledTaskList
    $script:Tasks | Select-Object -ExcludeProperty Copy, CopyTargetPath, URI | Format-Table -AutoSize

    # ID selection
    $Selected = @()
    foreach ($SelectedID in (Read-Host '[Q 1/3] Please enter the task IDs to copy. Seperated by a comma, you can use also a ranged selection (eg: 12,30..40,7 | This will select the task with the ID 12, the tasks with the IDs from 30 to 40 and it will select the task with the ID 7)').Split(',')) {

        if ($SelectedID -like "*..*") {
            $Split = $SelectedID.Split('..')
            $Selected += $Split[0]..$Split[1]
        }
        else {
            $Selected += $SelectedID
        }
    }
    $Tasks | Where-Object ID -in $Selected | ForEach-Object { $_.Copy = $true }
    
    # path selection
    $UserSelectedPath = Read-Host '[Q 2/3] If you want to copy the tasks to another folder please enter the targetfolder, if not just leave the field emnty.'
    if ($UserSelectedPath) {
        foreach ($Task in $script:Tasks) {
            $Task.CopyTargetPath = $UserSelectedPath
        }
    }

    # copy selecttion

    # $UserCopyCounter = Read-Host '[Q 3/3] How many copies do you want to create of each task?'
    




    Use-ScheduledTaskEngine 
}

function Copy-ScheduledTaskFolder {
    Build-ScheduledTaskList
    $script:Tasks | Group-Object Path | Select-Object -ExcludeProperty Copy, CopyTargetPath, URI | Format-Table -AutoSize

    if (Read-Host 'Do you want to open the legacy task scheduler? Power Shell cannot delete folders only  tasks') {
        Start-Process -FilePath ($env:windir + '\system32\taskschd.msc')
    }
}

function Use-ScheduledTaskEngine {
    $CopyCounter = 5
    $IterateCounter = 0


    $script:Tasks | ? Copy -eq $true | Group-Object Name | ForEach-Object {

        $CurrentTaskName = $_.Name
        if ($CurrentTaskName -ne $LastTaskName) {
            $IterateCounter = 0
        }

        if ($IterateCounter -eq 0) {
            $TaskName = $_.Name + ' - copy'
        }
        else {
            $TaskName = $_.Name + ' - copy ' + $IterateCounter
        }

        try {
            Register-ScheduledTask -TaskName $TaskName -TaskPath $_.Group.CopyTargetPath -Xml (Export-ScheduledTask $_.URI) -ErrorAction Stop
        }
        catch {
            Write-Error ('You need elevated privileges to copy the task: ' + $TaskName + '. Please re-start the powershell with a admin user or the user account that created/owns the task.')
        }
        $IterateCounter++
        $LastTaskName = $_.Name
    }
}

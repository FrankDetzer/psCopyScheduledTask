function Copy-ScheduledTask {
    param (
        [int]$CopyCounter = 1,
        [bool]$TargetFolder = $false
    )
    $Tasks = @()
    $ID = 1
    foreach ($Task in (Get-ScheduledTask)) {
        $Tasks += [PSCustomObject][ordered]@{
            'ID'    = $ID++
            'Name'  = $Task.TaskName
            'Path'  = $Task.TaskPath
            'State' = $Task.State
            'URI'   = $Task.URI
        }
    }

    $Tasks | Select-Object ID, Name, Path | Format-Table -AutoSize

    $Selected = @()
    foreach ($Integer in (Read-Host 'Please enter the task IDs to copy. Seperated by a comma, you can use also a ranged selection (eg: 12,30..40,7 | This will select the ask with the ID 12, the tasks with the IDs from 30 to 40 and it will select the task with the ID 7)').Split(',')) {

        if ($Integer -like "*..*") {
            $Split = $Integer.Split('..')
            $Selected += $Split[0]..$Split[1]
        }
        else {
            $Selected += $Integer
        }
    }
    
    foreach ($sTask in ($Tasks | Where-Object ID -in $Selected)) {
        $Xml = $null

        if ($TargetFolder) {
            $Path = $TargetFolder
        }else {
            $Path = $sTask.Path
        }

        $Xml = Export-ScheduledTask $sTask.URI
        ($CopyCounter - 1)..0 | Foreach-Object {
            try {
                Register-ScheduledTask -TaskName ($sTask.Name + ' - copy ' + [string](Get-Random)) -TaskPath $Path -Xml $Xml -ErrorAction Stop
            }
            catch {
                Write-Error ('You need elevated privileges to copy the task: ' + $sTask.Name + '. Please re-start the powershell with a admin user or the user account that created/owns the task.')
            }
        }
    }
}
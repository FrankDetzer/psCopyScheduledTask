
function Copy-ScheduledTask {
    param (
        [string]$SourceURI = 'UndefinedURI',
        [string]$SourceFolder = 'UndefinedFolder',
        [string]$NewTaskName = 'UndefinedNewTaskName',
        [string]$Destination = 'UndefinedDestination',
        [int]$NumberOfCopies = 1,
        [switch]$DeleteSourceTask = $false
    )

    $ScheduledTaskList = @()
    foreach ($Task in (Get-ScheduledTask)) {
        $ScheduledTaskList += [PSCustomObject]@{

            
            'Name'  = $Task.TaskName
            'Path'  = $Task.TaskPath
            'State' = $Task.State
            'URI'   = $Task.URI
            'Copy'  = $false
        }
    }


    0..$NumberOfCopies | ForEach-Object {
        if ($_ -eq 0) {
            $TaskName = $TaskToCopy.Name + ' - copy'
        }
        else {
            $TaskName = $TaskToCopy.Name + ' - copy ' + $_
        }

        if ($TaskName -eq (Get-ScheduledTask $TaskName).TaskName) {
            $TaskName = $TaskToCopy.Name + ' - copy ' + (New-Guid).Guid
        }

        try {
            Register-ScheduledTask -TaskName $TaskName -TaskPath $TaskToCopy.CopyTargetPath -Xml (Export-ScheduledTask $TaskToCopy.URI) -ErrorAction Stop
        }
        catch {
            Write-Error ('You need elevated privileges to copy the task: ' + $TaskName + '. Please re-start the powershell with a admin user or the user account that created/owns the task.')
        }
    }
}
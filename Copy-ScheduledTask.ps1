function Copy-ScheduledTask {
    param (
        [parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'URI', Position = 0)][string]$URI,
        [parameter(ValueFromPipelineByPropertyName, DontShow)][string]$TaskName,
        [parameter(ValueFromPipelineByPropertyName, DontShow)][string]$TaskPath,
        [int]$NumberOfCopies = 1,
        [switch]$DeleteSourceTask = $false
    )

    begin {
    }

    process {
        [int]$CopyNumber = 1

        foreach ($TaskToCopy in $URI) {
            do {

                if ($CopyNumber -eq 1) {
                    $CopyTaskName = $TaskName + ' - copy'
                }
                else {
                    $CopyTaskName = $TaskName + ' - copy ' + $CopyNumber
                }
            
                if ($CopyTaskName -eq (Get-ScheduledTask $CopyTaskName -ErrorAction Ignore).TaskName) {
                    $CopyTaskName = $TaskName + ' ' + (New-Guid).Guid
                }
            
            
            try {
                Register-ScheduledTask -TaskName $CopyTaskName -TaskPath $TaskPath -Xml (Export-ScheduledTask $URI) -ErrorAction Stop
            }
            catch {
                Write-Error ('You need elevated privileges to copy the task: ' + $TaskName + '. Please re-start the powershell with a admin user or the user account that created/owns the task.')
            }       
        }until ($CopyNumber++ -eq $NumberOfCopies)
    }

    }

    end {}
}
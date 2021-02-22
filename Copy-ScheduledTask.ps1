function Copy-ScheduledTask {
    param (
        [parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'URI', Position = 0)][string]$URI,
        [string]$Destination,
        [int]$NumberOfCopies = 1,
        [switch]$DeleteSourceTask = $false
    )

    begin {}

    process {
        [int]$CopyNumber = 1

        foreach ($TaskToCopy in $URI) {
            $TaskName = $TaskToCopy.Split('\')[-1]
    
            if ($Destination) {
                $TaskPath = $Destination
            }else {
                $TaskPath = $TaskToCopy.SubString(0,($TaskToCopy.LastIndexOf('\') +1))
            }
    

            do {
                if ($CopyNumber -eq 1 -and ($Destination)) {
                    $CopyTaskName = $TaskName 
                }
                elseif ($CopyNumber -eq 1) {
                    $CopyTaskName = $TaskName + ' - copy'
                }
                else {
                    $CopyTaskName = $TaskName + ' - copy ' + $CopyNumber
                }
            
                if ((Get-ScheduledTask -TaskName $CopyTaskName -TaskPath $TaskPath -ErrorAction Ignore).TaskName) {
                    $CopyTaskName = $TaskName + ' - copy ' + (New-Guid).Guid
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

    end {
        if ($DeleteSourceTask) {
            try {
                Unregister-ScheduledTask -TaskPath $TaskPath -TaskName $TaskName -Confirm:$false -ErrorAction Stop
            }
            catch {
                Write-Error ('You need elevated privileges to delete the task: ' + $TaskName + '. Please re-start the powershell as a admin user.')
            }
            Write-Warning ('Task: ' + $URI + ' deleted.')
        }
    }
}
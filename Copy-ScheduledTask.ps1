function Copy-ScheduledTask {
    param (
        [parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'URI', Position = 0)][string]$URI,
        [string]$Destination,
        [string]$NameOfCopy,
        [int]$Copies = 1,
        [switch]$DisableCopy = $false,
        [switch]$DeleteSourceTask = $false
    )

    begin {}

    process {
        [int]$CopyNumber = 1

        foreach ($TaskToCopy in $URI) {

            if ($NameOfCopy) {
                $TaskName = $NameOfCopy
            }
            else {
                $TaskName = $TaskToCopy.Split('\')[-1]
            }
    
            if ($Destination) {
                $TaskPath = $Destination
            }
            else {
                $TaskPath = $TaskToCopy.SubString(0, ($TaskToCopy.LastIndexOf('\') + 1))
            }

            do {
                if ($Destination) {
                    if ($CopyNumber -eq 1) {
                        $CopyTaskName = $TaskName
                    }
                    else {
                        if (($CopyNumber - 1) -eq 1) {
                            $CopyTaskName = $TaskName + ' - copy'
                        }
                        else {
                            $CopyTaskName = $TaskName + ' - copy ' + ($CopyNumber - 1)
                        } 
                    }
                }

                if ($NameOfCopy) {
                    if ($CopyNumber -eq 1) {
                        $CopyTaskName = $TaskName
                    }
                    else {
                        if (($CopyNumber - 1) -eq 1) {
                            $CopyTaskName = $TaskName + ' - copy'
                        }
                        else {
                            $CopyTaskName = $TaskName + ' - copy ' + ($CopyNumber - 1)
                        } 
                    }
                }

                else {
                    if ($CopyNumber -eq 1) {
                        $CopyTaskName = $TaskName + ' - copy'
                    }
                    else {
                        $CopyTaskName = $TaskName + ' - copy ' + $CopyNumber
                    }    
                }
            
                if ((Get-ScheduledTask -TaskName $CopyTaskName -TaskPath $TaskPath -ErrorAction Ignore).TaskName) {
                    $CopyTaskName = $TaskName + ' - copy ' + (New-Guid).Guid
                }
            
                try {
                    if ($DisableCopy) {
                        Register-ScheduledTask -TaskName $CopyTaskName -TaskPath $TaskPath -Xml (Export-ScheduledTask $URI) -ErrorAction Stop | Disable-ScheduledTask
                    }
                    else {
                        Register-ScheduledTask -TaskName $CopyTaskName -TaskPath $TaskPath -Xml (Export-ScheduledTask $URI) -ErrorAction Stop
                    }
                }
                catch {
                    Write-Error ('You need elevated privileges to copy the task: ' + $TaskName + '. Please re-start the powershell with a admin user or the user account that created/owns the task.')
                }
                
            }until ($CopyNumber++ -eq $Copies)
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
function Copy-ScheduledTask {
    param (
        [parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'URI', Position = 0)][string]$URI,
        [parameter(ValueFromPipelineByPropertyName, DontShow)][string]$TaskName,
        [parameter(ValueFromPipelineByPropertyName, DontShow)][string]$TaskPath,
        [int]$NumberOfCopies = 1,
        [switch]$DeleteSourceTask = $false
    )

    begin {
        [int]$CopyNumber = 1
    }

    process {
        foreach ($TaskToCopy in $URI) {
            do {
                if ($CopyNumber -eq 1) {
                    $TaskName = $TaskName + ' - copy'
                }
                else {
                    $TaskName = $TaskName + ' - copy ' + $CopyNumber
                }
            
                # if ($TaskName -eq (Get-ScheduledTask $TaskName).TaskName) {
                #     $TaskName = $URI.Split("\")[2] + ' - copy ' + (New-Guid).Guid
                # }
            
            
            try {
                Register-ScheduledTask -TaskName $TaskName -TaskPath $TaskPath -Xml (Export-ScheduledTask $URI) -ErrorAction Stop
            }
            catch {
                Write-Error ('You need elevated privileges to copy the task: ' + $TaskName + '. Please re-start the powershell with a admin user or the user account that created/owns the task.')
            }       
            $NumberOfCopies 
            $CopyNumber
            $CopyNumber++
        }until ($CopyNumber -eq $NumberOfCopies)
    }

    }

    end {}
}
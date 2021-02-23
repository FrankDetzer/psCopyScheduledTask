
# Copy-ScheduledTask

## SYNOPSIS
Creates a copy of a scheduled task.

## SYNTAX

```
Get-ScheduledTask [[-URI] <String[]>] [-Destination <String>]  [-NameOfCopy <String>]  [-Copies <Int32>] [-DisableNewTask] [-DeleteSourceTask]
```

## DESCRIPTION
The **Copy-ScheduledTask** cmdlet copies the task definition object of a scheduled task that is registered on a computer.

## EXAMPLES

### Example 1: Copy a scheduled task definition object
```
PS C:\> Get-ScheduledTask -TaskName "SystemScan" | Copy-ScheduledTask
TaskPath                          TaskName                        State
--------                          --------                        --------
\                                 SystemScan - copy               Ready
```

This command copies the definition object of the SystemScan scheduled task in the root folder.

### Example 2: Copy a scheduled task definition object and renames it.
```
PS C:\> Get-ScheduledTask -TaskName "SystemScan" | Copy-ScheduledTask -NewTaskName "OldSystemScan"
TaskPath                          TaskName                        State
--------                          --------                        --------
\                                 OldSystemScan                   Ready
```

This command copies the definition object of the SystemScan scheduled task in the root folder and renames the copy.

### Example 3: Copy an array of scheduled task definition objects to another folder and disable the new Tasks.
```
PS C:\> Get-ScheduledTask -TaskPath "\UpdateTasks\*" | Copy-ScheduledTask -Destination \Backup -DisableNewTask
TaskPath                          TaskName                        State
--------                          --------                        --------
\Backup                           UpdateApps                      Disabled
\Backup                           UpdateDrivers                   Disabled
\Backup                           UpdateOS                        Disabled
\Backup                           UpdateSignatures                Disabled
```

This command copies an array of task definitions objects from the UpdateTasks folder to the (not yet existing) Backup folder and disables the backups.

### Example 4: Copies an array of scheduled task definition objects from multiple paths and creates 5 copies each.
```powershell
Get-ScheduledTask -TaskPath "\Microsoft\Windows\Work Folders\","\Microsoft\Windows\Workplace Join\"

TaskPath                                       TaskName                          State
--------                                       --------                          -----
\Microsoft\Windows\Work Folders\               Work Folders copy                 Ready
\Microsoft\Windows\Work Folders\               Work Folders copy 1               Ready
\Microsoft\Windows\Work Folders\               Work Folders copy 2               Ready
\Microsoft\Windows\Work Folders\               Work Folders copy 3               Ready
\Microsoft\Windows\Work Folders\               Work Folders copy 4               Ready
\Microsoft\Windows\Workplace Join\             Device-Sync copy                  Disabled
\Microsoft\Windows\Workplace Join\             Device-Sync copy 1                Disabled
\Microsoft\Windows\Workplace Join\             Device-Sync copy 2                Disabled
\Microsoft\Windows\Workplace Join\             Device-Sync copy 3                Disabled
\Microsoft\Windows\Workplace Join\             Device-Sync copy 4                Disabled
```

This command gets task definition objects from multiple task paths

## PARAMETERS

### URI
Defines the URI (full path including the name) of the source object. 

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Destination
Defines the target path of the copy.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NameOfCopy
Specifies the new name of a scheduled task. If you leave this parameter blank the original name of the task will be used.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position:
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Copies
Specifies the amout of copies that will be created.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -DisableCopy
This Switch will disable the copy of the new task. 

```yaml
Type: Switch
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeleteSourceTask
This Switch will delete the source task.

```yaml
Type: Switch
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```
## INPUTS

### Microsoft.Management.Infrastructure.CimInstance#MSFT_ScheduledTask[]

## OUTPUTS

## NOTES

## RELATED LINKS
[Blogpost on frankdetzer.com](https://frankdetzer.com/release-of-copy-scheduledtask/)

[Repository on Github](https://github.com/FrankDetzer/psCopyScheduledTask)

## RELATED MICROSOFT LINKS
[Get-ScheduledTask](https://docs.microsoft.com/en-us/powershell/module/scheduledtasks/get-scheduledtask)

[Disable-ScheduledTask](https://docs.microsoft.com/en-us/powershell/module/scheduledtasks/disable-scheduledtask)

[Enable-ScheduledTask](https://docs.microsoft.com/en-us/powershell/module/scheduledtasks/enable-scheduledtask)

[Export-ScheduledTask](https://docs.microsoft.com/en-us/powershell/module/scheduledtasks/export-scheduledtask)

[New-ScheduledTask](https://docs.microsoft.com/en-us/powershell/module/scheduledtasks/new-scheduledtask)

[Register-ScheduledTask](.https://docs.microsoft.com/en-us/powershell/module/scheduledtasks/register-scheduledtask)

[Set-ScheduledTask](https://docs.microsoft.com/en-us/powershell/module/scheduledtasks/set-scheduledtask)

[Start-ScheduledTask](https://docs.microsoft.com/en-us/powershell/module/scheduledtasks/start-scheduledtask)

[Stop-ScheduledTask](https://docs.microsoft.com/en-us/powershell/module/scheduledtasks/stop-scheduledtask)

[Unregister-ScheduledTask](https://docs.microsoft.com/en-us/powershell/module/scheduledtasks/unregister-scheduledtask)
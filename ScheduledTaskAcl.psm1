function Get-ScheduledTaskAcl {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Task
    )

    begin {
        $scheduler = New-Object -ComObject "Schedule.Service"
        $scheduler.Connect()
    }

    process {
        $Task | ForEach-Object {
            try {
                $folder = $scheduler.GetFolder($_.TaskPath)
                $TaskX = $folder.GetTask($_.TaskName)
                ConvertFrom-SddlString($TaskX.GetSecurityDescriptor(0xF))
            }
            catch {
                Write-Error $_
            }
        }
    }

    end {
    }
}

# Set-ScheduledTaskAcl($SecurityDescriptor)
# {
#     $Scheduler = New-Object -ComObject "Schedule.Service"

#     $task = Get-ScheduledTask -TaskPath $TaskPath -TaskName $TaskName
#     $TaskX = $Scheduler.GetFolder($task.TaskPath).GetTask($task.TaskName)

#     $TaskX.SetSecurityDescriptor($SecurityDescriptor.sddl, 0x0)
# }

# # IdentityReference Property   System.Security.Principal.IdentityReference IdentityReference {get;}
# Grant-ScheduledTaskAcl($TaskPath, $TaskName, $Identity, $Rights)
# {

# }

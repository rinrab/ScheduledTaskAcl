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
                $TaskX.GetSecurityDescriptor(0xF)
            }
            catch {
                Write-Error $_
            }
        }
    }

    end {
    }
}

function Grant-ScheduledTaskAcl {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Task,

        [Parameter(Mandatory, Position = 1)]
        [string]
        $Identity,
        
        [Parameter(Mandatory, Position = 2)]
        [string]
        $Rights
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
                $TaskX.SetSecurityDescriptor($SecurityDescriptor.Ssdl, 0x0)
            }
            catch {
                Write-Error $_
            }
        }
    }

    end {
    }
}

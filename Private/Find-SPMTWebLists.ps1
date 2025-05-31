function Remove-SPMTUnsupportedList {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [Microsoft.SharePoint.SPList]$List,

        [switch]$Force
    )

    process {
        $title = $List.Title
        $url = $List.ParentWeb.Url + "/" + $List.RootFolder.Url

        if ($Force -or $PSCmdlet.ShouldProcess($title, "Delete unsupported list")) {
            try {
                $List.AllowDeletion = $true
                $List.Update()
                $List.Delete()
                Write-Host "✅ Deleted list: $title" -ForegroundColor Green
            } catch {
                Write-Host "❌ Initial delete failed for '$title': $($_.Exception.Message)" -ForegroundColor Red

                $confirm = Read-Host "⚠️  Do you want to force retry deleting '$title'? (y/n)"
                if ($confirm -eq "y") {
                    try {
                        $List.AllowDeletion = $true
                        $List.Update()
                        $List.Delete()
                        Write-Host "✅ Force-deleted: $title" -ForegroundColor Green
                    } catch {
                        Write-Host "❌ Could not force delete '$url': $($_.Exception.Message)" -ForegroundColor Red
                    }
                } else {
                    Write-Host "🛑 Skipped: $title" -ForegroundColor DarkGray
                }
            }
        }
    }
}

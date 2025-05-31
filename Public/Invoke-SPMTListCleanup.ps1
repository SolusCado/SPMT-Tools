function Invoke-SPMTListCleanup {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$SiteUrl
    )

    Write-Host "Starting cleanup scan for: $SiteUrl" -ForegroundColor Cyan

    try {
        $site = Get-SPSite $SiteUrl

        # 1. Clean up known-bad lists automatically
        $knownBad = Get-SPMTUnsupportedLists -SiteUrl $SiteUrl
        foreach ($list in $knownBad) {
            try {
                Write-Host "Removing known list: '$($list.Title)' ($($list.ItemCount) items)" -ForegroundColor Yellow
                $list.ParentWeb.Lists.Delete($list.ID)
                Write-Host "Removed: $($list.Title)" -ForegroundColor Green
            } catch {
                Write-Warning "Failed to remove $($list.Title): $($_.Exception.Message)"
                $retry = Read-Host "Try force delete? (y/n)"
                if ($retry -eq "y") {
                    try {
                        Remove-SPMTUnsupportedList -List $list -Force
                    } catch {
                        Write-Warning "Force delete failed: $($_.Exception.Message)"
                    }
                }
            }
        }

        # 2. Ask to scan for hidden lists
        $doScan = Read-Host "`nScan for additional hidden lists? (y/n)"
        if ($doScan -eq "y") {
            $hidden = Get-SPMTHiddenLists -SiteUrl $SiteUrl
            foreach ($list in $hidden) {
                $response = Read-Host "Hidden list found: '$($list.Title)' ($($list.ItemCount) items) - Delete? (y/n)"
                if ($response -eq "y") {
                    try {
                        $list.ParentWeb.Lists.Delete($list.ID)
                        Write-Host "Deleted: $($list.Title)" -ForegroundColor Green
                    } catch {
                        Write-Warning "Failed to delete $($list.Title): $($_.Exception.Message)"
                        $retry = Read-Host "Try force delete? (y/n)"
                        if ($retry -eq "y") {
                            try {
                                Remove-SPMTUnsupportedList -List $list -Force
                            } catch {
                                Write-Warning "Force delete failed: $($_.Exception.Message)"
                            }
                        }
                    }
                }
            }
        }

        $site.Dispose()
        Write-Host "`nCleanup scan complete." -ForegroundColor Green
    } catch {
        Write-Host "Failed to open site: $($_.Exception.Message)" -ForegroundColor Red
    }
}

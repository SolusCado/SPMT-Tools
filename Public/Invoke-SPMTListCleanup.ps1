function Invoke-SPMTListCleanup {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$SiteUrl
    )

    Write-Host "🔍 Starting cleanup scan for: $SiteUrl" -ForegroundColor Cyan

    try {
        $site = Get-SPSite $SiteUrl
        _Scan-SPMTWebLists -Web $site.RootWeb
        $site.Dispose()
        Write-Host "`n✅ Cleanup scan complete." -ForegroundColor Green
    } catch {
        Write-Host "❌ Failed to open site: $($_.Exception.Message)" -ForegroundColor Red
    }
}

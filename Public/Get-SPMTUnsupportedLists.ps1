function Get-SPMTUnsupportedLists {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$SiteUrl
    )

    $knownBadPatterns = @(
        "Quick Deploy",
        "Notification",
        "Device Channel",
        "Relationships List"
    )

    $problemLists = @()

    try {
        $site = Get-SPSite $SiteUrl

        function Find-ProblemLists([Microsoft.SharePoint.SPWeb]$Web) {
            foreach ($list in $Web.Lists) {
                if ($list.Hidden -and $list.Title -match ($knownBadPatterns -join "|")) {
                    $problemLists += $list
                }
            }

            foreach ($subweb in $Web.Webs) {
                Find-ProblemLists -Web $subweb
                $subweb.Dispose()
            }
        }

        Find-ProblemLists -Web $site.RootWeb
        $site.Dispose()
    } catch {
        Write-Host "❌ Error accessing site: $($_.Exception.Message)" -ForegroundColor Red
    }

    return $problemLists
}

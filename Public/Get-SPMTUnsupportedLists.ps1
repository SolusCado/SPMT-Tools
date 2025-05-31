function Get-SPMTUnsupportedLists {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$SiteUrl
    )

    # Load KnownBadLists hashtable from data file
    . "$PSScriptRoot\..\KnownBadLists.ps1"

    $problemLists = @()

    try {
        $site = Get-SPSite $SiteUrl

        function Find-ProblemLists([Microsoft.SharePoint.SPWeb]$Web) {
            foreach ($list in $Web.Lists) {
                if ($list.Hidden -and $KnownBadLists.ContainsKey($list.Title)) {
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

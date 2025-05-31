function Get-SPMTHiddenLists {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$SiteUrl
    )

    $hiddenLists = New-Object System.Collections.ArrayList

    try {
        $site = Get-SPSite $SiteUrl

        function Find-HiddenLists([Microsoft.SharePoint.SPWeb]$Web) {
            foreach ($list in $Web.Lists) {
                if ($list.Hidden) {
                    [void]$hiddenLists.Add($list)
                }
            }

            foreach ($subweb in $Web.Webs) {
                Find-HiddenLists -Web $subweb
                $subweb.Dispose()
            }
        }

        Find-HiddenLists -Web $site.RootWeb
        $site.Dispose()
    }
    catch {
        Write-Host "Error accessing site: $($_.Exception.Message)" -ForegroundColor Red
    }

    return $hiddenLists
}

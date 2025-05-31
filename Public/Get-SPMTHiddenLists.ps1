function Get-SPMTHiddenLists {
    <#
    .SYNOPSIS
        Returns all hidden SharePoint lists within a site collection (including subwebs).

    .DESCRIPTION
        This function scans the specified SharePoint site collection and its subsites
        for any lists where the Hidden property is set to true. These lists may warrant
        additional review before migration to SharePoint Online using SPMT.

    .PARAMETER SiteUrl
        The URL of the SharePoint site collection to scan.

    .EXAMPLE
        Get-SPMTHiddenLists -SiteUrl "http://sharepoint2013/sites/demo"

    .NOTES
        Author: Michael Bailey
        Module: BaileyPoint.SPMT.Tools
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$SiteUrl
    )

    $hiddenLists = @()

    try {
        $site = Get-SPSite $SiteUrl

        function Find-HiddenLists([Microsoft.SharePoint.SPWeb]$Web) {
            foreach ($list in $Web.Lists) {
                if ($list.Hidden) {
                    $hiddenLists += $list
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
        Write-Host "❌ Error accessing site: $($_.Exception.Message)" -ForegroundColor Red
    }

    return $hiddenLists
}

function Remove-SPMTUnsupportedList {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true)]
        [Microsoft.SharePoint.SPList]$List,

        [switch]$Force
    )

    $title = $List.Title
    $url = $List.ParentWeb.Url + "/" + $List.RootFolder.Url

    if ($Force -or $PSCmdlet.ShouldProcess($title, "Delete unsupported list")) {
        try {
            $List.AllowDeletion = $true
            $List.Update()
            $List.Delete()
            Write-Host "Deleted list: $title" -ForegroundColor Green
        } catch {
            Write-Warning "Force delete failed for [$title] at [$url]: $($_.Exception.Message)"
        }
    }
}

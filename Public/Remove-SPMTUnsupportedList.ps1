function Remove-SPMTUnsupportedList {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [Microsoft.SharePoint.SPList]$List
    )

    process {
        try {
            $List.AllowDeletion = $true
            $List.Update()
            $List.Delete()
            Write-Host "✅ Deleted list: $($List.Title)" -ForegroundColor Green
        } catch {
            Write-Host "❌ Could not delete $($List.Title): $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

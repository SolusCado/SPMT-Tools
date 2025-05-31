@{
    RootModule        = 'BaileyPoint.SPMT.Tools.psm1'
    ModuleVersion     = '0.1.0'
    GUID              = 'd1a2b73f-c4fa-42cf-b3e1-92c0aa3fa9df'
    Author            = 'Michael Bailey'
    CompanyName       = 'BaileyPoint'
    Description       = 'PowerShell tools to identify and remove unsupported SharePoint lists before SPMT migration.'
    PowerShellVersion = '5.1'
    FunctionsToExport = @(
        'Invoke-SPMTListCleanup',
        'Get-SPMTUnsupportedLists',
        'Remove-SPMTUnsupportedList'
    )
    PrivateData = @{
        PSData = @{
            Tags         = @('SPMT','SharePoint','Migration','Cleanup','OnPrem')
            ProjectUri   = 'https://github.com/SolusCado/SPMT-Tools'
            LicenseUri   = 'https://opensource.org/licenses/MIT'
        }
    }
}

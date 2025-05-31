# Load internal functions (Private)
Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 | ForEach-Object { . $_.FullName }

# Load public-facing commands (Public)
Get-ChildItem -Path $PSScriptRoot\Public\*.ps1  | ForEach-Object { . $_.FullName }

# Only export intended public functions
Export-ModuleMember -Function @(
    'Invoke-SPMTListCleanup', 
    'Get-SPMTUnsupportedLists', 
    'Get-SPMTHiddenLists', 
    'Remove-SPMTUnsupportedList'
)

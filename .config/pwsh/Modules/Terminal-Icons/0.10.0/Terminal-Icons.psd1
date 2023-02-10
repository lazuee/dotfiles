@{
    RootModule        = 'Terminal-Icons.psm1'
    ModuleVersion     = '0.10.0'
    GUID              = '4419ddb6-3528-47cd-baf3-7fb9d8566620'
    Author            = 'Brandon Olin'
    CompanyName       = 'Community'
    Copyright         = '(c) Brandon Olin. All rights reserved.'
    Description       = 'PowerShell module to add file icons to terminal based on file extension'
    PowerShellVersion = '5.1'
    # PowerShellHostName = ''
    # PowerShellHostVersion = ''
    RequiredModules = @()
    FunctionsToExport = @('Add-TerminalIconsColorTheme','Add-TerminalIconsIconTheme','Format-TerminalIcons','Get-TerminalIconsColorTheme','Get-TerminalIconsGlyphs','Get-TerminalIconsIconTheme','Get-TerminalIconsTheme','Remove-TerminalIconsTheme','Set-TerminalIconsIcon','Set-TerminalIconsTheme','Show-TerminalIconsTheme')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
    PrivateData       = @{
        PSData = @{
            Tags         = @('Color', 'Terminal', 'Console', 'NerdFonts', 'Icon')
            LicenseUri   = 'https://raw.githubusercontent.com/devblackops/Terminal-Icons/master/LICENSE'
            ProjectUri   = 'https://github.com/devblackops/Terminal-Icons'
            IconUri      = 'https://github.com/devblackops/Terminal-Icons/raw/master/media/icon_256.png'
            ReleaseNotes = 'https://raw.githubusercontent.com/devblackops/Terminal-Icons/master/CHANGELOG.md'
        }
    }
}

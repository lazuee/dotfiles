$PSDefaultParameterValues["Out-File:Encoding"] = "utf8"
$ErrorActionPreference = "SilentlyContinue"

Import-Module "$( $ENV:DOTFILES_DIR )/config/komorebi/helpers.psm1" -DisableNameChecking
Import-Module "$( $ENV:DOTFILES_DIR )/config/powershell/helpers.psm1" -DisableNameChecking
Import-Module "$( $ENV:DOTFILES_DIR )/config/powershell/launch.psm1" -DisableNameChecking

Import-Module-Verified "posh-git"
Import-Module-Verified "Terminal-Icons"
Import-Module-Verified "cd-extras"

# Aliases
Set-Alias code codium
Set-Alias py python

# Prompt
if (Get-Command "starship" -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}

# Fix Prompt
Clear-Host

Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser

$PSDefaultParameterValues["Out-File:Encoding"] = "utf8"
$ErrorActionPreference = "SilentlyContinue"

if (!(([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
    Write-Host "You need to run this script as Administrator to proceed."
    Read-Host "Press Enter to continue setup..."

    $script_dir = Split-Path -Parent $MyInvocation.MyCommand.Path
    $script_file = Split-Path -Leaf $MyInvocation.MyCommand.Path

    if ($PSVersionTable.PSEdition -eq "Desktop") {
        Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -NoExit -Command `"Set-Location $( $script_dir ); & .\$( $script_file )`"" -Verb RunAs
    } else {
        Start-Process -FilePath "pwsh.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -NoExit -Command `"Set-Location $( $script_dir ); & .\$( $script_file )`"" -Verb RunAs
    }

    exit 1
}

Write-Host "Changing Theme to Catppuccin Mocha"
fetcher --url="https://github.com/khaneliman/dotfiles/tree/main/dots/windows/komorebi/themes/Explorer" --out="$( $ENV:TEMP )"
Remove-Item "C:\Windows\Resources\Themes\*Catppuccin*" -Recurse -Force
Copy-Item -Path "$( $ENV:TEMP )\Explorer\*" -Destination "C:\Windows\Resources\Themes" -Recurse -Force
Remove-Item "$( $ENV:TEMP )\Explorer" -Recurse -Force

Start-Process -Filepath "C:\Windows\Resources\Themes\Catppuccin-Mocha.theme"
Start-Sleep -Seconds 5
Stop-Process -Name "systemsettings"

$SystemColor = "#8357BF" # Change the value
Write-Host "Changing System Color to $( $SystemColor )"
Start-Process -Wait -FilePath "pwsh.exe" -ArgumentList "-WindowStyle hidden -NoProfile -ExecutionPolicy Bypass -Command `"Import-Module `"$( $ENV:DOTFILES_DIR )/config/powershell/helpers.psm1`" -DisableNameChecking; Set-SystemColor -Color '$SystemColor';`""


Read-Host "paused"
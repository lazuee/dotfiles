
function Start-Tiling {

    if (!(Test-Path -Path "$( $ENV:HOME )/scoop/apps/komorebi/current/komorebic.exe")) {
        throw "Komorebi is not installed. Please install Komorebi before running this function."
    }
    if (!(Test-Path -Path "$( $ENV:HOME )/scoop/apps/autohotkey/current/v2/AutoHotkey64.exe")) {
        throw "AutoHotkey is not installed. Please install AutoHotkey before running this function."
    }

	
    Stop-Tiling -ErrorAction SilentlyContinue

	Start-Process komorebi.exe -ArgumentList '--await-configuration' -WindowStyle hidden
	while ((Get-Process -Name "komorebi" -ErrorAction SilentlyContinue).Count -eq 0) {
        Start-Sleep -Milliseconds 400
    }
	
	Write-Host "$PSScriptRoot\komorebi.generated.ps1"
    . "$PSScriptRoot\komorebi.generated.ps1"
	
	# Send the ALT key whenever changing focus to force focus changes
	komorebic alt-focus-hack enable
	# Default to minimizing windows when switching workspaces
	komorebic window-hiding-behaviour cloak
	# Set cross-monitor move behaviour to insert instead of swap
	komorebic cross-monitor-move-behaviour insert
	# Enable hot reloading of changes to this file
	komorebic watch-configuration enable
	# enable focus following the mouse
	komorebic toggle-focus-follows-mouse --implementation komorebi
	
	komorebic complete-configuration
}

function Stop-Tiling {
    if (!(Test-Path -Path "$( $ENV:HOME )/scoop/apps/komorebi/current/komorebic.exe")) {
        throw "Komorebi is not installed. Please install Komorebi before running this function."
    }
    if (!(Test-Path -Path "$( $ENV:HOME )/scoop/apps/autohotkey/current/v2/AutoHotkey64.exe")) {
        throw "AutoHotkey is not installed. Please install AutoHotkey before running this function."
    }
    if (Get-Process | Where-Object { $_.Name -eq "komorebi" }) {
        komorebic restore-windows
        komorebic retile
        komorebic stop
    }
    Start-Sleep 3
    Get-Process | Where-Object { $_.Name -eq "komorebi" } | Stop-Process
}

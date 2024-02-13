function UninstallUWPApps {
    $ExcludedAppxPackages = @(
        "RealtekSemiconductorCorp.RealtekAudioControl",
        "Microsoft.DesktopAppInstaller"
    )

    Get-AppxPackage -PackageTypeFilter Bundle -AllUsers | Where-Object -FilterScript { $_.Name -cnotmatch ($ExcludedAppxPackages -join "|") } | Remove-AppxPackage -AllUsers
}

function DisableBackgroundUWPApps {
    Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Name "BackgroundAppGlobalToggle" -Type DWord -Value 0
    Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Name "GlobalUserDisabled" -Type DWord -Value 1
    Get-ChildItem -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" | ForEach-Object -Process {
        Remove-ItemProperty -Path $_.PsPath -Name * -Force
    }

    $OFS = "|"
    Get-ChildItem -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" | ForEach-Object -Process {
        Set-ItemProperty-Verified -Path $_.PsPath -Name Disabled -Type DWord -Value 1
        Set-ItemProperty-Verified -Path $_.PsPath -Name DisabledByUser -Type DWord -Value 1
    }
    $OFS = " "
}

function DisableWindowsFeatures {
    $ExcludedWindowsFeatures = @(
        "MediaPlayback",
        "MicrosoftWindowsPowerShell*",
        "SearchEngine*",
        "NetFx*",
        "WCF-*"
    )
    $FeatureNames = Get-WindowsOptionalFeature -Online | Where-Object { ($_.State -eq "Enabled") -and ($_.FeatureName -cnotmatch ($ExcludedWindowsFeatures -join "|")) } | Select-Object -ExpandProperty FeatureName
    if ($FeatureNames) {
        Disable-WindowsOptionalFeature -Online -FeatureName $FeatureNames -NoRestart
    }
}

function DisableWindowsCapabilities {
    $ExcludedCapabilities = @(
        "Language.*",
        "DirectX.Configuration.Database*",
        "Windows.Client.ShellComponents*",
        "Microsoft.Windows.Ethernet*",
        "Microsoft.Windows.Wifi*",
        "Windows.Kernel*",
        "WMIC"
    )

    Get-WindowsCapability -Online | Where-Object -FilterScript { ($_.State -eq "Installed") -and ($_.Name -cnotmatch ($ExcludedCapabilities -join "|")) } | Remove-WindowsCapability -Online

}

function DisableCortanaAutostart {
    if (Get-AppxPackage -Name Microsoft.549981C3F5F10) {
        Set-ItemProperty-Verified -Path "Registry::HKCR:\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\SystemAppData\Microsoft.549981C3F5F10_8wekyb3d8bbwe\CortanaStartupId" -Name State -Type DWord -Value 1
    }
    Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" -Name AcceptedPrivacyPolicy -Type DWord -Value 0
}

Function DisableStartupApps {
    $StartPaths = @(
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run32\",
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\",
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run\",
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run\",
        "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\",
        "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce\",
        "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run\"
    )

    $removeList = @(
        "*EADM*", "*Java*", "*CCX*", "*cisco*", "*vivaldi", "*NV*", "*npcap*", "*Edge*",
        "*Brave*", "*Riot*", "*IDMan*", "*Teams*", "*Disc*", "*Epic*", "*CORS*", "*Next*",
        "*One*", "*Chrome*", "*Opera*", "*iTunes*", "*CC*", "*Vanguard*", "*Update*",
        "*iTunes*", "*Ai*", "*Skype*", "*Yandex*", "*uTorrent*", "*Deluge*", "*Blitz*",
        "*vmware*", "*Any*", "Teams*"
    )

    foreach ($path in $StartPaths) {
        foreach ($item in $removeList) {
            try {
                Remove-ItemProperty -Path $path -Name $item -ErrorAction SilentlyContinue
            }
            catch {
                # Do nothing
            }
        }
    }

    foreach ($folder in $StartFilePaths) {
        Get-ChildItem -Path $folder -Recurse |
        Where-Object { $removeList -contains $_.Name } |
        Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
    }

}

function OOShutup {
    $exePath = "$ENV:TEMP/OOSU10.exe"
    if (-not (Test-Path $exePath -PathType Leaf)) {
        Import-Module-Verified BitsTransfer
        Start-BitsTransfer -Source "https://dl5.oo-software.com/files/ooshutup10/OOSU10.exe" -Destination $exePath
    }
    Start-Process $exePath -ArgumentList "`"$( Get-Location )\fresh\ooshutup.cfg`" /quiet"
}

function UninstallOneDrive {
    $UninstallString = Get-Package -Name "Microsoft OneDrive" -ProviderName Programs -ErrorAction Ignore | ForEach-Object -Process { $_.Meta.Attributes["UninstallString"] }
    if ($UninstallString) {
        Stop-Process -Name OneDrive -Force -ErrorAction SilentlyContinue
        Stop-Process -Name OneDriveSetup -Force -ErrorAction SilentlyContinue
        Stop-Process -Name FileCoAuth -Force -ErrorAction SilentlyContinue

        [string[]]$OneDriveSetup = ($UninstallString -Replace ("\s*/", ",/")).Split(",").Trim()
        if ($OneDriveSetup.Count -eq 2) {
            Start-Process -FilePath $OneDriveSetup[0] -ArgumentList $OneDriveSetup[1..1] -Wait
        }
        else {
            Start-Process -FilePath $OneDriveSetup[0] -ArgumentList $OneDriveSetup[1..2] -Wait
        }

        $OneDriveUserFolder = Get-ItemPropertyValue -Path "HKCU:\Environment" -Name OneDrive
        if ((Get-ChildItem -Path $OneDriveUserFolder | Measure-Object).Count -eq 0) {
            Remove-Item -Path $OneDriveUserFolder -Recurse -Force
        }
        else {
            Write-Error "The $OneDriveUserFolder folder is not empty Delete it manually"
            Invoke-Item -Path $OneDriveUserFolder
        }

        Remove-ItemProperty -Path "HKCU:\Environment" -Name "OneDrive", "OneDriveConsumer" -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "HKCU:\SOFTWARE\Microsoft\OneDrive" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\OneDrive" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "$ENV:ProgramData\Microsoft OneDrive" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "$ENV:SYSTEMDRIVE\OneDriveTemp" -Recurse -Force -ErrorAction SilentlyContinue
        Unregister-ScheduledTask -TaskName *OneDrive* -Confirm:$false

        $OneDriveFolder = Split-Path -Path (Split-Path -Path $OneDriveSetup[0] -Parent)

        Clear-Variable -Name OpenedFolders -Force -ErrorAction SilentlyContinue
        $OpenedFolders = { (New-Object -ComObject Shell.Application).Windows() | ForEach-Object -Process { $_.Document.Folder.Self.Path } }.Invoke()

        taskkill.exe /F /IM "explorer.exe"
        Start-Sleep -Seconds 5
        Start-Process explorer.exe
        Start-Sleep -Seconds 2

        $FileSyncShell64dlls = Get-ChildItem -Path "$OneDriveFolder\*\amd64\FileSyncShell64.dll" -Force
        foreach ($FileSyncShell64dll in $FileSyncShell64dlls.FullName) {
            Start-Process -FilePath regsvr32.exe -ArgumentList "/u /s $FileSyncShell64dll" -Wait
            Remove-Item -Path $FileSyncShell64dll -Recurse -Force -ErrorAction SilentlyContinue

            if (Test-Path -Path $FileSyncShell64dll) {
                Write-Error "$FileSyncShell64dll is blocked Delete it manually"
            }
        }

        foreach ($OpenedFolder in $OpenedFolders) {
            if (Test-Path -Path $OpenedFolder) {
                Invoke-Item -Path $OpenedFolder
            }
        }

        Remove-Item -Path "$OneDriveFolder" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "$ENV:LOCALAPPDATA\OneDrive" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "$ENV:LOCALAPPDATA\Microsoft\OneDrive" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "$ENV:APPDATA\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk" -Force -ErrorAction SilentlyContinue
    }

    Start-Process cmd.exe -ArgumentList "/c winget uninstall OneDrive" -PassThru -Wait -WindowStyle Hidden
}

function HideOneDriveFileExplorerAd {
    Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name ShowSyncProviderNotifications -Type DWord -Value 0
}

function Performance {
    Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" -Name "(Default)" -Type String -Value $null
	Set-ItemProperty-Verified -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments" -Name "SaveZoneInformation" -Type DWord -Value 1
    Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Type DWord -Value 0
    Set-ItemProperty-Verified -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "FirstRunTelemetryComplete" -Type DWord -Value 0
    Set-ItemProperty-Verified -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "DesktopReadyTimeout" -Type DWord -Value 0
    Set-ItemProperty-Verified -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "ExplorerStartupTraceRecorded" -Type DWord -Value 0
    Set-ItemProperty-Verified -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "TelemetrySalt" -Type DWord -Value 0
	Set-ItemProperty-Verified -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowRecent" -Type DWord -Value 0
	Set-ItemProperty-Verified -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowCloudFilesInQuickAccess" -Type DWord -Value 0
	Set-ItemProperty-Verified -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowFrequent" -Type DWord -Value 0
    Set-ItemProperty-Verified -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "DisableDeviceEnumeration" -Type DWord -Value 1
    Set-ItemProperty-Verified -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowDevMgrUpdates" -Type DWord -Value 0
    Set-ItemProperty-Verified -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSyncProviderNotifications" -Type DWord -Value 0
    Set-ItemProperty-Verified -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "MMDevicesEnumerationEnabled" -Type DWord -Value 0
    Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Type DWord -Value 0
    Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "AutoCheckSelect" -Type DWord -Value 0
    Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Type DWord -Value 1
    Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "DisableThumbnailCache" -Type DWord -Value 1
    Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "DisableThumbsDBOnNetworkFolders" -Type DWord -Value 1
    Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "EnableSnapbar" -Type DWord -Value 0
    Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "EnableSnapAssistFlyout" -Type DWord -Value 0
    Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "EnableTaskGroups" -Type DWord -Value 0
    Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "SnapAssist" -Type DWord -Value 0
    Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "MultiTaskingAltTabFilter" -Type DWord -Value 3
    Set-ItemProperty-Verified -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ListviewAlphaSelect" -Type DWord -Value 0
    Set-ItemProperty-Verified -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ListviewShadow" -Type DWord -Value 0
    Set-ItemProperty-Verified -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSyncProviderNotifications" -Type DWord -Value 0
    Set-ItemProperty-Verified -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowInfoTip" -Type DWord -Value 0
    Set-ItemProperty-Verified -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Type DWord -Value 0
    Set-ItemProperty-Verified -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_ShowRun" -Type DWord -Value 1
    Set-ItemProperty-Verified -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "IconsOnly" -Type DWord -Value 1
    Set-ItemProperty-Verified -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "UseCompactMode" -Type DWord -Value 1
    Set-ItemProperty-Verified -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarDa" -Type DWord -Value 0
    Set-ItemProperty-Verified -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarMn" -Type DWord -Value 0
    Set-ItemProperty-Verified -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel" -Name "StartupPage" -Type DWord -Value 1
    Set-ItemProperty-Verified -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel" -Name "AllItemsIconView" -Type DWord -Value 0
    Set-ItemProperty-Verified -Path "HKCU:\Software\Microsoft\Windows\DWM" -Name "AlwaysHibernateThumbnails" -Type DWord -Value 0
    Set-ItemProperty-Verified -Path "HKCU:\Software\Microsoft\Windows\DWM" -Name "EnableWindowColorization" -Type DWord -Value 0
    Set-ItemProperty-Verified -Path "HKCU:\Software\Microsoft\Windows\DWM" -Name "EnableAeroPeek" -Type DWord -Value 0
    Set-ItemProperty-Verified -Path "HKCU:\Software\Microsoft\Windows\DWM" -Name "Blur" -Type DWord -Value 0
    Set-ItemProperty-Verified -Path "HKCU:\Control Panel\Desktop" -Name "EnablePerProcessSystemDPI" -Type String -Value 1
	Set-ItemProperty-Verified -Path "HKCU:\Control Panel\Desktop" -Name "ForegroundLockTimeout" -Type DWord -Value 0
	Set-ItemProperty-Verified -Path "HKCU:\Control Panel\Desktop" -Name "ForegroundFlashCount" -Type String -Value 0
	Set-ItemProperty-Verified -Path "HKCU:\Control Panel\Desktop" -Name "WaitToKillAppTimeout" -Type String -Value 25000
	Set-ItemProperty-Verified -Path "HKCU:\Control Panel\Desktop" -Name "HungAppTimeout" -Type String -Value 25000
	Set-ItemProperty-Verified -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Type String -Value 0
    Set-ItemProperty-Verified -Path "HKCU:\Control Panel\Desktop" -Name "MouseWheelRouting" -Type DWord -Value 0
    Set-ItemProperty-Verified -Path "HKCU:\Control Panel\Desktop" -Name "FontSmoothing" -Type String -Value 2
	Set-ItemProperty-Verified -Path "HKCU:\Control Panel\Desktop" -Name "AutoEndTasks" -Type String -Value 1
    Set-ItemProperty-Verified -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Type String -Value 0

	Set-ItemProperty-Verified -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "WaitToKillServiceTimeout" -Type String -Value 25000
	Set-ItemProperty-Verified -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" -Name "AutoChkTimeout" -Type DWord -Value 5
	Set-ItemProperty-Verified -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" -Name "StartupDelayInMSec" -Type DWord -Value 0
	Set-ItemProperty-Verified -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "LargeSystemCache" -Type DWord -Value 1
	Set-ItemProperty-Verified -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "DisablePagingExecutive" -Type DWord -Value 1
	Set-ItemProperty-Verified -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" -Name "EnablePrefetcher" -Type DWord -Value 0
	Set-ItemProperty-Verified -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" -Name "EnableSuperfetch" -Type DWord -Value 0
	Set-ItemProperty-Verified -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" -Name "EnableBootTrace" -Type DWord -Value 0
	Set-ItemProperty-Verified -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" -Name "SfTracingState" -Type DWord -Value 0
	Set-ItemProperty-Verified -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name HiberbootEnabled -Type DWord -Value 0

    Set-ItemProperty-Verified -Path "HKLM:\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\IO\None" -Name "IOBandwidth" -Type DWord -Value 0
    Set-ItemProperty-Verified -Path "HKLM:\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags" -Name "IsLowPriority" -Type DWord -Value 0
    Set-ItemProperty-Verified -Path "HKLM:\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\None" -Name "IsLowPriority" -Type DWord -Value 0
    Set-ItemProperty-Verified -Path "HKLM:\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\Foreground" -Name "IsLowPriority" -Type DWord -Value 0
    Set-ItemProperty-Verified -Path "HKLM:\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\Foreground" -Name "EnableForegroundBoost" -Type DWord -Value 1
    Set-ItemProperty-Verified -Path "HKLM:\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\BackgroundDefault" -Name "IsLowPriority" -Type DWord -Value 0
    Set-ItemProperty-Verified -Path "HKLM:\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\PrelaunchForeground" -Name "IsLowPriority" -Type DWord -Value 0
    Set-ItemProperty-Verified -Path "HKLM:\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\EstimateMemoryUsage" -Name "IsLowPriority" -Type DWord -Value 0
    Set-ItemProperty-Verified -Path "HKLM:\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\ThrottleGPUInterference" -Name "IsLowPriority" -Type DWord -Value 0

    Set-ItemProperty-Verified -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_EFSEFeatureFlags" -Type DWord -Value 0
    Set-ItemProperty-Verified -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_DSEBehavior" -Type DWord -Value 0
    Set-ItemProperty-Verified -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_FSEBehavior" -Type DWord -Value 2
    Set-ItemProperty-Verified -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_FSEBehaviorMode" -Type DWord -Value 2
    Set-ItemProperty-Verified -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_HonorUserFSEBehaviorMode" -Type DWord -Value 2
    Set-ItemProperty-Verified -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_DXGIHonorFSEWindowsCompatible" -Type DWord -Value 1
    Set-ItemProperty-Verified -Path "HKCU:\System\GameConfigStore" -Name "Win32_AutoGameModeDefaultProfile" -Value ([byte[]](0x01,0x00,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00)) -Type Binary;
    Set-ItemProperty-Verified -Path "HKCU:\System\GameConfigStore" -Name "Win32_GameModeRelatedProcesses" -Value ([byte[]](0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00)) -Type Binary;
    Set-ItemProperty-Verified -Path "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Type DWord -Value 26

    Set-ItemProperty-Verified -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" -Name "Affinity" -Type DWord -Value 0
    Set-ItemProperty-Verified -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" -Name "Background Only" -Type String -Value "True"
    Set-ItemProperty-Verified -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" -Name "BackgroundPriority" -Type DWord -Value 24
    Set-ItemProperty-Verified -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" -Name "Clock Rate" -Type DWord -Value 10000
    Set-ItemProperty-Verified -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" -Name "GPU Priority" -Type DWord -Value 12
    Set-ItemProperty-Verified -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" -Name "Priority" -Type DWord -Value 8
    Set-ItemProperty-Verified -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" -Name "Scheduling Category" -Type String -Value "High"
    Set-ItemProperty-Verified -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" -Name "SFIO Priority" -Type String -Value "High"

    Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\SettingSync" -Name "DisableSettingSyncUserOverride" -Type DWord -Value 1
    Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\SettingSync" -Name "DisableSyncYourSettings" -Type DWord -Value 1
    Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\SettingSync" -Name "DisableWebBrowser" -Type DWord -Value 1
    Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\SettingSync" -Name "DisablePersonalization" -Type DWord -Value 1
    Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\SettingSync" -Name "DisableSettingSync" -Type DWord -Value 2

    Set-ItemProperty-Verified -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "LongPathsEnabled" -Type DWord -Value 1
    Set-ItemProperty-Verified -Path "HKCU:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "LongPathsEnabled" -Type DWord -Value 1
    Set-ItemProperty-Verified -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name "AllowAllTrustedApps" -Type DWord -Value 1
    Set-ItemProperty-Verified -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name "AllowDevelopmentWithoutDevLicense" -Type DWord -Value 1

    {{
        {{{{{{}}}}}}
    }}
    $commands = @(
        "HKEY_CLASSES_ROOT\*\shellex\ContextMenuHandlers\EPP",
        "HKEY_CLASSES_ROOT\Directory\shellex\ContextMenuHandlers\EPP",
        "HKEY_CLASSES_ROOT\Drive\shellex\ContextMenuHandlers\EPP",
        "HKEY_LOCAL_MACHINE\Software\Classes\*\shellex\ContextMenuHandlers\ModernSharing",
        "HKEY_LOCAL_MACHINE\Software\Classes\*\shellex\ContextMenuHandlers\Sharing",
        "HKEY_LOCAL_MACHINE\Software\Classes\Drive\shellex\ContextMenuHandlers\Sharing",
        "HKEY_LOCAL_MACHINE\Software\Classes\Drive\shellex\PropertySheetHandlers\Sharing",
        "HKEY_LOCAL_MACHINE\Software\Classes\Directory\background\shellex\ContextMenuHandlers\Sharing",
        "HKEY_LOCAL_MACHINE\Software\Classes\Directory\shellex\ContextMenuHandlers\Sharing",
        "HKEY_LOCAL_MACHINE\Software\Classes\Directory\shellex\CopyHookHandlers\Sharing",
        "HKEY_LOCAL_MACHINE\Software\Classes\Directory\shellex\PropertySheetHandlers\Sharing"
    )
    foreach ($command in $commands) {
        $process = Start-Process cmd.exe -ArgumentList "/c reg delete '$command' /f" -PassThru -Wait -WindowStyle Hidden
    }

    Set-ItemProperty-Verified -Path "HKCU:\Control Panel\Sound" -Name "Beep" -Type String -Value no
    Set-Service beep -StartupType disabled *>&1 | Out-Null

    Enable-MMAgent -mc
    Set-SmbServerConfiguration -ServerHidden $False -AnnounceServer $False -Force
    Set-SmbServerConfiguration -EnableLeasing $false -Force
    Set-SmbClientConfiguration -EnableLargeMtu $true -Force

    auditpol /set /category:"Account Logon" /success:disable
    auditpol /set /category:"Account Logon" /failure:disable
    auditpol /set /category:"Account Management" /success:disable
    auditpol /set /category:"Account Management" /failure:disable
    auditpol /set /category:"DS Access" /success:disable
    auditpol /set /category:"DS Access" /failure:disable
    auditpol /set /category:"Logon/Logoff" /success:disable
    auditpol /set /category:"Logon/Logoff" /failure:disable
    auditpol /set /category:"Object Access" /success:disable
    auditpol /set /category:"Object Access" /failure:disable
    auditpol /set /category:"Policy Change" /success:disable
    auditpol /set /category:"Policy Change" /failure:disable
    auditpol /set /category:"Privilege Use" /success:disable
    auditpol /set /category:"Privilege Use" /failure:disable
    auditpol /set /category:"Detailed Tracking" /success:disable
    auditpol /set /category:"Detailed Tracking" /failure:disable
    auditpol /set /category:"System" /success:disable
    auditpol /set /category:"System" /failure:disable
}

function FixTimers {
    diskperf -N
    bcdedit /timeout 1
    $logicalProcessors = (Get-CimInstance Win32_ComputerSystem).NumberOfLogicalProcessors
    $cores = $logicalProcessors - 1
    bcdedit /set `{current`} numproc $cores
    bcdedit /set `{current`} useplatformtick true
    bcdedit /set `{current`} disabledynamictick true
    bcdedit /set `{current`} tscsyncpolicy enhanced
    bcdedit /set `{current`} debug No
    bcdedit /set `{current`} highestmode Yes
    bcdedit /set `{current`} perfmem 1
    bcdedit /set `{current`} usephysicaldestination No
}

function Network {
    Set-NetTCPSetting -SettingName InternetCustom -AutoTuningLevelLocal Normal
    Set-NetTCPSetting -SettingName InternetCustom -ScalingHeuristics Disabled

    if (-not (Test-Path -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\26")) {
        New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\26"
    }

    Set-ItemProperty-Verified -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" -Name LocalPriority -Type DWord -Value 4
    Set-ItemProperty-Verified -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" -Name HostsPriority -Type DWord -Value 5
    Set-ItemProperty-Verified -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" -Name DnsPriority -Type DWord -Value 6
    Set-ItemProperty-Verified -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" -Name NetbtPriority -Type DWord -Value 7
    Set-ItemProperty-Verified -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" -Name "Class" -Type DWord -Value 8

    Disable-NetAdapterLso -Name *
    Disable-NetAdapterRsc -Name *
    Disable-NetAdapterBinding -Name "*" -ComponentID "ms_tcpip6"
    Disable-NetAdapter -Name "*VMware*" -Confirm:$false *>$null
    Disable-NetAdapter -Name "*Virtual*" -Confirm:$false *>$null

    netsh int tcp set supplemental Template=Internet CongestionProvider=dctcp
    netsh int tcp set supplemental Template=Datacenter CongestionProvider=dctcp
    netsh int tcp set supplemental Template=Compat CongestionProvider=dctcp
    netsh int tcp set supplemental Template=InternetCustom CongestionProvider=dctcp
    netsh int tcp set supplemental Template=DatacenterCustom CongestionProvider=dctcp
    netsh int tcp set supplemental Template=Internet CongestionProvider=bbr2
    netsh int tcp set supplemental Template=Datacenter CongestionProvider=bbr2
    netsh int tcp set supplemental Template=Compat CongestionProvider=bbr2
    netsh int tcp set supplemental Template=InternetCustom CongestionProvider=bbr2
    netsh int tcp set supplemental Template=DatacenterCustom CongestionProvider=bbr2
    netsh int tcp set security mpp=disabled
    netsh int tcp set security profiles=disabled
    netsh int tcp set global initialRto=2000
    netsh int tcp set global timestamps=disabled
    netsh int tcp set global netdma=disabled
    netsh int tcp set global rsc=disabled
    netsh int tcp set global rss=enabled
    netsh int tcp set global dca=enabled
    netsh int tcp set global ecn=enabled
    netsh int tcp set global autotuninglevel=disabled
    netsh int tcp set global ecncapability=enabled
    netsh int tcp set global nonsackrttresiliency=disabled
    netsh int tcp set global maxsynretransmissions=2
    netsh int udp set global uro=enabled
    netsh int ip set global icmpredirects=disabled
    netsh int ip set global taskoffload=enabled
    netsh winsock set autotuning on

    set-netoffloadglobalsetting -ReceiveSideScaling Enabled
    set-netoffloadglobalsetting -TaskOffload Enabled

    try {
        $certPath = "$ENV:TEMP\cloudflare.crt"
        if (-not (Test-Path $certPath -PathType Leaf)) {
            Invoke-WebRequest -Uri "https://developers.cloudflare.com/cloudflare-one/static/documentation/connections/Cloudflare_CA.crt" -Outfile $certPath
        }
        Import-Certificate -FilePath $certPath -CertStoreLocation "cert:\LocalMachine\Root" | Out-Null
        Get-NetAdapter | Get-DnsClientServerAddress | Set-DnsClientServerAddress -ServerAddresses ("1.1.1.1", "1.0.0.1")
        Remove-Item -Path $certPath -Force
    }
    catch {
        Write-Error "Failed to import Cloudflare certificate."
    }
}

function Memory {
    bcdedit /set `{current`} firstmegabytepolicy UseAll

    fsutil behavior set memoryusage 2
    fsutil behavior set disablelastaccess 1
    fsutil behavior set mftzone 3
    fsutil behavior set quotanotify 10800
    fsutil behavior set bugcheckoncorrupt 0
    fsutil behavior set disablespotcorruptionhandling 1
    fsutil resource setlog shrink 99.9 $ENV:SYSTEMDRIVE\
}

function Processor {
    $commands = @(
        "setx GPU_MAX_ALLOC_PERCENT 99",
        "setx GPU_SINGLE_ALLOC_PERCENT 90",
        "setx GPU_MAX_SINGLE_ALLOC_PERCENT 99",
        "setx CPU_MAX_ALLOC_PERCENT 99",
        "setx GPU_MAX_HEAP_SIZE 99",
        "setx GPU_MAX_USE_SYNC_OBJECTS 1",
        "setx GPU_ENABLE_LARGE_ALLOCATION 99",
        "setx GPU_MAX_WORKGROUP_SIZE 1024",
        "setx GPU_FORCE_64BIT_PTR 0",
        "powercfg -restoredefaultschemes",
        "powercfg -h off",
        "powercfg.exe /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c",
        "powercfg /X monitor-timeout-ac 0",
        "powercfg /X monitor-timeout-dc 0",
        "powercfg /X standby-timeout-ac 0",
        "powercfg /X standby-timeout-dc 0",
        "powercfg /X standby-timeout-ac 0",
        "powercfg -change -disk-timeout-dc 0",
        "powercfg -change -disk-timeout-ac 0"
    )
    foreach ($command in $commands) {
        $process = Start-Process cmd.exe -ArgumentList "/c $command" -PassThru -Wait -WindowStyle Hidden
    }
}

function SyncTime {
    Set-TimeZone -Name "Taipei Standard Time"
    Set-Service -Name "W32Time" -StartupType Automatic
    net stop w32time
    w32tm /unregister
    w32tm /register
    net start w32time
    w32tm /resync /force
    w32tm /config /manualpeerlist:"time.windows.com" /syncfromflags:manual /reliable:yes /update
}

function Trash {
    Get-ChildItem "$ENV:USERPROFILE\Desktop" -Filter *.lnk -Force | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    Get-ChildItem "$ENV:APPDATA\Microsoft\Windows\Recent\*" -File -Force -Exclude desktop.ini | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    Get-ChildItem "$ENV:APPDATA\Microsoft\Windows\Recent\AutomaticDestinations\*" -File -Force -Exclude desktop.ini, f01b4d95cf55d32a.automaticDestinations-ms | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    Get-ChildItem "$ENV:APPDATA\Microsoft\Windows\Recent\CustomDestinations\*" -File -Force -Exclude desktop.ini | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    # Get-ChildItem "$ENV:TEMP\*" -Force | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    Get-ChildItem "C:\Windows\Temp\*" -Force | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    Get-ChildItem "C:\Windows\Prefetch\*" -Force | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

    taskkill.exe /F /IM "explorer.exe"
	Start-Sleep -Seconds 5
    Start-Process explorer.exe
    Start-Sleep -Seconds 2
}

$Global:Error.Clear()
& {
    . "$( $ENV:DOTFILES_DIR )\setup\powershell\helper.ps1"

    UninstallUWPApps
    DisableBackgroundUWPApps
    DisableWindowsFeatures
    DisableWindowsCapabilities
    DisableCortanaAutostart
    DisableStartupApps
    #OOShutup
    UninstallOneDrive
    HideOneDriveFileExplorerAd
    Performance
    FixTimers
    Network
    Memory
    Processor
    SyncTime
    Trash
} *>&1 -ErrorAction Ignore | Out-Null

if ($Global:Error) {
    $Errors = @()
    $Global:Error | ForEach-Object {
        $Errors += [PSCustomObject] @{
            Line = $_.InvocationInfo.ScriptLineNumber
            Message = $_.Exception.Message
        }
    }
    $Global:DotfilesError += [PSCustomObject] @{
        File = $PSCommandPath
        Errors = $Errors
    }
    $Global:Error.Clear()
}
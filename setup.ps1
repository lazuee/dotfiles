[Environment]::SetEnvironmentVariable("HOME", "$( $ENV:USERPROFILE )", "User")
[Environment]::SetEnvironmentVariable("USER", "$( $ENV:USERNAME )", "User")

$PSDefaultParameterValues["Out-File:Encoding"] = "utf8"
$ErrorActionPreference = "Stop"

$dotfiles_dir = "$( $HOME )\dotfiles"
$dotfiles_repo = "https://github.com/lazuee/dotfiles.git"

if (-not (Test-Path $dotfiles_dir)) {
    git clone --recurse-submodules $dotfiles_repo $dotfiles_dir

    if ($PSVersionTable.PSEdition -eq "Desktop") {
        Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$( $dotfiles_dir )\setup.ps1`"" -Verb RunAs
    } else {
        Start-Process pwsh.exe "-NoProfile -ExecutionPolicy Bypass -File `"$( $dotfiles_dir )\setup.ps1`"" -Verb RunAs
    }
} else {
    $remote_url = git config --get remote.origin.url
    if ($remote_url -ne $dotfiles_repo) {
        Write-Host "The dotfiles folder is already initialized to a different git repo." -ForegroundColor Yellow
        Write-Host "Re-run the script after deleting the folder '$( $dotfiles_dir )'" -ForegroundColor Yellow
        Read-Host "Press Enter to exit setup..."

        exit 1
    } else {
        git pull
        git submodule update --init --recursive
    }
}

Set-Location $dotfiles_dir

if (!(([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
    Write-Host "Eyy, Lazuee here! You need to run this script as Administrator to proceed."
    Read-Host "Press Enter to continue setup..."

    if ($PSVersionTable.PSEdition -eq "Desktop") {
        Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$( $PSCommandPath )`"" -Verb RunAs
    } else {
        Start-Process pwsh.exe "-NoProfile -ExecutionPolicy Bypass -File `"$( $PSCommandPath )`"" -Verb RunAs
    }

    exit 1
}

function Check-ScoopPackages {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateSet("bucket","app")]
        [string]$Type,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [array]$Packages,

        [Switch]$Force
    )

    if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
        throw "Scoop is not installed. Please install Scoop before running this script."
    }

    switch ($Type) {
        "bucket" {
            $totalCount = $Packages.Count
            $currentCount = 0

            foreach ($package in $Packages) {
                $currentCount++
                $bucketName = $package.Name
                $bucketScript = $package.Script


                Write-Host "($( $currentCount )/$( $totalCount )) - Checking scoop bucket '$( $bucketName )'..." -ForegroundColor Cyan

                if (!(scoop bucket list | Select-String -SimpleMatch $bucketName)) {
                    Write-Host "Bucket '$( $bucketName )' does not exist. Adding..." -ForegroundColor Cyan
                    scoop bucket add $bucketName
                }

                if ($bucketScript -ne $null) {
                    Invoke-Command -ScriptBlock $bucketScript
                }

                Start-Sleep -Seconds 2
            }
         }
        "app" {
            $totalCount = $Packages.Count
            $currentCount = 0

            foreach ($package in $Packages) {
                $currentCount++
                $appName = $package.Name
                $appScript = $package.Script


                Write-Host "($( $currentCount )/$( $totalCount )) - Checking scoop app '$( $appName )'..." -ForegroundColor Cyan

                try {
                    if (!(Test-Path -Path "$( $HOME )\scoop\apps\$( $appName )\current")) {
                        Write-Host "App '$( $appName )' is not installed. Installing..." -ForegroundColor Cyan
                        scoop install $appName --no-cache --skip --arch 64bit
                    }
                    elseif ($Force) {
                        Write-Host "Updating app '$appName'..." -ForegroundColor Cyan
                        scoop update $appName --no-cache --skip
                    }
                }
                catch {
                    Write-Host "Error occurred while installing or updating app '$( $appName )':" -ForegroundColor Yellow
                    Write-Host "--- | $( $_ )" -ForegroundColor Red
                }

                if ($appScript -ne $null) {
                    Invoke-Command -ScriptBlock $appScript
                }

                Start-Sleep -Seconds 2
            }
        }
        Default  {
            Write-Host "Invalid package type $( $Type )" -ForegroundColor Yellow
        }
     }
}

function Set-ScoopAlias {
    param (
        [Parameter(Mandatory=$true)]
        [Hashtable]$Alias
    )

    if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
        throw "Scoop is not installed. Please install Scoop before running this script."
    }

    $totalCount = $Alias.Count
    $currentCount = 0

    foreach ($key in $Alias.Keys) {
        $value = $Alias[$key]
        $currentCount++


        Write-Host "($( $currentCount )/$( $totalCount )) - Adding scoop alias '$( $key )'..." -ForegroundColor Cyan

        if (scoop alias list | Select-String -SimpleMatch $key) {
            scoop alias rm $key
        }

        scoop alias add $key "scoop $( $value )"

        Start-Sleep -Seconds 2
    }
}

function Link-Path {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Path,

        [Parameter(Mandatory=$true)]
        [string]$Target
    )

    if (Test-Path -Path $path) {
        Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
    }

    foreach ($type in @("Container", "Leaf")) {
        if (Test-Path -Path $target -PathType $type) {

            switch ($type) {
                "Container" {
                    try {

                        Write-Host "Linking folder ($( (Split-Path $path -Leaf) )) to ($( $target ))..." -ForegroundColor Cyan
                        New-Item -ItemType Junction -Path $path -Target $target -Force | Out-Null
                    }
                    catch {
                        Write-Host "Error occurred while Linking folder '$( $target )':" -ForegroundColor Yellow
                        Write-Host "--- | $( $_ )" -ForegroundColor Red
                    }

                }
                "Leaf" {
                    try {
                        Write-Host "Linking file ($( (Split-Path $path -Leaf) )) to ($( $target ))..." -ForegroundColor Cyan
                        New-Item -ItemType SymbolicLink -Path $path -Target $target -Force | Out-Null
                    }
                    catch {
                        Write-Host "Error occurred while Linking file '$( $target )':" -ForegroundColor Yellow
                        Write-Host "--- | $( $_ )" -ForegroundColor Red
                    }
                }
            }

            break
        }
    }

    Start-Sleep -Seconds 2
}

function Create-Shortcut {
    param (
        [Parameter(Mandatory=$true)]
        [string]$FilePath,

        [string]$ArgumentList
    )

    if (Test-Path -Path $FilePath) {
        try {
            Write-Host "Creating shortcut for $( (Split-Path $FilePath -Leaf) )..." -ForegroundColor Cyan

            $name = [System.IO.Path]::GetFileNameWithoutExtension($FilePath)
            $shortcut_path = "$( $ENV:APPDATA )\Microsoft\Windows\Start Menu\Programs\Startup\$( $name ).lnk"
            if (Test-Path -Path $shortcut_path) {
                Remove-Item -Path $shortcut_path -Recurse -Force -ErrorAction SilentlyContinue
            }

            $shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut($shortcut_path)
            $shortcut.TargetPath = $FilePath
            if ($ArgumentList) {
                $shortcut.Arguments = $ArgumentList
            }
            $shortcut.Save()

        }
        catch {
            Write-Host "Error occurred while creating shortcut '$( $Path )':" -ForegroundColor Yellow
            Write-Host "--- | $( $_ )" -ForegroundColor Red
        }
    }
}

function Install-Fonts {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Paths
    )

    $totalCount = $Paths.Count
    $currentCount = 0

    foreach ($path in $Paths) {
        if (Test-Path -Path $path) {
            $currentCount++


            Write-Host "($( $currentCount )/$( $totalCount )) - installing fonts '$( (Split-Path $path -Leaf) )'..." -ForegroundColor Cyan

            $fonts_key = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" | Select-Object -ExpandProperty PSPath

            Get-ChildItem $path -Recurse -Include *.ttf | ForEach-Object {
                $font_file = $_.FullName
                $font_name = $_.Name

                $key = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey("SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts", $true)
                $key.SetValue($font_name, $font_file)
                $key.Close()

                Write-Host "- $( $font_name ) ..."
                $font_path = Join-Path $ENV:SystemRoot "Fonts\$( $font_name )"
                Copy-Item $font_file $font_path -Force -ErrorAction SilentlyContinue
            }

        }

        Start-Sleep -Seconds 2
    }
}

function Download-File {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Url,

        [string]$Destination
    )

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    $tempFileName = ([System.IO.Path]::GetFileName($Url))
    $tempFile = Join-Path $ENV:temp $tempFileName

    Invoke-WebRequest -Uri $Url -OutFile $tempFile

    if ($Destination) {
        if (!(Test-Path -Path $Destination)) {
            New-Item -ItemType Directory -Path $Destination
        }

        $extension = [System.IO.Path]::GetExtension($tempFile)

        if ($extension -eq ".zip") {
            Expand-Archive -Path $tempFile -DestinationPath $Destination
        } else {
            Copy-Item -Path $tempFile -Destination $Destination -Recurse -Force -ErrorAction SilentlyContinue
        }

        if (Test-Path -Path $tempFile) {
            Remove-Item -Path $tempFile -Recurse -Force -ErrorAction SilentlyContinue
        }
    }

}


if (!(Test-Path "C:\tools")) {
    New-Item -Path "C:\tools" -ItemType Directory | Out-Null
}

If (((Get-CimInstance Win32_OperatingSystem).BuildNumber) -gt 20000) {
    if (!(Test-Path "C:\tools\DDN\DragDropNormalizer.exe")) {

        Write-Host "Installing DragDropNormalizer..." -ForegroundColor Cyan
        Download-File -Url "https://github.com/krlvm/DragDropNormalizer/releases/latest/download/DragDropNormalizer.zip" -Destination "C:\tools\DDN"

        Create-Shortcut -FilePath "C:\tools\DDN\DragDropNormalizer.exe"
        Start-Process -FilePath "C:\tools\DDN\DragDropNormalizer.exe"
        Start-Sleep -Seconds 2
    }

    if (!(Test-Path "C:\tools\DORRC\Win11DisableOrRestoreRoundedCorners.exe")) {

        Write-Host "Installing Win11DisableOrRestoreRoundedCorners..." -ForegroundColor Cyan
        Download-File -Url "https://github.com/valinet/Win11DisableRoundedCorners/releases/latest/download/Win11DisableOrRestoreRoundedCorners.exe" -Destination "C:\tools\DORRC"

        Create-Shortcut -FilePath "C:\tools\DORRC\Win11DisableOrRestoreRoundedCorners.exe"
        Start-Process -FilePath "C:\tools\DORRC\Win11DisableOrRestoreRoundedCorners.exe"
        Start-Sleep -Seconds 2
    }

    if (!(Test-Path -Path "$( $ENV:LOCALAPPDATA )\StartAllBack")) {
        if (!(Test-Path -Path "C:\Program Files\ExplorerPatcher\ep_setup.exe")) {

                Write-Host "Installing ExplorerPatcher..." -ForegroundColor Cyan
                Download-File -Url "https://github.com/valinet/ExplorerPatcher/releases/latest/download/ep_setup.exe"

                Start-Process -FilePath "$( $ENV:TEMP )\ep_setup.exe" -ErrorAction SilentlyContinue
                Start-Sleep -Seconds 25
                Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue

        }

        if (Test-Path -Path "C:\Program Files\ExplorerPatcher\ep_setup.exe") {
            Start-Sleep -Seconds 5
            Write-Host "Fine-tuning ExplorerPatcher for an enhanced and efficient user experience..." -ForegroundColor Cyan
            Fine-tuning Windows Explorer settings for an enhanced and efficient user experience...
            reg.exe add "HKCU\Software\ExplorerPatcher" /v OldTaskbar /t REG_DWORD /d 0 /f > $null 2>&1
            reg.exe add "HKCU\Software\ExplorerPatcher" /v ClockFlyoutOnWinC /t REG_DWORD /d 1 /f > $null 2>&1
            reg.exe add "HKCU\Software\ExplorerPatcher" /v DisableWinFHotkey /t REG_DWORD /d 1 /f > $null 2>&1
            reg.exe add "HKCU\Software\ExplorerPatcher" /v StartDocked_DisableRecommendedSection /t REG_DWORD /d 1 /f > $null 2>&1
            reg.exe add "HKCU\Software\ExplorerPatcher" /v DoNotRedirectSystemToSettingsApp /t REG_DWORD /d 1 /f > $null 2>&1
            reg.exe add "HKCU\Software\ExplorerPatcher" /v DoNotRedirectProgramsAndFeaturesToSettingsApp /t REG_DWORD /d 1 /f > $null 2>&1
            reg.exe add "HKCU\Software\ExplorerPatcher" /v DoNotRedirectDateAndTimeToSettingsApp /t REG_DWORD /d 1 /f > $null 2>&1
            reg.exe add "HKCU\Software\ExplorerPatcher" /v DoNotRedirectNotificationIconsToSettingsApp /t REG_DWORD /d 1 /f > $null 2>&1
            Stop-Process -Name explorer -ErrorAction SilentlyContinue

            Start-Sleep -Seconds 5
            Start-Process explorer.exe
            Start-Sleep -Seconds 3
        }
    } else {

        Write-Host "StartAllBack is currently used, re-run the script after you uninstall and delete it." -ForegroundColor Yellow
        Read-Host "Press Enter to continue..."
    }

    Write-Host "Optimizing Windows Explorer settings for a more streamlined experience..." -ForegroundColor Cyan

    Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
    reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f > $null 2>&1
    reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /t REG_DWORD /d 0 /f > $null 2>&1
    reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v AutoCheckSelect /t REG_DWORD /d 0 /f > $null 2>&1
    reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v LaunchTo /t REG_DWORD /d 1 /f > $null 2>&1
    reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v DisableThumbnailCache /t REG_DWORD /d 1 /f > $null 2>&1
    reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v DisableThumbsDBOnNetworkFolders /t REG_DWORD /d 1 /f > $null 2>&1

    reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v EnableSnapbar /t REG_DWORD /d 0 /f > $null 2>&1
    reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v EnableSnapAssistFlyout /t REG_DWORD /d 0 /f > $null 2>&1
    reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v EnableTaskGroups /t REG_DWORD /d 0 /f > $null 2>&1
    reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v SnapAssist /t REG_DWORD /d 0 /f > $null 2>&1
    reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v MultiTaskingAltTabFilter /t REG_DWORD /d 3 /f > $null 2>&1

    Start-Sleep -Seconds 5
    Start-Process explorer.exe
    Start-Sleep -Seconds 2
}

Write-Host "Enabling long file paths..." -ForegroundColor Cyan
reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v LongPathsEnabled /t REG_DWORD /d 1 /f > $null 2>&1
reg.exe add "HKCU\SYSTEM\CurrentControlSet\Control\FileSystem" /v LongPathsEnabled /t REG_DWORD /d 1 /f > $null 2>&1

Write-Host "Enable Windows Developer Mode..." -ForegroundColor Cyan
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /v AllowAllTrustedApps /t REG_DWORD /d 1 /f > $null 2>&1
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /v AllowDevelopmentWithoutDevLicense /t REG_DWORD /d 1 /f > $null 2>&1

Write-Host "Switching to dark mode..." -ForegroundColor Cyan
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name AppsUseLightTheme -Value 0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name SystemUsesLightTheme -Value 0
Write-Host "Dark theme enabled."

Write-Host "Disabling feedback..." -ForegroundColor Cyan
reg.exe add "HKCU\Software\Microsoft\Siuf\Rules" /v PeriodInNanoSeconds /t REG_DWORD /d 0 /f > $null 2>&1
reg.exe add "HKLM\SOFTWARE\Microsoft\Siuf\Rules" /v NumberOfSIUFInPe riod /t REG_DWORD /d 0 /f > $null 2>&1
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v DoNotShowFeedbackNotifications /t REG_DWORD /d 1 /f > $null 2>&1

Write-Host "Syncing time..." -ForegroundColor Cyan
net stop w32time
net start w32time
w32tm /resync /force
w32tm /query /status

Write-Host "Setting Time zone..." -ForegroundColor Cyan
Set-TimeZone -Name "Taipei Standard Time"

Write-Host "Optimizing wifi settings..." -ForegroundColor Cyan
reg.exe add "HKLM\Software\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" /v value /t REG_DWORD /d 0 /f > $null 2>&1
reg.exe add "HKLM\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" /v AutoConnectAllowedOEM /t REG_DWORD /d 0 /f > $null 2>&1
reg.exe add "HKCU\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v IRPStackSize /t REG_DWORD /d 2 /f > $null 2>&1
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 4294967295 /f > $null 2>&1

Write-Host "Enhancing gaming performance..." -ForegroundColor Cyan
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f > $null 2>&1
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f > $null 2>&1
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f > $null 2>&1
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f > $null 2>&1

Write-Output "Enabling svhost split threshold..." -ForegroundColor Cyan
# (default)   380000   #
#  4 GB      4194304   #    16 GB     16777216
#  6 GB      6291456   #    24 GB     25165824
#  8 GB      8388608   #    32 GB     33554432
# 12 GB     12582912   #    64 GB     67108864
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "SvcHostSplitThresholdInKB" -Type DWord -Value 380000

Write-Host "Enabling Hardware-Accelerated GPU Scheduling..." -ForegroundColor Cyan
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\" -Name 'HwSchMode' -Value '2' -PropertyType DWORD -Force

Write-Host "Avoid rubbish folder grouping..." -ForegroundColor Cyan
(gci 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags' -s | ? PSChildName -eq '{885a186e-a440-4ada-812b-db871b942259}' ) | ri -Recurse

Write-Host "Removing EPP context menu handlers..." -ForegroundColor Cyan
reg.exe delete "HKCR\*\shellex\ContextMenuHandlers\EPP" /f > $null 2>&1
reg.exe delete "HKCR\Directory\shellex\ContextMenuHandlers\EPP" /f > $null 2>&1
reg.exe delete "HKCR\Drive\shellex\ContextMenuHandlers\EPP" /f > $null 2>&1

Write-Host "Removing Windows Meet Now icon from the taskbar..." -ForegroundColor Cyan
reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarMn /t REG_DWORD /d 0 /f > $null 2>&1
reg.exe add "HKLM\Software\Policies\Microsoft\Windows\Windows Chat" /v ChatIcon /t REG_DWORD /d 3 /f > $null 2>&1
reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v HideSCAMeetNow /t REG_DWORD /d 1 /f > $null 2>&1

Install-Fonts -Paths @(
    "$( $dotfiles_dir )\tools\fonts\JetBrainsMono"
)

if (!(Get-Command "scoop" -ErrorAction SilentlyContinue)) {
    Write-Host "Scoop is not installed, wait for a moment..." -ForegroundColor Cyan
    iex "& {$(irm get.scoop.sh)} -RunAsAdmin"

    if (Test-Path -Path "$( $HOME )\scoop") {
        Write-Host "Scoop is installed!" -ForegroundColor Green
        Read-Host "Press Enter to continue setup..."
        if ($PSVersionTable.PSEdition -eq "Desktop") {
            Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$( $PSCommandPath )`"" -Verb RunAs
        } else {
            Start-Process pwsh.exe "-NoProfile -ExecutionPolicy Bypass -File `"$( $PSCommandPath )`"" -Verb RunAs
        }

        exit 1
    } else {
        Write-Host "Scoop is not installed. Please install Scoop and run this script again." -ForegroundColor Red
        Read-Host "Press Enter to exit setup..."

        exit 1
    }
}

Check-ScoopPackages -Type "bucket" -Packages @(
    @{Name = "main"; Script = {}},
    @{Name = "extras"; Script = {}},
    @{Name = "versions"; Script = {}},
    @{Name = "nerd-fonts"; Script = {}}
)

Check-ScoopPackages -Type "app" -Packages @(
    @{Name = "7zip"; Script = {
        $reg_path = "$( $HOME )\scoop\apps\7zip\current\install-context.reg"
        if (Test-Path -Path $reg_path) {
            Write-Host "Adding 7zip on Context Menu entries..." -ForegroundColor Cyan
            regedit.exe /s $reg_path

            reg.exe add "HKCU\Software\7-Zip\Options" /v MenuIcons /t REG_DWORD /d 0 /f > $null 2>&1
            reg.exe add "HKCU\Software\7-Zip\Options" /v CascadedMenu /t REG_DWORD /d 1 /f > $null 2>&1
            reg.exe add "HKCU\Software\7-Zip\Options" /v ContextMenu /t REG_DWORD /d 292 /f > $null 2>&1
        }

        regedit.exe /s
    }},
    @{Name = "git"; Script = {
        $gitconfig_path = "$( $HOME )\.gitconfig"
        if (Test-Path -Path $gitconfig_path) {
            Write-Host "Deleting existing Git config file..." -ForegroundColor Cyan
            Remove-Item $gitconfig_path -Recurse -Force -ErrorAction SilentlyContinue
        }

        Write-Host "Setting up new Git config file..." -ForegroundColor Cyan
        git config --global http.sslVerify false
        git config --global core.autocrlf true
        git config --global core.eol crlf
        git config --global core.filemode false
        git config --global color.ui true
        git config --global push.default simple
        git config --global pull.rebase true

        $git_username = "lazuee"
        $git_email = "lazuee.dev@gmail.com"
        $credential_helper = "manager"
        if ($PSVersionTable.PSVersion.Major -lt 7) {
            $credential_helper = "store"
        }

        git config --global user.name $git_username
        git config --global user.email $git_email
        git config --global credential.helper cache --timeout=3600
        git config --global credential.helper $credential_helper

        Link-Path -Path "$( $HOME )\.bashrc" -Target "$( $dotfiles_dir )\config\.bashrc";
    }},
    @{Name = "python"; Script = {
        $reg_path = "$( $HOME )\scoop\apps\python\current\install-pep-514.reg"
        if (Test-Path -Path $reg_path) {
            Write-Host "Updating Python registry settings..." -ForegroundColor Cyan
            regedit.exe /s $reg_path
        }

        Write-Host "Installing Python packages..." -ForegroundColor Cyan
        python -m pip install --quiet --no-cache-dir --upgrade pip
        python -m pip install --quiet --no-cache-dir --upgrade autopep8 yapf poetry opencv-python
    }},
    @{Name = "nvm"; Script = {
        Write-Host "Installing NodeJS LTS..." -ForegroundColor Cyan
        nvm install lts
        Write-Host "Using the NodeJS LTS..." -ForegroundColor Cyan
        nvm use lts
        Write-Host "Enabling NPM corepack..." -ForegroundColor Cyan
        corepack enable npm
        Write-Host "Installing NPM packages..." -ForegroundColor Cyan
        npm install --quiet --global npm@latest typescript@latest serve@latest pnpm@latest
    }},
    @{Name = "firefox"; Script = {
        if (Get-Process "Firefox" -ErrorAction SilentlyContinue) {
            Stop-Process -Name "Firefox" -Force -ErrorAction SilentlyContinue
            Start-Sleep -Seconds 2
        }

        Link-Path -Path "$( $HOME )\scoop\persist\firefox\profile\chrome" -Target "$( $dotfiles_dir )\config\firefox\chrome"
        Link-Path -Path "$( $HOME )\scoop\persist\firefox\profile\user.js" -Target "$( $dotfiles_dir )\config\firefox\user.js"
    }},
    @{Name = "vscodium"; Script = {
        if (Get-Process "VSCodium" -ErrorAction SilentlyContinue) {
            Stop-Process -Name "VSCodium" -Force -ErrorAction SilentlyContinue
            Start-Sleep -Seconds 2
        }

        Write-Host "Changing VSCodium Extensions Marketplace..." -ForegroundColor Cyan
        $json_path = "$( $HOME )\scoop\apps\vscodium\current\resources\app\product.json"
        $temp_path = "$ENV:TEMP\product.json"

        if (!(Test-Path -Path $json_path)) {
            Write-Output "Product json not found. Starting VSCodium to generate it..."
            Start-Process "$( $HOME )\scoop\apps\vscodium\current\VSCodium.exe"
            Start-Sleep -Seconds 5
            Write-Host "Waiting for VSCodium to exit..."
            while (Get-Process "VSCodium" -ErrorAction SilentlyContinue) {
                Start-Sleep -Seconds 2
            }

            Start-Sleep -Seconds 10
            Stop-Process -Name "VSCodium" -Force -ErrorAction SilentlyContinue
        }

        if (Test-Path -Path $json_path) {
            $json = Get-Content $json_path -Raw | ConvertFrom-Json

            $PropertiesToAdd = @{
                "extensionsGallery.serviceUrl" = "https://marketplace.visualstudio.com/_apis/public/gallery"
                "extensionsGallery.itemUrl" = "https://marketplace.visualstudio.com/items"
                "extensionsGallery.cacheUrl" = "https://vscode.blob.core.windows.net/gallery/index"
            }

            try {
                foreach ($Property in $PropertiesToAdd.GetEnumerator()) {
                    $JsonContent = $json
                    $PropertyPath = $Property.Key.Split(".")
                    $LastKey = $PropertyPath[-1]
                    $PropertyPath = $PropertyPath[0..($PropertyPath.Count-2)]

                    foreach ($Key in $PropertyPath) {
                        $JsonContent = $JsonContent.$Key
                    }

                    $JsonContent | Add-Member -MemberType NoteProperty -Name $LastKey -Value $Property.Value -Force
                }

                $json | ConvertTo-Json -Depth 100 | Set-Content -Path $temp_path -Encoding utf8

                Copy-Item $temp_path $json_path -Force -ErrorAction SilentlyContinue
                Remove-Item $temp_path -Recurse -Force -ErrorAction SilentlyContinue
            }
            catch {
                Write-Host "Error occurred while updating product.json : $( $_ )" -ForegroundColor Yellow
            }
        } else {
            Write-Host "Failed to generate product json. Please make sure VSCodium is installed and try again."
        }

        Link-Path -Path "$( $HOME )\scoop\apps\vscodium\current\data\user-data\User\snippets" -Target "$( $dotfiles_dir )\.vscode\snippets"
        Link-Path -Path "$( $HOME )\scoop\apps\vscodium\current\data\user-data\User\keybindings.json" -Target "$( $dotfiles_dir )\.vscode\keybindings.json"
        Link-Path -Path "$( $HOME )\scoop\apps\vscodium\current\data\user-data\User\settings.json" -Target "$( $dotfiles_dir )\.vscode\settings.json"
    }},
    @{Name = "starship"; Script = {
        Link-Path -Path "$( $HOME )\.config\starship.toml" -Target "$( $dotfiles_dir )\config\starship.toml";
    }},
    @{Name = "komorebi"; Script = {
        Link-Path -Path "$( $HOME )\.config\komorebi" -Target "$( $dotfiles_dir )\config\komorebi"
    }},
    @{Name = "pwsh-beta"; Script = {
        Link-Path -Path "$( $HOME )\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" -Target "$( $dotfiles_dir )\config\powershell\profile.ps1";
    }},
    @{Name = "windows-terminal-preview"; Script = {}},
    @{Name = "vcredist-aio"; Script = {}},
    @{Name = "psutils"; Script = {}},
    @{Name = "nilesoft-shell"; Script = {}},
    @{Name = "autohotkey"; Script = {}}
)


Set-ScoopAlias -Alias @{
    "i" = "install $args[0]"
    "add" = "install $args[0]"
    "uni" = "uninstall $args[0]"
    "rm" = "uninstall $args[0]"
    "remove" = "uninstall $args[0]"
    "upgrade" = "update *"
    "up" = "upgrade"
    "prune" = "cleanup * --cache"
    "outdated" = "update; status"
    "ri" = "uninstall $args[0]; install $args[0]"
    "reinstall" = "ri $args[0]"
    "ls" = "list"
    "s" = "search $args[0]"
    "rs" = "reset $args[0]"
    "use" = "rs $args[0]"
}

Write-Host "Yey! it's don don don done!..." -ForegroundColor Green

Start-Sleep -Seconds 2
Write-Host "Do not FORGET to STAR the repository!" -ForegroundColor Yellow

Start-Process firefox.exe -ArgumentList "https://github.com/lazuee/dotfiles"

Start-Sleep -Seconds 1
Read-Host "Press Enter to exit setup..."
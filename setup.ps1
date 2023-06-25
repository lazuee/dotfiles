Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser

[Environment]::SetEnvironmentVariable("HOME", "$( $ENV:USERPROFILE )", "User")
[Environment]::SetEnvironmentVariable("USER", "$( $ENV:USERNAME )", "User")
[Environment]::SetEnvironmentVariable("DOTFILES_DIR", "$( $ENV:USERPROFILE )\dotfiles", "User")

$PSDefaultParameterValues["Out-File:Encoding"] = "utf8"
$ErrorActionPreference = "SilentlyContinue"

Import-Module "$( $ENV:DOTFILES_DIR )/config/powershell/helpers.psm1" -DisableNameChecking

function Check-ScoopPackages {
    param (
        [Parameter(Mandatory=$true)]
        [ValidateSet("bucket","app")]
        [string]$Type,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [array]$Packages
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


                Write-Host "($( $currentCount )/$( $totalCount )) - Checking scoop bucket '$( $bucketName )'..."

                if (!(scoop bucket list | Select-String -SimpleMatch $bucketName)) {
                    Write-Host "Bucket '$( $bucketName )' does not exist. Adding..."
                    scoop bucket add $bucketName
                }

                if ($null -ne $bucketScript) {
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

                Write-Host "($( $currentCount )/$( $totalCount )) - Checking scoop app '$( $appName )'..."

                try {
                    if (!(Test-Path -Path "$( $ENV:HOME )\scoop\apps\$( $appName )\current")) {
                        Write-Host "App '$( $appName )' is not installed. Installing..."
                        scoop install $appName --no-cache --skip --arch 64bit
                    }
                    else {
                        Write-Host "Updating app '$( $appName )'..."
                        scoop update $appName --no-cache --skip --quiet
                    }
                }
                catch {
                    Write-Warning "Error occurred while installing or updating app '$( $appName )':"
					Write-Error "--- | $( $_ )"
                }

                if ($null -ne $appScript) {
                    Invoke-Command -ScriptBlock $appScript
                }

                Start-Sleep -Seconds 2
            }
        }
        Default  {
            Write-Warning "Invalid package type $( $Type )"
        }
     }
}

function Set-ScoopAlias {
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [array]$Aliases
    )

    if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
        throw "Scoop is not installed. Please install Scoop before running this script."
    }

	$totalCount = $Aliases.Count
	$currentCount = 0

	foreach ($alias in $Aliases) {
		$currentCount++
		$aliasName = $alias.Name
		$aliasDesc = $alias.Desc
		$aliasScript = $alias.Script

        Write-Host "($( $currentCount )/$( $totalCount )) - Checking scoop alias '$( $aliasName )'..."

        try {
            if (scoop alias list | Select-String -SimpleMatch $aliasName) {
                scoop alias rm $aliasName
            }

            Write-Host "Adding alias '$( $aliasName )'..."
			scoop alias add $aliasName "scoop $( $aliasScript )" "$( $aliasDesc )"
        }
        catch {
            Write-Warning "Error occurred while adding alias '$( $aliasName )':"
            Write-Error "--- | $( $_ )"
        }

        Start-Sleep -Seconds 2
    }
}

$Host.UI.RawUI.WindowTitle = "Dotfiles - Setup"

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

Write-Host "This is my personal preference, so please make sure to modify it before running the script." -ForegroundColor Red
Write-Host "Find the '# Change the value' on this script, please change it." -ForegroundColor Yellow

Read-Host "Press Enter to start the setup..."

if (!(Test-Command-Exists -Command "scoop")) {
    Write-Host "Scoop is not installed, wait for a moment..."
    Invoke-Expression "& { $(Invoke-RestMethod get.scoop.sh) } -RunAsAdmin"

    if (Test-Path -Path "$( $ENV:HOME )\scoop") {
        Write-Host "Scoop is installed!" -ForegroundColor Green
        Read-Host "Press Enter to continue setup..."

        Set-Location $ENV:DOTFILES_DIR
        & .\setup.ps1
    } else {
        Write-Host "Scoop is not installed. Please install Scoop and run this script again." -ForegroundColor Red
        Read-Host "Press Enter to exit setup..."

        exit 1
    }
}

if (!(Test-Command-Exists -Command "7z")) {
    Check-ScoopPackages -Type "app" -Packages @(
        @{Name = "7zip"; Script = {
            $reg_path = "$( $ENV:HOME )\scoop\apps\7zip\current\install-context.reg"
            if (Test-Path -Path $reg_path) {
                Write-Host "Adding 7zip on Context Menu entries..."
                regedit.exe /s $reg_path

                Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\7-Zip\Options" -Name MenuIcons -Type DWord -Value 0
				# Uncomment this if you're not using Nilesoft Shell, because this will cause 7-zip to disappear in Context Menu
                # Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\7-Zip\Options" -Name CascadedMenu -Type DWord -Value 1 
                Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\7-Zip\Options" -Name ContextMenu -Type DWord -Value 292
            }
        }}
    )
}

if (!(Test-Command-Exists -Command "git")) {
    Check-ScoopPackages -Type "app" -Packages @(
        @{Name = "git"; Script = {
            Set-Location $ENV:DOTFILES_DIR
            . .\setup.ps1
        }}
    )
}

if (!(Test-Command-Exists -Command "pwsh")) {
    Check-ScoopPackages -Type "app" -Packages @(
		@{Name = "pwsh-beta"; Script = {} }
    )
}

Invoke-Command -ScriptBlock {
	$reg_path = "$( $ENV:DOTFILES_DIR )\config\powershell\console.reg"
	if (Test-Path -Path $reg_path) {
		Write-Host "Setting up Console Properties..."
		regedit.exe /s $reg_path
	}

	Link-Path -Path "$( $ENV:HOME )\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" -Target "$( $ENV:DOTFILES_DIR )\config\powershell\profile.ps1";
}

$DOTFILES_URL = "https://github.com/lazuee/dotfiles.git"
if (!(Test-Path $ENV:DOTFILES_DIR)) {
    git clone --recurse-submodules $DOTFILES_URL $ENV:DOTFILES_DIR

    Set-Location $ENV:DOTFILES_DIR
    . .\setup.ps1
} else {
    $remote_url = git config --get remote.origin.url
    $remote_url = git config --get remote.origin.url
    $url_pattern = "^(https?|git)://[^\s/$.?#].[^\s]*$"

    if ((Get-Location).Path -eq $ENV:DOTFILES_DIR) {
        if ($remote_url -match $url_pattern) {
            if ($remote_url -eq $DOTFILES_URL) {
                Set-Location $ENV:DOTFILES_DIR

                $gitconfig_path = "$( $ENV:HOME )\.gitconfig"
                if (Test-Path -Path $gitconfig_path) {
                    Write-Host "Deleting existing Git config file..."
                    Remove-Item $gitconfig_path -Recurse -Force -ErrorAction SilentlyContinue
                }

                Write-Host "Setting up new Git config file..."
                git config --global http.sslVerify false
                git config --global core.autocrlf true
                git config --global core.eol crlf
                git config --global core.filemode false
                git config --global color.ui true
                git config --global push.default simple
                git config --global pull.rebase false
				git config --global --add safe.directory '*'

                $git_username = "lazuee" # Change the value
                $git_email = "lazuee.dev@gmail.com" # Change the value
                $credential_helper = "manager"
                if ($PSVersionTable.PSVersion.Major -lt 7) {
                    $credential_helper = "store"
                }

                git config --global user.name $git_username
                git config --global user.email $git_email
                git config --global credential.helper cache --timeout=3600
                git config --global credential.helper $credential_helper

                git -C "$( $ENV:DOTFILES_DIR )" submodule sync --quiet --recursive
                git submodule update --init --recursive "$( $ENV:DOTFILES_DIR )"

            } else {
                Write-Warning "The dotfiles folder is already initialized to a different git repo."
                Write-Warning "Re-run the script after deleting the folder '$( $ENV:DOTFILES_DIR )'"
                Read-Host "Press Enter to exit setup..."

                exit 1
            }
        } else {
            Write-Warning "The dotfiles folder is not initialized."
            Write-Warning "Re-run the script after deleting the folder '$( $ENV:DOTFILES_DIR )'"
            Read-Host "Press Enter to exit setup..."

            exit 1
        }
    } else {
        Write-Warning "Where did you go??? '$( (Get-Location).Path )'"
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
    @{Name = "vcredist-aio"; Script = {}},
    @{Name = "gsudo"; Script = {}},
    @{Name = "python"; Script = {
       $reg_path = "$( $ENV:HOME )\scoop\apps\python\current\install-pep-514.reg"
       if (Test-Path -Path $reg_path) {
          Write-Host "Updating Python registry settings..."
          regedit.exe /s $reg_path
       }

	  Invoke-Command -ScriptBlock {
			Write-Host "Installing Python packages..."
			python -m pip install --quiet --no-cache-dir --upgrade pip
			python -m pip install --quiet --no-cache-dir --upgrade autopep8 yapf poetry
	  }
    }},
    @{Name = "nvm"; Script = {
		Invoke-Command -ScriptBlock {
			Write-Host "Installing NodeJS LTS..."
			nvm install lts
			Write-Host "Using the NodeJS LTS..."
			nvm use lts
			Write-Host "Enabling NPM corepack..."
			corepack enable npm
			Write-Host "Installing NPM packages..."
			npm install --quiet --global npm@latest typescript@latest pnpm@latest github-files-fetcher@latest
		}
    }},
    @{Name = "firefox"; Script = {
        if (Get-Process-Command -Command "Firefox" -ErrorAction SilentlyContinue) {
            Stop-Process -Name "Firefox" -Force -ErrorAction SilentlyContinue
            Start-Sleep -Seconds 2
        }

        Link-Path -Path "$( $ENV:HOME )\scoop\persist\firefox\profile\chrome" -Target "$( $ENV:DOTFILES_DIR )\config\firefox\chrome"
        Link-Path -Path "$( $ENV:HOME )\scoop\persist\firefox\profile\user.js" -Target "$( $ENV:DOTFILES_DIR )\config\firefox\user.js"
    }},
    @{Name = "vscodium"; Script = {
        if (Get-Process-Command -Command "VSCodium" -ErrorAction SilentlyContinue) {
            Stop-Process -Name "VSCodium" -Force -ErrorAction SilentlyContinue
            Start-Sleep -Seconds 2
        }

        Write-Host "Changing VSCodium Extensions Marketplace..."
		[Environment]::SetEnvironmentVariable("VSCODE_GALLERY_SERVICE_URL", "https://marketplace.visualstudio.com/_apis/public/gallery", "User")
		[Environment]::SetEnvironmentVariable("VSCODE_GALLERY_CACHE_URL", "https://vscode.blob.core.windows.net/gallery/index", "User")
		[Environment]::SetEnvironmentVariable("VSCODE_GALLERY_ITEM_URL", "https://marketplace.visualstudio.com/items", "User")

        Write-Host "Installing VSIX Manager extension..."
        codium --install-extension zokugun.vsix-manager --force

        Write-Host "Setting up VSCodium..."
        Link-Path -Path "$( $ENV:HOME )\scoop\apps\vscodium\current\data\user-data\User\snippets" -Target "$( $ENV:DOTFILES_DIR )\.vscode\snippets"
        Link-Path -Path "$( $ENV:HOME )\scoop\apps\vscodium\current\data\user-data\User\keybindings.json" -Target "$( $ENV:DOTFILES_DIR )\.vscode\keybindings.json"
        Link-Path -Path "$( $ENV:HOME )\scoop\apps\vscodium\current\data\user-data\User\settings.json" -Target "$( $ENV:DOTFILES_DIR )\.vscode\settings.json"

        Write-Host "Creating Shortcut to SendTo..."
        New-Shortcut -Path "$((New-Object -ComObject WScript.Shell).SpecialFolders.Item("sendto"))\VSCodium.lnk" -Target "$( $ENV:HOME )\scoop\apps\vscodium\current\VSCodium.exe"
    }},
    @{Name = "starship"; Script = {
		[Environment]::SetEnvironmentVariable("STARSHIP_DISTRO", "SKY", "User")
		[Environment]::SetEnvironmentVariable("STARSHIP_CONFIG", "$( $ENV:HOME )/.config/starship.toml", "User")

        Link-Path -Path "$( $ENV:HOME )\.config\starship.toml" -Target "$( $ENV:DOTFILES_DIR )\config\starship.toml";
    }},
    @{Name = "autohotkey"; Script = {}},
    @{Name = "komorebi"; Script = {
		[Environment]::SetEnvironmentVariable("KOMOREBI_CONFIG_HOME", "$( $ENV:HOME )/.config/komorebi", "User")
		[Environment]::SetEnvironmentVariable("KOMOREBI_AHK_EXE", "$( $ENV:HOME )/scoop/apps/autohotkey/current/AutoHotkey64.exe", "User")

		Link-Path -Path "$( $ENV:HOME )\.config\komorebi" -Target "$( $ENV:DOTFILES_DIR )\config\komorebi"
        New-Shortcut -Path "$( $ENV:APPDATA )\Microsoft\Windows\Start Menu\Programs\startup\komorebi.lnk" -Target "powershell.exe" -ArgumentList "-WindowStyle hidden -NoProfile -ExecutionPolicy Bypass -Command `"Import-Module `"$( $ENV:HOME )/.config/komorebi/helpers.psm1`"; Start-Tiling -ErrorAction SilentlyContinue; exit 1`""
        Start-Process -FilePath "$( $ENV:APPDATA )\Microsoft\Windows\Start Menu\Programs\startup\komorebi.lnk"
    }},
    @{Name = "windows-terminal-preview"; Script = {
		Link-Path -Path "$( $ENV:LOCALAPPDATA )\Microsoft\Windows Terminal" -Target "$( $ENV:DOTFILES_DIR )\config\windows-terminal"
	}},
    @{Name = "notepadplusplus"; Script = {
        Link-Path -Path "$( $ENV:HOME )\scoop\apps\notepadplusplus\current\config.xml" -Target "$( $ENV:DOTFILES_DIR )\config\notepad++\config.xml";
        Link-Path -Path "$( $ENV:HOME )\scoop\apps\notepadplusplus\current\themes\catppuccin-mocha.xml" -Target "$( $ENV:DOTFILES_DIR )\config\notepad++\catppuccin-mocha.xml";
	}},
    @{Name = "nilesoft-shell"; Script = {
		Link-Path -Path "$( $ENV:HOME )\scoop\apps\nilesoft-shell\current\shell.nss" -Target "$( $ENV:DOTFILES_DIR )\config\nilesoft-shell\shell.nss";
		Link-Path -Path "$( $ENV:HOME )\scoop\apps\nilesoft-shell\current\imports" -Target "$( $ENV:DOTFILES_DIR )\config\nilesoft-shell\imports";

        Invoke-File -FilePath "$( $ENV:HOME )\scoop\apps\nilesoft-shell\current\shell.exe" -ArgumentList "-register -treat -restart -silent" -ErrorAction SilentlyContinue
	}},
    @{Name = "reduce-memory"; Script = {}}
)

Set-ScoopAlias -Aliases @(
    @{Name = "i"; Desc = "Install an app"; Script = 'install $args[0]--skip --arch 64bit'}
    @{Name = "add"; Desc = "Install an app"; Script = 'i $args[0]'}
    @{Name = "prune"; Desc = "Remove download cache"; Script = 'cleanup * --cache'}
    @{Name = "uni"; Desc = "Uninstall an app"; Script = 'uninstall $args[0] --purge; cleanup $args[0] --cache'}
    @{Name = "rm"; Desc = "Uninstall an app"; Script = 'uni $args[0]'}
    @{Name = "remove"; Desc = "Uninstall an app"; Script = 'uni $args[0]'}
    @{Name = "ri"; Desc = "Reinstall an app"; Script = 'uni $args[0]; install $args[0]'}
    @{Name = "reinstall"; Desc = "Reinstall an app"; Script = 'ri $args[0]'}
    @{Name = "up"; Desc = "Upgrade Scoop and all apps"; Script = 'update *'}
    @{Name = "upgrade"; Desc = "Upgrade Scoop and all apps"; Script = 'up'}
    @{Name = "outdated"; Desc = "Check for app updates"; Script = 'update; status'}
    @{Name = "ls"; Desc = "List installed apps"; Script = 'list'}
    @{Name = "s"; Desc = "Search for an app"; Script = 'search $args[0]'}
    @{Name = "rs"; Desc = "Reset an app"; Script = 'reset $args[0]'}
    @{Name = "use"; Desc = "Reset an app"; Script = 'rs $args[0]'}
)

Write-Host "Enabling long file paths..."
Set-ItemProperty-Verified -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name LongPathsEnabled -Type DWord -Value 1
Set-ItemProperty-Verified -Path "HKCU:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name LongPathsEnabled -Type DWord -Value 1

Write-Host "Enable Windows Developer Mode..."
Set-ItemProperty-Verified -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name AllowAllTrustedApps -Type DWord -Value 1
Set-ItemProperty-Verified -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name AllowDevelopmentWithoutDevLicense -Type DWord -Value 1

Write-Host "Switching to dark mode..."
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name AppsUseLightTheme -Value 0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name SystemUsesLightTheme -Value 0

Write-Host "Disabling feedback..."
Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Name PeriodInNanoSeconds -Type DWord -Value 0
Set-ItemProperty-Verified -Path "HKLM:\SOFTWARE\Microsoft\Siuf\Rules" -Name NumberOfSIUFInPeriod -Type DWord -Value 0
Set-ItemProperty-Verified -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name DoNotShowFeedbackNotifications -Type DWord -Value 1

Write-Host "Syncing time..."
net stop w32time
net start w32time
w32tm /resync /force
w32tm /query /status

Write-Host "Setting up timezone..."
Set-TimeZone -Name "Taipei Standard Time" # Change the value

Write-Host "Optimizing wifi settings..."
Set-ItemProperty-Verified -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" -Name value -Type DWord -Value 0
Set-ItemProperty-Verified -Path "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" -Name AutoConnectAllowedOEM -Type DWord -Value 0
Set-ItemProperty-Verified -Path "HKCU:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name IRPStackSize -Type DWord -Value 2
Set-ItemProperty-Verified -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name NetworkThrottlingIndex -Type DWord -Value 4294967295

netsh int tcp set global autotuninglevel=normal
netsh int tcp set global maxconns=10000
netsh int tcp set heuristics disabled
Set-ItemProperty-Verified -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name TcpAckFrequency -Type DWord -Value 1
Set-ItemProperty-Verified -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name TCPNoDelay -Type DWord -Value 1

Write-Host "Enhancing gaming performance..."
Set-ItemProperty-Verified -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "GPU Priority" -Type DWord -Value 8
Set-ItemProperty-Verified -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Priority" -Type DWord -Value 6
Set-ItemProperty-Verified -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Scheduling Category" -Type String -Value "High"
Set-ItemProperty-Verified -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "SFIO Priority" -Type String -Value "High"

# Write-Host "Enabling svhost split threshold..."
# (default)   380000   #
#  4 GB      4194304   #    16 GB     16777216
#  6 GB      6291456   #    24 GB     25165824
#  8 GB      8388608   #    32 GB     33554432
# 12 GB     12582912   #    64 GB     67108864
Set-ItemProperty-Verified -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name SvcHostSplitThresholdInKB -Type DWord -Value 380000 # Change the value

Write-Host "Enabling Hardware-Accelerated GPU Scheduling..."
Set-ItemProperty-Verified -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name HwSchMode -Type DWord -Value 2

Write-Host "Opening ports 443 and 1193..."
netsh advfirewall firewall add rule name="Open Port 443" dir=in action=allow protocol=TCP localport=443
netsh advfirewall firewall add rule name="Open Port 1193" dir=in action=allow protocol=TCP localport=1193

if (!(Test-Path "C:\Apps")) {
    New-Item -Path "C:\Apps" -ItemType Directory | Out-Null
}

if (!(Test-Path "C:\Apps\ProcGov\procgov64.exe")) {
    Write-Host "Downloading Process Governor..."
    Download-File -Url "https://github.com/lowleveldesign/process-governor/releases/latest/download/procgov.zip" -Destination "C:\Apps\ProcGov"
}

if (((Get-CimInstance Win32_OperatingSystem).BuildNumber) -gt 20000) {
    Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue

    if (!(Test-Path "C:\Apps\DDN\DragDropNormalizer.exe")) {

        Write-Host "Downloading DragDropNormalizer..."
        Download-File -Url "https://github.com/krlvm/DragDropNormalizer/releases/latest/download/DragDropNormalizer.zip" -Destination "C:\Apps\DDN"

        Write-Host "Creating Shortcut..."
        New-Shortcut -Path "$( $ENV:APPDATA )\Microsoft\Windows\Start Menu\Programs\Startup\DragDrop Normalizer.lnk" -Target "C:\Apps\DDN\DragDropNormalizer.exe"

        Write-Host "Running App..."
        Start-Process -FilePath "C:\Apps\DDN\DragDropNormalizer.exe" -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
    }

    if (!(Test-Path "C:\Apps\ACE\AccentColorizer-x64.exe")) {

        Write-Host "Downloading AccentColorizer-x64..."
        Download-File -Url "https://github.com/krlvm/AccentColorizer/releases/latest/download/AccentColorizer-x64.exe" -Destination "C:\Apps\ACE"

        Write-Host "Enabling ColorizeProgressBar..."
        Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\AccentColorizer" -Name ColorizeProgressBar -Type DWord -Value 1

        Write-Host "Creating Shortcut..."
        New-Shortcut -Path "$( $ENV:APPDATA )\Microsoft\Windows\Start Menu\Programs\Startup\Windows Colorizer.lnk" -Target "C:\Apps\ACE\AccentColorizer-x64.exe"

        Write-Host "Running App..."
        Start-Process -FilePath "C:\Apps\ACE\AccentColorizer-x64.exe" -ErrorAction SilentlyContinue

        Start-Sleep -Seconds 2
    }

    if (!(Test-Path "C:\Apps\ACE\AccentColorizer-E11.exe")) {

        Write-Host "Downloading AccentColorizer-E11..."
        Download-File -Url "https://github.com/krlvm/AccentColorizer-E11/releases/latest/download/AccentColorizer-E11.exe" -Destination "C:\Apps\ACE"

        Write-Host "Creating Shortcut..."
        New-Shortcut -Path "$( $ENV:APPDATA )\Microsoft\Windows\Start Menu\Programs\Startup\Windows Glyphs Colorizer.lnk" -Target "C:\Apps\ACE\AccentColorizer-E11.exe"

        Write-Host "Running App..."
        Start-Process -FilePath "C:\Apps\ACE\AccentColorizer-E11.exe" -ErrorAction SilentlyContinue

        Start-Sleep -Seconds 2
    }


    if (!(Test-Path "C:\Apps\DORRC\Win11DisableOrRestoreRoundedCorners.exe")) {

        Write-Host "Downloading Win11DisableOrRestoreRoundedCorners..."
        Download-File -Url "https://github.com/valinet/Win11DisableRoundedCorners/releases/latest/download/Win11DisableOrRestoreRoundedCorners.exe" -Destination "C:\Apps\DORRC"

        Write-Host "Creating Shortcut..."
        New-Shortcut -Path "$( $ENV:APPDATA )\Microsoft\Windows\Start Menu\Programs\Windows Rounded Corner.lnk" -Target "C:\Apps\DORRC\Win11DisableOrRestoreRoundedCorners.exe"
        Write-Warning "if you want to Disable windows rounded corner, run the program!"
        Write-Warning "Run the program again, if you want to Enable the windows rounded corner."
        Start-Sleep -Seconds 2
    }

    if (!(Test-Path -Path "$( $ENV:LOCALAPPDATA )\StartAllBack")) {

        if (!(Test-Path -Path "C:\Program Files\ExplorerPatcher\ep_setup.exe")) {

                Write-Host "Downloading ExplorerPatcher..."
                Download-File -Url "https://github.com/valinet/ExplorerPatcher/releases/latest/download/ep_setup.exe"

                Write-Host "Running App..."
                Start-Process -FilePath "$( $ENV:TEMP )\ep_setup.exe" -ErrorAction SilentlyContinue
                Start-Sleep -Seconds 60
        }

        if (Test-Path -Path "C:\Program Files\ExplorerPatcher\ep_setup.exe") {
            Start-Sleep -Seconds 5
            Write-Host "Fine-tuning ExplorerPatcher for an enhanced and efficient user experience..."

            Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\ExplorerPatcher" -Name OldTaskbar -Type DWord -Value 0
            Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\ExplorerPatcher" -Name ClockFlyoutOnWinC -Type DWord -Value 1
            Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\ExplorerPatcher" -Name DisableWinFHotkey -Type DWord -Value 1
            Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\ExplorerPatcher" -Name StartDocked_DisableRecommendedSection -Type DWord -Value 1
            Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\ExplorerPatcher" -Name DoNotRedirectSystemToSettingsApp -Type DWord -Value 1
            Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\ExplorerPatcher" -Name DoNotRedirectProgramsAndFeaturesToSettingsApp -Type DWord -Value 1
            Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\ExplorerPatcher" -Name DoNotRedirectDateAndTimeToSettingsApp -Type DWord -Value 1
            Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\ExplorerPatcher" -Name DoNotRedirectNotificationIconsToSettingsApp -Type DWord -Value 1
        }
    } else {
        Write-Warning "StartAllBack is currently used, re-run the script after you uninstall and delete it."
    }

    Write-Host "Optimizing Windows Explorer settings for a more streamlined experience..."

    Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32"
	Set-ItemProperty-Verified -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments" -Name SaveZoneInformation -Type DWord -Value 1
    Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name HideFileExt -Type DWord -Value 0
    Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name AutoCheckSelect -Type DWord -Value 0
    Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name LaunchTo -Type DWord -Value 1
    Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name DisableThumbnailCache -Type DWord -Value 1
    Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name DisableThumbsDBOnNetworkFolders -Type DWord -Value 1

    Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name EnableSnapbar -Type DWord -Value 0
    Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name EnableSnapAssistFlyout -Type DWord -Value 0
    Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name EnableTaskGroups -Type DWord -Value 0
    Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name SnapAssist -Type DWord -Value 0
    Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name MultiTaskingAltTabFilter -Type DWord -Value 3

	Set-ItemProperty-Verified -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name ShowRecent -Type DWord -Value 0
	Set-ItemProperty-Verified -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name ShowCloudFilesInQuickAccess -Type DWord -Value 0
	Set-ItemProperty-Verified -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name ShowFrequent -Type DWord -Value 0

    Write-Host "Optimizing Windows settings for a better performance..."
	Set-ItemProperty-Verified -Path "HKCU:\Control Panel\Desktop" -Name AutoEndTasks -Type String -Value 1
	Set-ItemProperty-Verified -Path "HKCU:\Control Panel\Desktop" -Name ForegroundFlashCount -Type String -Value 0
	Set-ItemProperty-Verified -Path "HKCU:\Control Panel\Desktop" -Name ForegroundLockTimeout -Type DWord -Value 0
	Set-ItemProperty-Verified -Path "HKCU:\Control Panel\Desktop" -Name HungAppTimeout -Type String -Value 25000
	Set-ItemProperty-Verified -Path "HKCU:\Control Panel\Desktop" -Name WaitToKillAppTimeout -Type String -Value 25000
	Set-ItemProperty-Verified -Path "HKCU:\Control Panel\Desktop" -Name MenuShowDelay -Type String -Value 0
	Set-ItemProperty-Verified -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name WaitToKillServiceTimeout -Type String -Value 25000
	Set-ItemProperty-Verified -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" -Name AutoChkTimeout -Type DWord -Value 5
	Set-ItemProperty-Verified -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" -Name StartupDelayInMSec -Type DWord -Value 0

	Set-ItemProperty-Verified -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name LargeSystemCache -Type DWord -Value 1
	Set-ItemProperty-Verified -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name DisablePagingExecutive -Type DWord -Value 1
	Set-ItemProperty-Verified -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" -Name EnablePrefetcher -Type DWord -Value 0
	Set-ItemProperty-Verified -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" -Name EnableSuperfetch -Type DWord -Value 0
	Set-ItemProperty-Verified -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" -Name EnableBootTrace -Type DWord -Value 0
	Set-ItemProperty-Verified -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" -Name SfTracingState -Type DWord -Value 0

	Set-ItemProperty-Verified -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name HiberbootEnabled -Type DWord -Value 0
	powercfg -h off
	powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
    $builtin_powerplans = @{
        "Power Saver"            = "a1841308-3541-4fab-bc81-f71556f20b4a"
        "Balanced (recommended)" = "381b4222-f694-41f0-9685-ff5bb260df2e"
        "High Performance"       = "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"
        "Ultimate Performance"   = "e9a42b02-d5df-448d-aa00-03f14749eb61"
    }
    $unique_powerplans = $builtin_powerplans.Clone()
    ForEach ($powercfg_str in $((powercfg -L)[3..(powercfg -L).Count])) {
        $powerplan_guid = $powercfg_str.Split(':')[1].Split('(')[0].Trim()
        $powerplan_name = $powercfg_str.Split('(')[-1].Replace(')', '').Trim()

        if (($powerplan_guid -in $builtin_powerplans.Values)) {
            Write-Status -Types "@" -Status "The '$powerplan_name' power plan is built-in, skipping $powerplan_guid ..." -Warning
            Continue
        }

        try {
            if (($powerplan_name -notin $unique_powerplans.Keys) -and ($powerplan_guid -notin $unique_powerplans.Values)) {
                $unique_powerplans.Add($powerplan_name, $powerplan_guid)
            } else {
                powercfg -Delete $powerplan_guid
            }
        } catch {
            powercfg -Delete $powerplan_guid
        }
    }

	Set-ItemProperty-Verified -Path "HKLM:\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener" -Name "Start" -Type DWord -Value 0
	Set-ItemProperty-Verified -Path "HKLM:\SYSTEM\CurrentControlSet\Control\WMI\Autologger\DiagLog" -Name "Start" -Type DWord -Value 0
	Set-ItemProperty-Verified -Path "HKLM:\SYSTEM\CurrentControlSet\Control\WMI\Autologger\Diagtrack-Listener" -Name "Start" -Type DWord -Value 0
	Set-ItemProperty-Verified -Path "HKLM:\SYSTEM\CurrentControlSet\Control\WMI\Autologger\WiFiSession" -Name "Start" -Type DWord -Value 0

	Set-ItemProperty-Verified -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name FilterAdministratorToken -Type DWord -Value 0
	Set-ItemProperty-Verified -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name EnableUIADesktopToggle -Type DWord -Value 0
	Set-ItemProperty-Verified -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name ConsentPromptBehaviorAdmin -Type DWord -Value 5
	Set-ItemProperty-Verified -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name ConsentPromptBehaviorUser -Type DWord -Value 3
	Set-ItemProperty-Verified -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name EnableInstallerDetection -Type DWord -Value 1
	Set-ItemProperty-Verified -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name ValidateAdminCodeSignatures -Type DWord -Value 0
	Set-ItemProperty-Verified -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name EnableSecureUIAPaths -Type DWord -Value 0
	Set-ItemProperty-Verified -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name EnableLUA -Type DWord -Value 1
	Set-ItemProperty-Verified -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name PromptOnSecureDesktop -Type DWord -Value 1
	Set-ItemProperty-Verified -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name EnableVirtualization -Type DWord -Value 0

	Set-ItemProperty-Verified -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name EnableFullTrustStartupTasks -Type DWord -Value 0
	Set-ItemProperty-Verified -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name EnableUwpStartupTasks -Type DWord -Value 0
	Set-ItemProperty-Verified -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name VerboseStatus -Type DWord -Value 1
	Set-ItemProperty-Verified -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\Audit" -Name ProcessCreationIncludeCmdLine_Enabled -Type DWord -Value 1

	Set-ItemProperty-Verified -Path "HKCU:\Software\Microsoft\Multimedia\Audio" -Name UserDuckingPreference -Type DWord -Value 3
	Set-ItemProperty-Verified -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\EditionOverrides" -Name UserSetting_DisableStartupSound -Type DWord -Value 1

	Set-ItemProperty-Verified -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Name GlobalUserDisabled -Type DWord -Value 1

	Set-ItemProperty-Verified -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" -Name DisableAutoplay -Type DWord -Value 1

	Set-ItemProperty-Verified -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name NoAutorun -Type DWord -Value 1
	Set-ItemProperty-Verified -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name NoDriveTypeAutoRun -Type DWord -Value 255

	Write-Host "Optimizing context menu entries..."
	reg.exe delete "HKCR:\*\shellex\ContextMenuHandlers\EPP"
	reg.exe delete "HKCR:\Directory\shellex\ContextMenuHandlers\EPP"
	reg.exe delete "HKCR:\Drive\shellex\ContextMenuHandlers\EPP"

	reg.exe delete "HKLM:\Software\Classes\*\shellex\ContextMenuHandlers\ModernSharing"
	reg.exe delete "HKLM:\Software\Classes\*\shellex\ContextMenuHandlers\Sharing"
	reg.exe delete "HKLM:\Software\Classes\Drive\shellex\ContextMenuHandlers\Sharing"
	reg.exe delete "HKLM:\Software\Classes\Drive\shellex\PropertySheetHandlers\Sharing"
	reg.exe delete "HKLM:\Software\Classes\Directory\background\shellex\ContextMenuHandlers\Sharing"
	reg.exe delete "HKLM:\Software\Classes\Directory\shellex\ContextMenuHandlers\Sharing"
	reg.exe delete "HKLM:\Software\Classes\Directory\shellex\CopyHookHandlers\Sharing"
	reg.exe delete "HKLM:\Software\Classes\Directory\shellex\PropertySheetHandlers\Sharing"

	Write-Host "Avoid rubbish folder grouping..."
	(Get-ChildItem 'HKCU:\SOFTWARE\Classes\Local Settings\SOFTWARE\Microsoft\Windows\Shell\Bags' -s | Where-Object PSChildName -eq '{885a186e-a440-4ada-812b-db871b942259}' ) | Remove-Item -Recurse

	Write-Host "Removing shortcuts on Desktop..."
	Get-ChildItem $ENV:HOME\Desktop -Filter *.lnk | Remove-Item -Force -ErrorAction SilentlyContinue

	Write-Host "Clearing Recent History..."
	Get-ChildItem $ENV:HOME\Desktop -Filter *.lnk | Remove-Item -Force -ErrorAction SilentlyContinue
	Get-ChildItem $ENV:APPDATA\Microsoft\Windows\Recent\* -File -Force -Exclude desktop.ini | Remove-Item -Force -ErrorAction SilentlyContinue
	Get-ChildItem $ENV:APPDATA\Microsoft\Windows\Recent\AutomaticDestinations\* -File -Force -Exclude desktop.ini, f01b4d95cf55d32a.automaticDestinations-ms | Remove-Item -Force -ErrorAction SilentlyContinue
	Get-ChildItem $ENV:APPDATA\Microsoft\Windows\Recent\CustomDestinations\* -File -Force -Exclude desktop.ini | Remove-Item -Force -ErrorAction SilentlyContinue

	Write-Host "Removing Pinned Folders on QuickAccess..."
	while ($true) {
		$pinnedFolders = ((New-Object -ComObject Shell.Application).Namespace("shell:::{679f85cb-0220-4080-b29b-5540cc05aab6}").Items() | Where-Object IsFolder -eq $true)
		if (!$pinnedFolders) {
			break
		}
		(($pinnedFolders).Verbs() | Where-Object Name -match "Unpin from Quick access").DoIt()
	}

	Write-Host "Removing Windows Meet Now icon from the taskbar..."
	Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name TaskbarMn -Type DWord -Value 0
	Set-ItemProperty-Verified -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Chat" -Name ChatIcon -Type DWord -Value 3
	Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name HideSCAMeetNow -Type DWord -Value 1


	Start-Sleep -Seconds 5
    Start-Process explorer.exe
    Start-Sleep -Seconds 2
}

Install-Fonts -Paths @(
    "$( $ENV:DOTFILES_DIR )\fonts\JetBrainsMono"
)

if (!(Test-Path -Path "$( $ENV:HOME )\Downloads\UltraUXThemePatcher.exe" -PathType Leaf)) {
    Write-Host "Downloading UltraUXThemePatcher..."
    $ProgressPreference = "SilentlyContinue"
    Invoke-WebRequest -Uri https://mhoefs.eu/software_count.php -OutFile "$($env:USERPROFILE)\Downloads\UltraUXThemePatcher.exe" -Method POST -Body @{Uxtheme='UltraUXThemePatcher';id='Uxtheme'}
    Write-Host "Downloaded to $( $ENV:USERPROFILE )\Downloads\UltraUXThemePatcher.exe"
    Write-Host "Patch OS to apply themes"
} else {
    Write-Host ""
    Write-Host "UltraUXThemePatcher already downloaded. skipping..."
    Write-Host "Patch OS to apply custom themes"
}
Write-Host "Restart after patching, then run theme.ps1"

Clear-Host
Write-Host "Dotfiles setup has been completed." -ForegroundColor Green

Start-Sleep -Seconds 2
Write-Warning "If you liked this dotfiles:"
Write-Warning "Kindly do not FORGET to STAR the repository as it gives me satisfaction for sharing this :D"

Start-Process "https://github.com/lazuee/dotfiles"

Start-Sleep -Seconds 1
Read-Host "Press Enter to exit setup..."
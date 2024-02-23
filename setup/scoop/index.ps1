function Scoop {
    $ENV:SCOOP_GLOBAL = "C:\scoopApps"
    [Environment]::SetEnvironmentVariable("SCOOP_GLOBAL", $ENV:SCOOP_GLOBAL, "Machine")

    if (-not (Get-Command "scoop" -ErrorAction SilentlyContinue)) {
        if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
            $runAs = "-RunAsAdmin"
        }

        Invoke-Expression "& { $(Invoke-RestMethod get.scoop.sh) } $runAs"

        if (Test-Path -Path "$( $ENV:USERPROFILE )\scoop" -ErrorAction SilentlyContinue) {
            & .\index.ps1
        } else {
            Write-Error "Scoop is not installed. Please install Scoop and run this script again." -ErrorAction SilentlyContinue
        }

        return $false
    }

    return $true
}

function Install7zip {
    scoop install main/7zip
    $regPath = "$( $ENV:USERPROFILE )\scoop\apps\7zip\current\install-context.reg"
    if (Test-Path -Path $regPath) {
        regedit.exe /s $regPath
        Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\7-Zip\Options" -Name MenuIcons -Type DWord -Value 0
        Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\7-Zip\Options" -Name CascadedMenu -Type DWord -Value 1
        Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\7-Zip\Options" -Name ContextMenu -Type DWord -Value 292

        # Uncomment this if you're not using Nilesoft Shell, because this will cause 7-zip to disappear in Context Menu
        Set-ItemProperty-Verified -Path "HKCU:\SOFTWARE\7-Zip\Options" -Name CascadedMenu -Type DWord -Value 0
    }
}

function InstallGit {
    scoop install main/git

    git config --global user.name "lazuee" # change value
    git config --global user.email "lazuee.dev@gmail.com" # change value
    git config --global credential.helper manager
    git config --global credential.helper cache --timeout=3600
    git config --global core.autocrlf false
    git config --global core.quotepath false
    git config --global core.compression 0
    git config --global http.postBuffer 524288000
    git config --global http.maxRequestBuffer 524
    git config --global i18n.logoutputencoding utf-8
    git config --global i18n.commit.encoding utf-8
    git config --global i18n.commitencoding utf-8
    git config --global gui.encoding utf-8
	git config --global --add safe.directory '*'

    $regPath = "$( $ENV:USERPROFILE )\scoop\apps\git\current\install-file-associations.reg"
    if (Test-Path -Path $regPath) {
        regedit.exe /s $regPath
    }
}

function Check {
    scoop install main/aria2
    scoop config aria2-warning-enabled false
    scoop bucket add extras
    scoop bucket add versions
    scoop bucket add nerd-fonts
    scoop bucket add lazuee https://github.com/lazuee/scoop-bucket
    scoop update
}

function InstallMisc {
    scoop install extras/vcredist-aio
    scoop install main/gsudo
    scoop install main/which
}

function InstallFonts {
    sudo scoop install -g nerd-fonts/GeistMono-NF
    sudo scoop install -g nerd-fonts/GeistMono-NF-Mono
    sudo scoop install -g nerd-fonts/JetBrainsMono-NF-Mono
}

function InstallPython {
    scoop install versions/python312
    $regPath = "$( $ENV:USERPROFILE )\scoop\apps\python312\current\install-pep-514.reg"
    if (Test-Path -Path $regPath) {
        regedit.exe /s $regPath
    }

    # $folderPath = "$( $ENV:USERPROFILE )\AppData\Roaming\Python\Python312\Scripts"
    # $path = [Environment]::GetEnvironmentVariable("Path", "User")
    # if (-not ($path.Contains($folderPath))) {
    #     $newPath = $path + ";" + $folderToAdd
    #     [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    # }

    python.exe -m pip install pip --upgrade --no-cache-dir
    python.exe -m pip install black --upgrade --no-cache-dir
    python.exe -m pip install winsdk --upgrade --no-cache-dir
    python.exe -m pip install pywin32 --upgrade --no-cache-dir
    python.exe -m pip install websockets --upgrade --no-cache-dir

    scoop install main/pipx
    pipx ensurepath

    pipx install --force httpie
    pipx install --force pipdeptree
    pipx install --force pipenv
}

function InstallNode {
    scoop install main/nodejs-lts
    scoop install main/pnpm

    npm install --global npm@latest
    npm install --global prettier@latest
    npm install --global github-files-fetcher@latest

    $vscodeSettingsPath = "$( $ENV:DOTFILES_DIR )\.vscode\settings.json"
    if (Test-Path -Path $vscodeSettingsPath) {
        $settings = Get-Content -Path $vscodeSettingsPath -Raw
        $prettierPath = "$( $ENV:USERPROFILE -replace "\\", "/" )/scoop/persist/nodejs-lts/bin/node_modules/prettier/index.cjs"
        if (Test-Path $prettierPath) {
            $settings = $settings -replace '"prettier.prettierPath": .*', "`"prettier.prettierPath`": `"$prettierPath`","
            $settings = $settings -replace '"prettier.withNodeModules": .*', "`"prettier.withNodeModules`": true,"
        } else {
            $settings = $settings -replace '"prettier.prettierPath": .*', "`"prettier.prettierPath`": `"`","
            $settings = $settings -replace '"prettier.withNodeModules": .*', "`"prettier.withNodeModules`": false,"
        }
        Set-Content -Path $vscodeSettingsPath -Value $settings
    }
}

function InstallPowershell {
    scoop install main/pwsh

    $regPath =  "$( $ENV:DOTFILES_DIR )\setup\powershell\console.reg"
    if (Test-Path -Path $regPath) {
        regedit.exe /s $regPath
    }

    Link-Path -Path "$( $ENV:USERPROFILE )\Documents\PowerShell\helper.ps1" -Target "$( $ENV:DOTFILES_DIR )\setup\powershell\helper.ps1"
    Link-Path -Path "$( $ENV:USERPROFILE )\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" -Target "$( $ENV:DOTFILES_DIR )\setup\powershell\Microsoft.PowerShell_profile.ps1"

    Link-Path -Path "$( $ENV:USERPROFILE )\Documents\WindowsPowerShell\helper.ps1" -Target "$( $ENV:DOTFILES_DIR )\setup\powershell\helper.ps1"
    Link-Path -Path "$( $ENV:USERPROFILE )\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" -Target "$( $ENV:DOTFILES_DIR )\setup\powershell\Microsoft.PowerShell_profile.ps1"
}

function InstallWindowsTerminal {
    scoop install extras/windows-terminal
	Link-Path -Path "$( $ENV:USERPROFILE )\scoop\apps\windows-terminal\current\settings" -Target "$( $ENV:DOTFILES_DIR )\setup\windows-terminal"
}

function InstallVSCodium {
    scoop install extras/vscodium
    $regPath = "$( $ENV:USERPROFILE )\scoop\apps\vscodium\current\install-associations.reg"
    if (Test-Path -Path $regPath) {
        regedit.exe /s $regPath
    }

    if (Get-Process-Command -Name "VSCodium" -ErrorAction SilentlyContinue) {
        Stop-Process -Name "VSCodium" -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
    }

    # open url scheme
    $vscodeSchemeRegPath = "$( $ENV:DOTFILES_DIR )\.vscode\open-url-scheme.reg"
    if (Test-Path -Path $vscodeSchemeRegPath) {
        $schemeReg = Get-Content -Path $vscodeSchemeRegPath -Raw
        # replace path to current path
        $schemeReg = $schemeReg -replace "(?:[a-zA-Z]{1}:)[\w\\]+(?:scoop)", "$( $ENV:USERPROFILE -replace "\\", "\\"  )\\scoop"
        Set-Content -Path $vscodeSchemeRegPath -Value $schemeReg

        regedit.exe /s $vscodeSchemeRegPath
    }

    [Environment]::SetEnvironmentVariable("VSCODE_GALLERY_SERVICE_URL", "https://marketplace.visualstudio.com/_apis/public/gallery", "User")
    [Environment]::SetEnvironmentVariable("VSCODE_GALLERY_CACHE_URL", "https://vscode.blob.core.windows.net/gallery/index", "User")
    [Environment]::SetEnvironmentVariable("VSCODE_GALLERY_ITEM_URL", "https://marketplace.visualstudio.com/items", "User")

    codium --install-extension zokugun.vsix-manager --force

    Link-Path -Path "$( $ENV:USERPROFILE )\scoop\apps\vscodium\current\data\user-data\User\snippets" -Target "$( $ENV:DOTFILES_DIR )\.vscode\snippets"
    Link-Path -Path "$( $ENV:USERPROFILE )\scoop\apps\vscodium\current\data\user-data\User\settings.json" -Target "$( $ENV:DOTFILES_DIR )\.vscode\settings.json"
    Link-Path -Path "$( $ENV:USERPROFILE )\scoop\apps\vscodium\current\data\user-data\User\keybindings.json" -Target "$( $ENV:DOTFILES_DIR )\.vscode\keybindings.json"


    $vscodeSettingsPath = "$( $ENV:DOTFILES_DIR )\.vscode\settings.json"
    if (Test-Path -Path $vscodeSettingsPath) {
        $settings = Get-Content -Path $vscodeSettingsPath -Raw
        # apc.imports - change dotfiles path to current
        $settings = $settings -replace "(?:\/[a-zA-Z]{1}:)[\w\/]+(?:dotfiles)", "/$( $ENV:DOTFILES_DIR -replace "\\", "/"  )"
        Set-Content -Path $vscodeSettingsPath -Value $settings
    }
    New-Shortcut -Path "$((New-Object -ComObject WScript.Shell).SpecialFolders.Item("sendto"))\VSCodium.lnk" -Target "$( $ENV:USERPROFILE )\scoop\apps\vscodium\current\VSCodium.exe"
}

function InstallGlazeWM {
    scoop install extras/glazewm
    Link-Path -Path "$( $ENV:USERPROFILE )\.glaze-wm" -Target "$( $ENV:DOTFILES_DIR )\setup\glazewm"
}

function InstallNileSoftShell {
    scoop install extras/nilesoft-shell
	Link-Path -Path "$( $ENV:USERPROFILE )\scoop\apps\nilesoft-shell\current\shell.nss" -Target "$( $ENV:DOTFILES_DIR )\setup\nilesoft-shell\shell.nss";
	Link-Path -Path "$( $ENV:USERPROFILE )\scoop\apps\nilesoft-shell\current\imports" -Target "$( $ENV:DOTFILES_DIR )\setup\nilesoft-shell\imports";

    Invoke-File -FilePath "$( $ENV:USERPROFILE )\scoop\apps\nilesoft-shell\current\shell.exe" -ArgumentList "-register -treat -restart -silent" -ErrorAction SilentlyContinue
}
function InstallAHK {
    scoop install extras/autohotkey

    $vscodeSettingsPath = "$( $ENV:DOTFILES_DIR )\.vscode\settings.json"
    if (Test-Path -Path $vscodeSettingsPath) {
        $settings = Get-Content -Path $vscodeSettingsPath -Raw
        $ahk2Path = "$( $ENV:USERPROFILE -replace "\\", "\\" )\\scoop\\apps\\autohotkey\\current\\v2\\AutoHotkey64.exe"
        if (Test-Path $ahk2Path) {
            $settings = $settings -replace '"AutoHotkey2.InterpreterPath": .*', "`"AutoHotkey2.InterpreterPath`": `"$ahk2Path`","
        } else {
            $settings = $settings -replace '"AutoHotkey2.InterpreterPath": .*', "`"AutoHotkey2.InterpreterPath`": `"`","
        }
        Set-Content -Path $vscodeSettingsPath -Value $settings
    }
}

$Global:Error.Clear()
& {
    . "$( $ENV:DOTFILES_DIR )\setup\powershell\helper.ps1"

    if (-not (Scoop)) {
        return
    }

    Install7zip
    InstallGit
    Check
    InstallPython
    InstallNode
    InstallPowershell
    InstallVSCodium
    InstallGlazeWM
    InstallNileSoftShell

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

# Encoding
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

# Imports
function Load-Module ($m) {
    if (!(Get-Module | Where-Object {$_.Name -eq $m})) {
        if (Get-Module -ListAvailable | Where-Object {$_.Name -eq $m}) {
            Import-Module $m -Verbose
        } else {
            if (Find-Module -Name $m | Where-Object {$_.Name -eq $m}) {
                Install-Module -Name $m -Force -Verbose -Scope CurrentUser
                Import-Module $m -Verbose
            }
        }
    }
}
Load-Module "PSReadLine"
Load-Module "posh-git"
Load-Module "Terminal-Icons"
Load-Module "cd-extras"

if (Get-Module -ListAvailable -Name "PSReadLine" -ErrorAction SilentlyContinue) {
    Set-PSReadlineOption -BellStyle None
    Set-PSReadLineOption -ShowToolTips
    Set-PSReadLineOption -HistoryNoDuplicates
    Set-PSReadLineOption -HistorySearchCursorMovesToEnd
    Set-PSReadLineOption -HistorySaveStyle SaveIncrementally
    Set-PSReadLineOption -MaximumHistoryCount 4000

    Set-PSReadLineOption -PredictionSource History

    Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

    Set-PSReadlineKeyHandler -Chord "Shift+Tab" -Function Complete
    Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

    Set-PSReadlineKeyHandler -Key "Ctrl+d" -Function ViExit
    Set-PSReadLineKeyHandler -Key "Ctrl+z" -Function Undo
}

## Which
function which ($command) {
    Get-Command -Name $command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

# Aliases
Set-Alias l ls
Set-Alias g git
Set-Alias lg lazygit
Set-Alias code codium
Set-Alias py python

# Prompt
if (Get-Command "starship" -ErrorAction SilentlyContinue) { 
    $Env:STARSHIP_CONFIG="$Env:userprofile\.config\starship.toml"
    $Env:STARSHIP_DISTRO="SKY"
    Invoke-Expression (&starship init powershell)
}

if (Get-Command "komorebic" -ErrorAction SilentlyContinue) { 
    $Env:KOMOREBI_CONFIG_HOME = "$Env:userprofile\.config\komorebi"
    $Env:KOMOREBI_AHK_V1_EXE = "C:\Program Files\AutoHotkey\v1.1.36.02\AutoHotkeyU64.exe"
    $Env:KOMOREBI_AHK_V2_EXE = "C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe"
    
    function start-tiling {
        Start-Process "C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe" "$Env:userprofile\.dotfiles\.config\komorebi\komorebi.ahk"
    }

    function stop-tiling {
        komorebic.exe work-area-offset 0 0 0 0
        komorebic.exe stop
        
        if (Get-Command "pythonw.exe" -ErrorAction SilentlyContinue) { 
            taskkill.exe /f /im pythonw.exe
        }
    }

}

# Fix Prompt
clear
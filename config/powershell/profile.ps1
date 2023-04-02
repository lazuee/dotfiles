function Load-Module ($m) {
    if (!(Get-Module | Where-Object { $_.Name -eq $m })) {
        if (Get-Module -ListAvailable | Where-Object { $_.Name -eq $m }) {
            Import-Module $m -Verbose
        }
        else {
            if (Find-Module -Name $m | Where-Object { $_.Name -eq $m }) {
                Install-Module -Name $m -Force -Verbose -Scope CurrentUser
                Import-Module $m -Verbose
            }
        }
    }
}

Load-Module "PSProfiler"

Measure-Script {
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

    # Which
    function which ($command) {
        Get-Command -Name $command -ErrorAction SilentlyContinue |
        Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
    }

    # Aliases
    Set-Alias code codium
    Set-Alias py python

    # Prompt
    if (Get-Command "starship" -ErrorAction SilentlyContinue) {
        $ENV:STARSHIP_CONFIG = "$ENV:USERPROFILE\.config\starship.toml"
        $ENV:STARSHIP_DISTRO = "SKY"
        Invoke-Expression (&starship init powershell)
    }

    if (Get-Command "komorebic" -ErrorAction SilentlyContinue) {
        $ENV:KOMOREBI_CONFIG_HOME = "$ENV:USERPROFILE\.config\komorebi"
        $ENV:KOMOREBI_AHK_EXE = "C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe"

        function start-tiling {
            komorebic.exe start --await-configuration
            Start-Process -FilePath "C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe" -ArgumentList "$ENV:USERPROFILE\.config\komorebi\komorebi.ahk"
        }

        function stop-tiling {
            komorebic.exe restore-windows

            Stop-Process -Name "komorebi" -Force -ErrorAction SilentlyContinue
            Stop-Process -Name "pythonw" -Force -ErrorAction SilentlyContinue
        }

    }
}

# Fix Prompt
Clear-Host

Invoke-Expression (&starship init powershell)
[Environment]::SetEnvironmentVariable("HOME", "$( $ENV:USERPROFILE )", "User")
[Environment]::SetEnvironmentVariable("USER", "$( $ENV:USERNAME )", "User")

$ErrorActionPreference = "SilentlyContinue"

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

Load-Module "posh-git"
Load-Module "Terminal-Icons"
Load-Module "cd-extras"

function Execute-Command ($FilePath, $ArgumentList, $WorkingDirectory) {
    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = $FilePath
    $pinfo.RedirectStandardError = $true
    $pinfo.RedirectStandardOutput = $true
    $pinfo.UseShellExecute = $false
    $pinfo.Arguments = $ArgumentList
    $pinfo.WorkingDirectory = $WorkingDirectory
    $p = New-Object System.Diagnostics.Process
    $p.StartInfo = $pinfo
    $p.Start() | Out-Null
    $p.WaitForExit()
    # [pscustomobject]@{
    #     stdout = $p.StandardOutput.ReadToEnd()
    #     stderr = $p.StandardError.ReadToEnd()
    #     ExitCode = $p.ExitCode
    # }
}

function Get-Process-Command {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Name
    )
    Get-WmiObject Win32_Process -Filter "name = '$Name.exe'" -ErrorAction SilentlyContinue | Select-Object CommandLine,ProcessId
}

function Wait-For-Process {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Name,

        [Switch]$IgnoreExistingProcesses
    )

    if ($IgnoreExistingProcesses) {
        $NumberOfProcesses = (Get-Process -Name $Name -ErrorAction SilentlyContinue).Count
    } else {
        $NumberOfProcesses = 0
    }

    while ( (Get-Process -Name $Name -ErrorAction SilentlyContinue).Count -eq $NumberOfProcesses ) {
        Start-Sleep -Milliseconds 400
    }
}

## Which
function which {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Command
    )

    Get-Command -Name $Command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

# Aliases
Set-Alias code codium
Set-Alias py python

# Prompt
if (Get-Command "starship" -ErrorAction SilentlyContinue) {
    $ENV:STARSHIP_CONFIG = "$( $HOME )/.config/starship.toml"
    $ENV:STARSHIP_DISTRO = "SKY"
    Invoke-Expression (&starship init powershell)
}

if (Get-Command "komorebic" -ErrorAction SilentlyContinue) {
    $ENV:KOMOREBI_CONFIG_HOME = "$( $HOME )/.config/komorebi"
    $ENV:KOMOREBI_AHK_EXE = "$( $HOME )/scoop/apps/autohotkey/current/AutoHotkey64.exe"

    function start-tiling {
        Write-Host "[komorebi] Killing prior komorebi.exe Processes"
        Get-Process -Name "komorebi" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

        Write-Host "[komorebi] Running komorebic.exe start"
        Execute-Command -FilePath "$( $HOME )/scoop/apps/komorebi/current/komorebic.exe" -ArgumentList "start" -WorkingDirectory "$( $HOME )/.config/komorebi" -ErrorAction SilentlyContinue
        Wait-For-Process -Name "komorebi"
        Start-Sleep 3

        Write-Host "[ahk] Starting AutoHotKey"
        Execute-Command -FilePath "$( $HOME )/scoop/apps/autohotkey/current/AutoHotkey64.exe" -ArgumentList "$( $HOME )/.config/komorebi/komorebi.ahk" -WorkingDirectory "$( $HOME )/.config/komorebi" -ErrorAction SilentlyContinue
    }

    function stop-tiling {
        Write-Host "[komorebi] Issuing komorebic stop"

        Execute-Command -FilePath "$( $HOME )/scoop/apps/komorebi/current/komorebic.exe" -ArgumentList "stop" -WorkingDirectory "$( $HOME )/.config/komorebi" -ErrorAction SilentlyContinue
        Write-Host "[komorebi] Terminating Remaining komorebi Processes"
        Get-Process -Name "komorebi" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
        Wait-Process -Name "komorebi" -ErrorAction SilentlyContinue

        Write-Host "[komorebi] Checking for Processes"
        Get-Process-Command -Name "komorebi" -ErrorAction SilentlyContinue

        Write-Host "[ahk] Killing Process"
        Get-Process -Name "AutoHotKey" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
        Wait-Process -Name "AutoHotKey" -ErrorAction SilentlyContinue
    }

}

# Fix Prompt
Clear-Host

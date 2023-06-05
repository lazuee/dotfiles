function Start-App {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Path,

        [string]$ArgumentList
    )
    $appFolder = Split-Path -Path $Path -Parent
    $appExe = Split-Path -Path $Path -Leaf

    $run_procgov = "C:\Apps\ProcGov\procgov64.exe --recursive --cpu=0x2 --cpurate=70 --minws=1M -maxws=512M --timeout=20s --process-utime=10s --job-utime=10s --newconsole --verbose --"
	$run_app = ".\$( $appExe ) $( $ArgumentList)"
	$locate_app = "Set-Location '$( $appFolder )'"

    if ($PSVersionTable.PSEdition -eq "Desktop") {
        Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"$( $locate_app ); $( $run_procgov ) $( $run_app ); Start-Sleep -Seconds 5; exit 1`"" -Verb RunAs
    } else {
        Start-Process -FilePath "pwsh.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"$( $locate_app ); $( $run_procgov ) $( $run_app ); Start-Sleep -Seconds 5; exit 1`"" -Verb RunAs
    }
}

function Start-Edge {

    Launch -Path "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" -ArgumentList "--profile-directory=Default"
}

function Start-Firefox {

    Launch -Path "$( $ENV:HOME )\scoop\apps\firefox\current\firefox.exe"
}
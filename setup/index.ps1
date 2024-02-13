$Global:DotfilesError = @()

if (-not (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
    exit 1
}

Write-Host "Fresh windows..."
& ./fresh/index.ps1
Write-Host "Scoop apps..."
& ./scoop/index.ps1

if ($Global:DotfilesError.Count -gt 0) {
    foreach ($error in $Global:DotfilesError) {
        Write-Host "Got errors while using the script: $( $error.File )" -ForegroundColor Red
        $error.Errors | Sort-Object -Property Line | Format-Table -AutoSize -Wrap
    }
}

Read-Host "Done! thanks for using it..."

function Test-App {
    param (
        [Parameter(Mandatory = $false)]
        [string]$App
    )

    if ([string]::IsNullOrWhiteSpace($App)) {
        return $false
    }

    return (
        (Get-Command $App -ErrorAction SilentlyContinue) -or
        (Test-Path ([Environment]::ExpandEnvironmentVariables($App))) -or
        (winget list --id $App)
    )
}


function Link-Path {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Path,

        [Parameter(Mandatory=$true)]
        [string]$Target
    )

    if (!(Test-Path -Path $Target)) {
        Write-Warning "symlink: [target not found](failed) $Target"
        return
    }

    Remove-Item -Path $Path -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue | Out-Null
    New-Item -ItemType Directory -Path (Split-Path -Parent $Path) -Force -ErrorAction SilentlyContinue | Out-Null

    foreach ($type in @("Container", "Leaf")) {
        if (Test-Path -Path $Target -PathType $type) {
            switch ($type) {
                "Container" {
                    try {
                        Write-Host "symlink: [folder] $Target -> $Path"
                        New-Item -ItemType Junction -Path $Path -Target $Target -Force | Out-Null
                    }
                    catch {
                        Write-Warning "symlink: [folder](failed) $Target -> $Path"
                        Write-Error $_
                    }
                }
                "Leaf" {
                    try {
                        Write-Host "symlink: [file] $Target -> $Path"
                        New-Item -ItemType SymbolicLink -Path $Path -Target $Target -Force | Out-Null
                    }
                    catch {
                        Write-Warning "symlink: [file](failed) $Target -> $Path"
                        Write-Error $_
                    }
                }
            }
            break
        }
    }
}

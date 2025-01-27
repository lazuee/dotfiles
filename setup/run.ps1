$env:HOME = $env:USERPROFILE
$env:USER = $env:USERNAME
$env:DOTFILES = (Get-Item $PSScriptRoot).Parent.FullName
[Environment]::SetEnvironmentVariable("HOME", "$env:HOME", "User")
[Environment]::SetEnvironmentVariable("USER", "$env:USER", "User")
[Environment]::SetEnvironmentVariable("DOTFILES", "$env:DOTFILES", "User")

Import-Module (Join-Path $env:DOTFILES ".config\powershell\functions.psm1") -DisableNameChecking -Force

$config = Get-Content -Path ".\setup\config.json" | ConvertFrom-Json

foreach ($link in $config.symlinks) {
  $source = (Join-Path $env:DOTFILES $link[0].Replace("/", "\"))
  $destination = [Environment]::ExpandEnvironmentVariables($link[1].Replace("/", "\"))

  Link-Path -Target $source -Path $destination
}

foreach ($bucket in $config.scoop.buckets) {
  Invoke-Expression "scoop bucket add $($bucket[0]) $($bucket[1])" *>$null
}

Invoke-Expression "scoop update" *>$null

foreach ($app in $config.scoop.apps) {
  if (Test-App -App $app[0]) {
    Write-Host "scoop: Updating $($app[1])..."
    Invoke-Expression "scoop update $($app[1])" *>$null
  } else {
    Write-Host "scoop: Installing $($app[1])..."
    Invoke-Expression "scoop install $($app[1])" *>$null
  }

  if (!([string]::IsNullOrWhiteSpace($app[2]))) {
    Write-Host "scoop: Running post-install for $($app[1])..."
    try {
      Invoke-Expression $app[2] *>$null
    }
    catch {
      Write-Warning "scoop: Post-install failed for $($app[1])"
      Write-Error $_.Exception.Message
    }
  }
}

foreach ($app in $config.winget.apps) {
  if ([string]::IsNullOrWhiteSpace($app[0])) {
    $app[0] = $app[1]
  }

  if (Test-App -App $app[0]) {
    Write-Host "winget: Updating $($app[1])..."
    Invoke-Expression "winget upgrade $($app[1])" *>$null
  } else {
    Write-Host "winget: Installing $($app[1])..."
    Invoke-Expression "winget install $($app[1])" *>$null
  }

  if (!([string]::IsNullOrWhiteSpace($app[2]))) {
    Write-Host "winget: Running post-install for $($app[1])..."
    try {
      Invoke-Expression $app[2] *>$null
    }
    catch {
      Write-Warning "winget: Post-install failed for $($app[1])"
      Write-Error $_.Exception.Message
    }
  }
}

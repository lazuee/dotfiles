if ($MyInvocation.MyCommand.Path -notlike "$( $ENV:TEMP )\*") {
    Copy-Item -Path $MyInvocation.MyCommand.Path -Destination $ENV:TEMP -Recurse -Force -ErrorAction Ignore
    Invoke-Expression -Command (Join-Path -Path $ENV:TEMP -ChildPath (Split-Path -Path $MyInvocation.MyCommand.Path -Leaf))
    exit
}

$ENV:DOTFILES_DIR = Resolve-Path -Path "$( $ENV:USERPROFILE )/dotfiles"
[Environment]::SetEnvironmentVariable("DOTFILES_DIR", $ENV:DOTFILES_DIR, "User")

switch ($PSVersionTable.PSEdition) {
  "Core" { $exe = "pwsh" }
  "Desktop" { $exe = "powershell" }
}

Start-Process $exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"Set-Location $( "$ENV:DOTFILES_DIR/setup" ); & .\index.ps1`"" -Verb RunAs
exit

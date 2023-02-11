@echo off
pause
title Lazuee - dotfiles

@set dotfiles=%~dp0
@set dotfiles=%dotfiles:~0,-1%

cd %dotfiles%

dism >nul 2>&1
if %errorlevel% equ 0 (
  goto main
) else (
  echo This script must be Run as Administrator.
  echo Error Code: %errorlevel%
  pause
)
exit /b

:main

call :remove "%userprofile%\.gitconfig"
if not exist "%userprofile%\.gitconfig" (
    :: most likely our first run, add temporary git settings until config is pulled:
    git config --global http.sslVerify false
    git config --global user.name "lazuee"
    git config --global user.email "lazuee.dev@gmail.com"
)

if not exist "%userprofile%\.config" mkdir "%userprofile%\.config"

echo Linking...

call :link "%appdata%\VSCodium\User\settings.json" "%dotfiles%\.config\.vscode\settings.json"
call :link "%appdata%\VSCodium\User\keybindings.json" "%dotfiles%\.config\.vscode\keybindings.json"
call :link "C:\Program Files\VSCodium\resources\app\product.json" "%dotfiles%\.config\.vscode\product.json"

call :link "%appdata%\discord\settings.json" "%dotfiles%\.config\discord\settings.json"

call :link "%userprofile%\.config\komorebi" "%dotfiles%\.config\komorebi"
call :link "%userprofile%\.config\yasb" "%dotfiles%\.config\yasb"

call :link "%userprofile%\.config\starship.toml" "%dotfiles%\.config\starship.toml"

call :link "%userprofile%\Documents\PowerShell" "%dotfiles%\.config\pwsh"

call :link "%userprofile%\.bashrc" "%dotfiles%\.config\.bashrc"

if exist "%dotfiles%\tools\DragDropNormalizer.exe" (
    if not exist "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\dragdrop.lnk" (
      powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\dragdropNormalizer.lnk'); $s.TargetPath='%dotfiles%\tools\DragDropNormalizer.exe'; $s.Save()"
    )

    start "" "%dotfiles%\tools\DragDropNormalizer.exe"
)

echo Setup complete.
echo Press any key to continue...
pause > nul

exit /b

:link

@set target=%~1
@set source=%~2

call :remove "%target%"

if exist "%target%" (
    echo Error: linked target exist! [%target%]
    pause
) else (
  if exist "%source%\*" (
    mklink /d "%target%" "%source%" > nul 2>&1
    if %errorlevel% equ 0 (
      echo Success: linked directory [%target%]
    ) else (
      echo Error: linked failed! [%target%]
    )
  ) else if exist "%source%" (
    mklink "%target%" "%source%" > nul 2>&1
    if %errorlevel% equ 0 (
      echo Success: linked file [%target%]
    ) else (
      echo Error: linked failed! [%target%]
    )
  ) else (
    echo Error: not found [%source%]
  )
)

exit /b

:remove

@set target=%~1

if exist "%target%" (
    rmdir /s /q "%target%" 2> nul
    if exist "%target%" (
      del /q "%target%" 2> nul
    )
)

exit /b

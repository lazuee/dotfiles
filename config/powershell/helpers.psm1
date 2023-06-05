$PSDefaultParameterValues["Out-File:Encoding"] = "utf8"
$ErrorActionPreference = "SilentlyContinue"

function Import-Module-Verified ($m) {

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

function Test-Command-Exists {
    Param (
        [Parameter(Mandatory=$true)]
        [string]$Command
    )
    $OldPreference = $ErrorActionPreference
    $ErrorActionPreference = "stop"

    try {
        if (Get-Command $Command) {
            return $true
        }
    } catch {
       return $false
    } finally {
        $ErrorActionPreference = $OldPreference
    }
}

function Invoke-File {
    param (
        [Parameter(Mandatory=$true)]
        [string]$FilePath,

        [string]$ArgumentList,
        [string]$WorkingDirectory
    )

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

function Link-Path {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Path,

        [Parameter(Mandatory=$true)]
        [string]$Target
    )

    if (Test-Path -Path $path) {
        Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
    }

    foreach ($type in @("Container", "Leaf")) {
        if (Test-Path -Path $target -PathType $type) {

            switch ($type) {
                "Container" {
                    try {

                        Write-Host "Linking folder ($( $path )) to ($( $target ))..."
                        New-Item -ItemType Junction -Path $path -Target $target -Force | Out-Null
                    }
                    catch {
                        Write-Warning "Error occurred while Linking folder '$( $target )':"
                        Write-Error "--- | $( $_ )"
                    }

                }
                "Leaf" {
                    try {
                        Write-Host "Linking file ($( $path )) to ($( $target ))..."
                        New-Item -ItemType SymbolicLink -Path $path -Target $target -Force | Out-Null
                    }
                    catch {
                        Write-Warning "Error occurred while Linking file '$( $target )':"
                        Write-Error "--- | $( $_ )"
                    }
                }
            }

            break
        }
    }

    Start-Sleep -Seconds 2
}

function New-Shortcut {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Path,

        [Parameter(Mandatory=$true)]
        [string]$Target,

        [string]$ArgumentList
    )

    if (!(Test-Path -Path $Target)) {
		throw "The target file doesn't exist."
	}

	try {
		Write-Host "Creating shortcut for $( (Split-Path $Target -Leaf) )..."
		$shortcut_path = "$( $Path )"
		if (Test-Path -Path $shortcut_path) {
			Remove-Item -Path $shortcut_path -Recurse -Force -ErrorAction SilentlyContinue
		}

		$shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut($shortcut_path)
		$shortcut.TargetPath = $Target
		if ($ArgumentList) {
			$shortcut.Arguments = $ArgumentList
		}
		$shortcut.Save()

	}
	catch {
		Write-Warning "Error occurred while creating shortcut '$( $Path )':"
		Write-Error "--- | $( $_ )" -ForegroundColor Red
	}

}

function Install-Fonts {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Paths
    )

    $totalCount = $Paths.Count
    $currentCount = 0
    $fontsPath = "C:\Windows\Fonts"

    foreach ($path in $Paths) {
        if (Test-Path -Path $path) {
            $currentCount++

            Write-Host "($( $currentCount )/$( $totalCount )) - installing fonts '$( (Split-Path $path -Leaf) )'..."

            foreach($file in Get-ChildItem $path -Include '*.ttf','*.ttc','*.otf' -recurse ) {
	            $target = Join-Path $fontsPath $file.Name
	            if(Test-Path -Path $target){
		            $file.Name + " already installed"
	            }
	            else {
		            Write-Host "Installing font $( $file.Name )"

		            $ShellFolder = (New-Object -COMObject Shell.Application).Namespace($path)
		            $ShellFile = $ShellFolder.ParseName($file.name)
		            $ShellFileType = $ShellFolder.GetDetailsOf($ShellFile, 2)

		            if ($ShellFileType -Like '*TrueType font file*') { $FontType = '(TrueType)' }

		            $RegName = $ShellFolder.GetDetailsOf($ShellFile, 21) + ' ' + $FontType
		            New-ItemProperty -Name $RegName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -PropertyType string -Value $file.name -Force | out-null
		            Copy-item $file.FullName -Destination $fontsPath -Force -ErrorAction SilentlyContinue
	            }
            }

        }

        Start-Sleep -Seconds 2
    }
}

function Download-File {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Url,

        [string]$Destination
    )

	# if (!(Test-NetConnection www.google.com).PingSucceeded) { throw "No Internet Connection" }

    $tempFileName = ([System.IO.Path]::GetFileName($Url))
    $tempFile = Join-Path $ENV:TEMP $tempFileName

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $Url -OutFile $tempFile

    if ($Destination) {
        if (!(Test-Path -Path $Destination)) {
            New-Item -ItemType Directory -Path $Destination
        }

        $extension = [System.IO.Path]::GetExtension($tempFile)

        if ($extension -eq ".zip") {
            Expand-Archive -Path $tempFile -DestinationPath $Destination
        } else {
            Copy-Item -Path $tempFile -Destination $Destination -Recurse -Force -ErrorAction SilentlyContinue
        }

        if (Test-Path -Path $tempFile) {
            Remove-Item -Path $tempFile -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}

function Which {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Command
    )

    Get-Command -Name $Command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}


function Set-ItemProperty-Verified {
    param (
        [Parameter(Mandatory=$true)]
        [string[]] $Path,

        [string] $Name,

        [ValidateSet('Binary', 'DWord', 'ExpandString', 'MultiString', 'Qword', 'String', 'Unknown')]
        [string] $Type,

        $Value
    )

    if (!(Test-Path $Path)) {
        New-Item -Path $Path -Force >$null
    }

	if ($Name) {
		if ($Type) {
			Set-ItemProperty -Path "$Path" -Name "$Name" -Type $Type -Value $Value
		} else {
			Set-ItemProperty -Path "$Path" -Name "$Name" -Value $Value
		}
	}
}

function Set-SystemColor() {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Color
    )
        try {
            $colorObject = [System.Drawing.ColorTranslator]::FromHtml($Color)
        } catch {
            throw "Invalid color parameter. Please specify a valid color name or hex value."
        }

        $red = $colorObject.R
        $green = $colorObject.G
        $blue = $colorObject.B
        $colorHex = "{0:X2}{1:X2}{2:X2}" -f $red, $green, $blue
        $colorRGB = "$($colorHex[4..5] + $colorHex[2..3] + $colorHex[0..1])".Split(" ") -join ""

        $pathDesktop = "HKCU:\Control Panel\Desktop"
        $pathDWM = "HKCU:\SOFTWARE\Microsoft\Windows\DWM"
        $pathColorAccent = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Accent"
        $pathColorHistory = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\History\Colors"
        $pathThemePersonalize = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
        $pathThemeHistory = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\History"

        $Max = 32
        $RandomBytes = [System.Collections.ArrayList]@()
        ForEach ($i in 1..$Max) {
            $Byte = "0x{0:X2}" -f (Get-Random -Maximum 0xFF)

            if ($i % 4 -eq 0) {
                $Byte = "0xFF"
            }

            if ($i -eq $Max) {
                $Byte = "0x00"
            }

            if ($i -in (1, 5, 9, 13, 17, 21, 25)) {
                $Byte = "0x$($colorHex[0..1])".Split(" ") -join ""
            }

            if ($i -in (2, 6, 10, 14, 18, 22, 26)) {
                $Byte = "0x$($colorHex[2..3])".Split(" ") -join ""
            }

            if ($i -in (3, 7, 11, 15, 19, 23, 27)) {
                $Byte = "0x$($colorHex[4..5])".Split(" ") -join ""
            }

            $RandomBytes.Add($Byte)
        }

        # Taskbar and Settings color
        Set-ItemProperty-Verified -Path "$pathColorAccent" -Name "AccentPalette" -Type Binary -Value ([byte[]]($RandomBytes[0], $RandomBytes[1], $RandomBytes[2], $RandomBytes[3], $RandomBytes[4], $RandomBytes[5], $RandomBytes[6], $RandomBytes[7], $RandomBytes[8], $RandomBytes[9], $RandomBytes[10], $RandomBytes[11], $RandomBytes[12], $RandomBytes[13], $RandomBytes[14], $RandomBytes[15], $RandomBytes[16], $RandomBytes[17], $RandomBytes[18], $RandomBytes[19], $RandomBytes[20], $RandomBytes[21], $RandomBytes[22], $RandomBytes[23], $RandomBytes[24], $RandomBytes[25], $RandomBytes[26], $RandomBytes[27], $RandomBytes[28], $RandomBytes[29], $RandomBytes[30], $RandomBytes[31]))

        # Window Top Color
        Set-ItemProperty-Verified -Path "$pathDWM" -Name "AccentColor" -Type DWord -Value 0xff$colorHex
        Set-ItemProperty-Verified -Path "$pathDWM" -Name "ColorizationAfterglow" -Type DWord -Value 0xc4$colorHex
        Set-ItemProperty-Verified -Path "$pathDWM" -Name "ColorizationColor" -Type DWord -Value 0xc4$colorHex

        # Window Border Color
        Set-ItemProperty-Verified -Path "$pathColorAccent" -Name "AccentColorMenu" -Type DWord -Value 0xff$colorRGB
        Set-ItemProperty-Verified -Path "$pathColorAccent" -Name "StartColorMenu" -Type DWord -Value 0xff$colorHex

        # Start, Taskbar and Action center
        Set-ItemProperty-Verified -Path "$pathThemePersonalize" -Name "ColorPrevalence" -Type DWord -Value 0

        # Title Bars and Windows Borders
        Set-ItemProperty-Verified -Path "$pathDWM" -Name "ColorPrevalence" -Type DWord -Value 1

        # Window Color History
        $colorHistory = Get-ItemPropertyValue $pathColorHistory -Name ColorHistory
        $colorHistory[1..5] | ForEach-Object { Set-ItemProperty-Verified $pathColorHistory "ColorHistory$($_ - 1)" DWord $_ }
        Set-ItemProperty-Verified -Path "$pathColorHistory" -Name "ColorHistory0" -Type DWord -Value 0xff$colorRGB

        # Miscellaneous stuff (didn't work)
        Set-ItemProperty-Verified -Path "$pathDWM" -Name "ColorizationAfterglowBalance" -Type DWord -Value 10
        # Set-ItemProperty-Verified -Path "$pathDWM" -Name "ColorizationBlurBalance" -Type DWord -Value 1
        Set-ItemProperty-Verified -Path "$pathDWM" -Name "ColorizationColorBalance" -Type DWord -Value 89
        Set-ItemProperty-Verified -Path "$pathDWM" -Name "ColorizationGlassAttribute" -Type DWord -Value 0
        Set-ItemProperty-Verified -Path "$pathDWM" -Name "ColorizationGlassAttribute" -Type DWord -Value 1
        Set-ItemProperty-Verified -Path "$pathDWM" -Name "EnableWindowColorization" -Type DWord -Value 1

        Set-ItemProperty-Verified -Path "$pathDesktop" -Name "AutoColorization" -Type DWord -Value 0
        Set-ItemProperty-Verified -Path "$pathThemeHistory" -Name "AutoColor" -Type DWord -Value 0
}
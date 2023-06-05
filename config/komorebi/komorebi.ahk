#Requires AutoHotkey v2.0.2
#SingleInstance Force
#Warn All, Off

DetectHiddenWindows("On")
ProcessSetPriority("High")
Persistent(true)
SendMode("Input")
SetWorkingDir(A_ScriptDir)

#Include ahk/common.ahk
#Include ahk/opacityWindows.ahk
#Include ahk/apps.ahk
; #Include ahk/minWindowed.ahk

writeLog("[Komorebi] Starting...")
#Include komorebic.lib.ahk

containerPadAmount := 12
workspacePadAmount := 12
workspaceCount := 9
monitorCount := MonitorGetCount()
;writeLog("[Komorebi] Workspace count: " workspaceCount)
;writeLog("[Komorebi] Monitor count: " monitorCount "`n")

OnExit(OnExiting)
OnExiting(exit_reason, exit_code) {
    if (exit_reason == "Menu") {
        writeLog("[AutoHotkey] Exited, gracefully stop komorebi... " exit_code)

        KomorebiStop()
        ExitApp(exit_code)
    } else {
        writeLog("[AutoHotkey] komorebi.ahk is restarting...")
    }
}

KomorebiStart() {
	; RunWait('powershell -NoProfile -ExecutionPolicy Bypass -Command ". ' A_ScriptDir '\komorebi.generated.ps1"', , "Hide")

    ; InvisibleBorders(7, 0, 14, 7)
    ; ActiveWindowBorderColour(255, 219, 153, "single")
    ; ActiveWindowBorderColour(153, 158, 255, "stack")
    ; ActiveWindowBorderColour(160, 255, 153, "monocle")
    ; ActiveWindowBorderWidth("12")
    ; ActiveWindowBorderOffset("-- -4")
    ; ActiveWindowBorder("disable")

    ; https://github.com/sitiom/dotfiles/blob/main/chezmoi/komorebi.ahk#L20-L28
    Loop monitorCount {
        monitorIndex := A_Index - 1
        EnsureWorkspaces(monitorIndex, workspaceCount)
        Loop workspaceCount {
            workspaceIndex := A_Index - 1
            ContainerPadding(monitorIndex, workspaceIndex, containerPadAmount)
            WorkspacePadding(monitorIndex, workspaceIndex, workspacePadAmount)
        }
    }

    writeLog("[Komorebi] Started!")
}


KomorebiStop() {
    if ProcessExist("komorebi.exe") {
        writeLog("[Komorebi] Stopping...")
        RestoreWindows()
        Retile()
        Sleep(3000)
        Stop()
        RunWait('powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-Process | Where-Object { $_.Name -eq "komorebi" } | Stop-Process"')
        writeLog("[Komorebi] Stopped!")
    }
}

KomorebiStart()

; CONTROLS
; #	Win (Windows logo key)
; !	Alt
; ^	Ctrl
; +	Shift
; &	An ampersand may be used between any two keys or mouse buttons to combine them into a custom hotkey.

Loop workspaceCount {
    ; Switch to workspace,  Alt + 1~9
    Hotkey("!" A_Index, (key) => writeLog("[Komorebi] Switch workspace No. " Integer(SubStr(key, 2)))
        FocusWorkspace(Integer(SubStr(key, 2)) - 1)
        , "On")
    ; Move window to workspace, Alt + Shift + 1~9
    Hotkey("!+" A_Index, (key) => writeLog("[Komorebi] Move window to workspace No. " Integer(SubStr(key, 3)))
        MoveToWorkspace(Integer(SubStr(key, 3)) - 1)
        , "On")
}

; Focus window, Alt + Shift + (H, J, K, L)
!h:: Focus("left")
!j:: Focus("down")
!k:: Focus("up")
!l:: Focus("right")

; Cycle Focus window, Alt + Shift + ([, ])
!+[:: CycleFocus("previous")
!+]:: CycleFocus("next")

; Move window, Alt + Shift + (H, J, K, L, Enter)
!+h:: Move("left")
!+j:: Move("down")
!+k:: Move("up")
!+l:: Move("right")
!+Enter:: Promote()

; Stack window, Alt + (Left, Right, Up, Down)
!Left:: Stack("left")
!Right:: Stack("right")
!Up:: Stack("up")
!Down:: Stack("down")

; Unstack window, Alt + ;
!;:: Unstack()

; Cycle stack window, Alt + ([, ])
![:: CycleStack("previous")
!]:: CycleStack("next")

; Resize window horizontal, Alt  + (-, =)
!=:: ResizeAxis("horizontal", "increase")
!-:: ResizeAxis("horizontal", "decrease")

; Resize window vertical, Alt  + Shift + (-, =)
!+=:: ResizeAxis("vertical", "increase")
!+-:: ResizeAxis("vertical", "decrease")

; Manipulate windows
!t:: {
    writeLog("[Komorebi] Float focused window")
    ToggleFloat()
}

!+f:: {
    writeLog("[Komorebi] Monocle window")
    ToggleMonocle()
}

; Force a retile, Alt + Shift + R
!+r:: {
    writeLog("[Komorebi] Retiling windows")
    Retile()
}

; Reload komorebi.ahk, Alt + O
!o:: {
    writeLog("[Komorebi] Reload configuration")
    ReloadConfiguration()
}

; Quit komorebi.ahk, Alt + Shift + O
!+o:: {
    writeLog("[Komorebi] Exiting, wait for a moment...")
    KomorebiStop()
    ExitApp()
}

; Close application, Alt + Q
!q:: {
    writeLog("[Komorebi] Close actived window")
    Send("!{f4}")
}
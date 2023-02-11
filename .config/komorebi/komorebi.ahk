#Requires AutoHotkey v2.0.2
#SingleInstance Force

DetectHiddenWindows("On")
ProcessSetPriority("High")
Persistent(true)
SendMode("Input")
SetWorkingDir(A_ScriptDir)

#Include komorebi.lib.ahk
#Include ahk/variables.ahk
#Include ahk/common.ahk
#Include ahk/terminal.ahk

containerPadAmount := 8
workspacePadAmount := 8
workspaceCount := 6
monitorCount := MonitorGetCount()
writeLog("[Komorebi] Workspace count: " workspaceCount)
writeLog("[Komorebi] Monitor count: " monitorCount "`n")

OnMessage(0x7E, onDisplayChange)
onDisplayChange(wParam, lParam, msg, hwnd) {
    writeLog("[Komorebi] Display Changed...")
    KoremibiRestart()
}

KomorebiStart() {
    ; if ProcessExist("komorebi.exe") {
    ;     writeLog("[Komorebi] Still running!")
    ;     KomorebiStop()

    ;     writeLog("[Komorebi] Done! Now proceed to start.")
    ; }

    if not ProcessExist("komorebi.exe") {
        writeLog("[Komorebi] Not running! executing start...")
        RunWait("komorebic.exe start --await-configuration")
    }
    Sleep(5000)

    yasb_start()

    writeLog("")
    writeLog("[Komorebi] Starting...")

    CrossMonitorMoveBehaviour("insert")
    WindowHidingBehaviour("hide")
    WatchConfiguration("enable")
    InvisibleBorders(7, 0, 14, 7)
    ToggleFocusFollowsMouse("windows")
    ToggleMouseFollowsFocus()

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

    ; Configure floating rules
    FloatRule("class", "ExplorerBrowserControl")
    FloatRule("class", "OperationStatusWindow")
    FloatRule("class", "MsiDialogCloseClass")
    FloatRule("class", "TaskManagerWindow")
    FloatRule("title", "Control Panel")
    FloatRule("title", "Window Spy")
    FloatRule("exe", "git-credential-helper-selector.exe")
    FloatRule("exe", "ApplicationFrameHost.exe")
    FloatRule("exe", "msiexec.exe")
    FloatRule("exe", "ahk.exe")

    ; Identify applications to be forcibly managed
    ManageRule("class", "ConsoleWindowClass")
    ManageRule("exe", "foobar2000.exe")

    ; Identify Minimize-to-Tray Applications
    IdentifyTrayApplication("exe", "AutoHotkeyU64.exe")
    IdentifyTrayApplication("exe", "Steam++.exe")
    IdentifyTrayApplication("exe", "Discord.exe")
    IdentifyTrayApplication("exe", "Spotify.exe")
    IdentifyTrayApplication("exe", "ShareX.exe")

    ; Identify applications that have overflowing borders
    IdentifyBorderOverflowApplication("exe", "VSCodium.exe")
    IdentifyBorderOverflowApplication("exe", "Discord.exe")
    IdentifyBorderOverflowApplication("exe", "Spotify.exe")
    IdentifyBorderOverflowApplication("exe", "ShareX.exe")
    IdentifyBorderOverflowApplication("exe", "opera.exe")

    ; Allow komorebi to start managing windows
    CompleteConfiguration()

    ; Retile windows
    Sleep(1500)
    writeLog("[Komorebi] Retiling windows")
    Retile()
    writeLog("[Komorebi] Started!")
}

yasb_start() {
    if not ProcessExist("pythonw.exe") {
        writeLog("")
        writeLog("[Yasb] Starting...")
        RunWait("pythonw " A_ScriptDir "\yasb\src\main.py", , "Hide")
        writeLog("[Yasb] Started!")
    }
}

KomorebiStop() {
    if ProcessExist("komorebi.exe") {
        writeLog("[Komorebi] Stopping...")
        RunWait("komorebic.exe restore-windows", , "Hide")
        RunWait("komorebic.exe stop", , "Hide")
        ; RunWait("powershell Stop-Process -Name 'komorebi' -Force -ErrorAction SilentlyContinue", , "Hide")
        writeLog("[Komorebi] Stopped!")
    }

    YasbStop()
}

YasbStop() {
    if ProcessExist("pythonw.exe") {
        writeLog("[Yasb] Stopping...")
        RunWait("powershell Stop-Process -Name 'pythonw' -Force -ErrorAction SilentlyContinue", , "Hide")
        writeLog("[Yasb] Stopped!")
    }
}

KoremibiRestart() {
    writeLog("[Komorebi] Restart!")
    ReloadConfiguration()
    KomorebiStop()
    Reload()
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

; Force a retile, Alt + Shift + R
!+r:: {
    writeLog("[Komorebi] Retiling windows")
    Retile()
}
; Float the focused window, Alt + T
!t:: {
    writeLog("[Komorebi] Float focused window")
    ToggleFloat()
}
; Reload komorebi.ahk, Alt + O
!o:: {
    writeLog("[Komorebi] Reload configuration")
    ReloadConfiguration()
    KoremibiRestart()
}
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
; Open Windows Terminal, Alt + Enter
!Enter:: {
    ToggleTerminal()
}

#HotIf WinActive("ahk_exe i)\\spotify\.exe$",)
^wheelup:: SendInput("^{=}")
^wheeldown:: SendInput("^{-}")
#HotIf
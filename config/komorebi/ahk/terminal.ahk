#Requires AutoHotkey v2.0.2
#SingleInstance Force

#Include variables.ahk
#Include common.ahk

; Open Windows Terminal, Alt + Enter
!Enter:: {
    ToggleTerminal()
}

ToggleTerminal() {
    matcher := "ahk_class CASCADIA_HOSTING_WINDOW_CLASS"
    DetectHiddenWindows(true)

    if WinExist(matcher) {

        if !WinActive(matcher) {
            HideTerminal()
            ShowTerminal()
            writeLog("[Terminal] Toggle Show")
        } else if WinExist(matcher) {
            HideTerminal()
            writeLog("[Terminal] Toggle Hide")
        }

    } else {
        OpenNewTerminal()
        writeLog("[Terminal] Toggle Open")
    }
}

OpenNewTerminal() {
    Run(windowsApp_path "\wt.exe")
    Sleep(1000)
    ShowTerminal()
}

ShowTerminal() {
    WinShow("ahk_class CASCADIA_HOSTING_WINDOW_CLASS")
    WinActivate("ahk_class CASCADIA_HOSTING_WINDOW_CLASS")
}

HideTerminal() {
    WinHide("ahk_class CASCADIA_HOSTING_WINDOW_CLASS")
}
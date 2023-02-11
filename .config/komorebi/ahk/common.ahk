#Requires AutoHotkey v2.0.2
#SingleInstance Force

#Include variables.ahk

writeLog(text) {
    FileAppend(text "`n", configfiles_path "\.dotfiles.log")
    OutputDebug(text "`n")
    return
}

CenterWindow() {
    WinTitle := WinGetTitle("A")
    WinGetPos , , &Width, &Height, WinTitle

    MonitorGetWorkArea A_Index, &Left, &Top, &Right, &Bottom

    TargetX := (Right / 2) - (Width / 2)
    TargetY := (Bottom / 2) - (Height / 2)

    WinMove TargetX, TargetY, , , WinTitle

    Return
}
#Requires AutoHotkey v2.0.2
#SingleInstance Force

writeLog(text) {
    FileAppend(text "`n", "C:\Users\" A_UserName "\.config\.dotfiles.log")
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

    return
}

ListWindows() {
    oid := WinGetlist(, , "Find",)
    aid := Array()
    id := oid.Length
    For v in oid
    {
        aid.Push(v)
    }

    ids := Array()
    Loop aid.Length
    {
        this_ID := aid[A_Index]
        If (!IsWindow(WinExist("ahk_id" . this_ID)))
            continue
        title := WinGetTitle("ahk_id " this_ID)
        If (title = "")
            continue

        ids.Push(this_ID)
    }

    return ids

}

IsWindow(hWnd) {
    if (hWnd = 0) {
        return false
    }
    dwStyle := WinGetStyle("ahk_id " hWnd)
    if ((dwStyle & 0x08000000) || !(dwStyle & 0x10000000)) {    ; Window with a style that doesn't activate (WS_EX_NOACTIVATE 0x08000000L), or not visible (WS_VISIBLE 0x10000000 )
        return false
    }
    dwExStyle := WinGetExStyle("ahk_id " hWnd)
    if (dwExStyle & 0x00000080) {    ; The window is a floating toolbar (WS_EX_TOOLWINDOW 0x00000080)
        return false
    }
    dwExStyle := WinGetExStyle("ahk_id " hWnd)
    if (dwExStyle & 0x00040000) {    ; top-level windows that tend to be forced to the top
        return false
    }
    dwExStyle := WinGetExStyle("ahk_id " hWnd)
    if (dwExStyle & 0x00000008) {    ; to exclude Always-On-top windows (WS_EX_TOPMOST 0x00000008)
        return false
    }
    szClass := WinGetClass("ahk_id " hWnd)    ; this is an exception for TApplication Classes
    if (szClass = "TApplication") {
        return false
    }
    return true
}

;; Cloaked windows exception
IsWindowCloaked(hwnd) {
    return DllCall("dwmapi\DwmGetWindowAttribute", "ptr", hwnd, "int", 14, "int*", &cloaked, "int", 4) >= 0
        && cloaked
}
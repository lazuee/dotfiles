#Requires AutoHotkey v2.0.2
#SingleInstance Force

Persistent(true)

#Include common.ahk

myGui := Gui()
myGui.Opt("+LastFound")
hWnd := WinExist()

DllCall("RegisterShellHookWindow", "UInt", hWnd)
MsgNum := DllCall("RegisterWindowMessage", "Str", "SHELLHOOK")
OnMessage(MsgNum, ShellMessage)

ShellMessage(wParam, lParam, *) {
    if (wParam = 6 or wParam = 32772 or wParam = 2 or wParam = 16)
        return

    MinWindowed()
}

MinWindowed()

MinWindowed(limit := 3) {
    ids := ListWindows()

    Loop ids.Length
    {
        this_ID := ids[A_Index]
        if (A_Index > limit) {
            title := WinGetTitle("ahk_id " this_ID)
            writeLog("[MinWindowed] #" A_Index " Window: " title)
            WinMinimize("ahk_id " this_ID)
        }

        continue
    }
}
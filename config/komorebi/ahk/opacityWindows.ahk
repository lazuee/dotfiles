#Requires AutoHotkey v2.0.2
#SingleInstance Force

Persistent(true)

#Include common.ahk


; Increase Opacity, Alt + Win + WheelUp
!#WheelUp::
{
    OpacityWindows("up")
}

; Decrease Opacity, Alt + Win + WheelDown
!#WheelDown::
{
    OpacityWindows("down")
}

OpacityWindows(mode := "none") {
    DetectHiddenWindows(true)
    if (!WinExist("A"))
        return

    curtrans := WinGetTransparent("A")
    if !curtrans
        curtrans := "255"

    if (mode == "up") {
        newtrans := curtrans + 8
    }
    else if (mode == "down")
    {
        newtrans := curtrans - 8
    }


    if (mode == "info") {
        MouseGetPos(, , &MouseWin)
        Transparent := WinGetTransparent("ahk_id " MouseWin)
        ToolTip("Translucency: " Transparent "`n")
        Sleep(2000)
        ToolTip()
    } else {
        ids := ListWindows()

        Loop ids.Length
        {
            this_ID := ids[A_Index]
            if (mode == "reset") {
                WinSetTransparent(255, "ahk_id " this_ID)
                WinSetTransparent("OFF", "ahk_id " this_ID)
            } else {
                if (newtrans > 0 and newtrans < 255)
                {
                    WinSetTransparent(newtrans, "ahk_id " this_ID)
                }
                else
                {
                    WinSetTransparent("OFF", "ahk_id " this_ID)
                    WinSetTransparent(255, "ahk_id " this_ID)
                }
            }
        }
    }

    return
}
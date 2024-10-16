#Requires AutoHotkey v2.0
#SingleInstance Force

/*
Mouse-TitleBar-Hider powered by https://www.autohotkey.com
Oficial Web: https://www.github.com/JLCareglio/Mouse-TitleBar-Hider

Shortcuts at Window:
    Super/Win + Mouse Left ==========> Hide/Show TitleBar.
    Super/Win + Mouse Left + Drag ===> Move.
    Super/Win + Mouse Right =========> Toggle Always On Top.
    Super/Win + Mouse Right + Drag ==> Resize.
    Super/Win + Mouse Middle ========> Minimize.
    Super/Win + Mouse Middle + Drag => Toggle Maximize.
*/

CoordMode("Mouse")
SendMode("Input")
SetWinDelay(2)
SetWorkingDir(A_ScriptDir)

A_TrayMenu.Delete()
A_TrayMenu.Add("Ayuda", Help)
A_TrayMenu.Add("Salir", Quit)
Help(*) => Run("https://www.github.com/JLCareglio/Mouse-TitleBar-Hider")
Quit(*) => ExitApp()

LWin & LButton:: {
    MouseGetPos(&mouseX1, &mouseY1, &winId)
    classWin := WinGetClass("ahk_id " winId)

    if classWin == "WorkerW"
        return

    WinGetPos(&winX1, &winY1, , , "ahk_id " winId)
    moving := false

    while GetKeyState("LButton", "P") {
        MouseGetPos(&mouseX2, &mouseY2)

        if (mouseX2 != mouseX1 || mouseY2 != mouseY1) {
            moving := true
            offsetX := winX1 + (mouseX2 - mouseX1)
            offsetY := winY1 + (mouseY2 - mouseY1)
            WinMove(offsetX, offsetY, , , "ahk_id " winId)
        }
    }

    if !moving {
        WinActivate("ahk_id " winId)
        titlebarVisible := WinGetStyle("ahk_id " winId) & 0xC00000

        if titlebarVisible
            WinSetStyle("-0xC00000", "ahk_id " winId)
        else
            WinSetStyle("+0xC00000", "ahk_id " winId)
    }
}

LWin & RButton:: {
    MouseGetPos(&mouseX1, &mouseY1, &winId)
    classWin := WinGetClass("ahk_id " winId)

    if (classWin == "WorkerW" || WinGetMinMax("ahk_id " winId))
        return

    WinGetPos(&winX1, &winY1, &winWidth, &winHeight, "ahk_id " winId)
    xAxis := (mouseX1 < winX1 + winWidth / 2) ? 1 : -1
    yAxis := (mouseY1 < winY1 + winHeight / 2) ? 1 : -1
    moving := false

    while GetKeyState("RButton", "P") {
        MouseGetPos(&mouseX2, &mouseY2)

        if (mouseX2 != mouseX1 || mouseY2 != mouseY1) {
            moving := true
            WinGetPos(&winX1, &winY1, &winWidth, &winHeight, "ahk_id " winId)
            offsetX := winX1 + (xAxis + 1) / 2 * (mouseX2 - mouseX1)
            offsetY := winY1 + (yAxis + 1) / 2 * (mouseY2 - mouseY1)
            newWidth := winWidth - xAxis * (mouseX2 - mouseX1)
            newHeight := winHeight - yAxis * (mouseY2 - mouseY1)
            WinMove(offsetX, offsetY, newWidth, newHeight, "ahk_id " winId)
            mouseX1 := mouseX2
            mouseY1 := mouseY2
        }
    }

    if !moving {
        WinActivate("ahk_id " winId)
        WinSetAlwaysOnTop(-1, "ahk_id " winId)
    }
}

LWin & MButton:: {
    MouseGetPos(&mouseX1, &mouseY1, &winId)
    classWin := WinGetClass("ahk_id " winId)

    if classWin == "WorkerW"
        return

    WinGetPos(&winX1, &winY1, , , "ahk_id " winId)
    moving := false

    while GetKeyState("MButton", "P") {
        MouseGetPos(&mouseX2, &mouseY2)

        if (mouseX2 != mouseX1 || mouseY2 != mouseY1) {
            moving := true

            if WinGetMinMax("ahk_id " winId)
                WinRestore("ahk_id " winId)
            else
                WinMaximize("ahk_id " winId)

            break
        }
    }

    if !moving {
        WinActivate("ahk_id " winId)
        WinMinimize("ahk_id " winId)
    }
}
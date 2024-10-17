CoordMode("Mouse")
SendMode("Input")
SetWinDelay(2)
SetWorkingDir(A_ScriptDir)

#HotIf config.isMButtonActive.value
MButton:: MoveOrHideTileBar("MButton")
#HotIf config.isXButton1Active.value
XButton1:: MoveOrHideTileBar("XButton1")
#HotIf config.isXButton2Active.value
XButton2:: MoveOrHideTileBar("XButton2")
#HotIf config.isWinActive.value
#LButton:: MoveOrHideTileBar("LButton")

MoveOrHideTileBar(waitKeyUpState) {
    MouseGetPos(&mouseX1, &mouseY1, &winId)
    classWin := WinGetClass("ahk_id " winId)

    WinGetPos(&winX1, &winY1, &winWidth, &winHeight, "ahk_id " winId)
    moving := false

    screenWidth := SysGet(78)
    screenHeight := SysGet(79)
    isFullscreen := (winWidth = screenWidth && winHeight = screenHeight)

    if (classWin == "WorkerW" || classWin == "Shell_TrayWnd" || isFullscreen)
        return


    while GetKeyState(waitKeyUpState, "P") {
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
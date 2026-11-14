#Requires AutoHotkey v2.0

#Include lib\gui.ahk
#Include lib\mainfunctions.ahk
#Include lib\placeUnits.ahk
#Include lib\navigation.ahk
#Include lib\Gdip_All.ahk
#Include lib\patterns.ahk

CoordMode("Mouse", "Client")
RobloxWindow := "ahk_exe RobloxPlayerBeta.exe"
Esc::ExitApp  ; Exit script with Escape key
global isScriptRunning := False

;ShowGUI()
if WinExist(RobloxWindow) {
    WinActivate(RobloxWindow)
    Sleep(50)
    WinMove(0, 0, 800, 600, RobloxWindow)
    MoveGui()
} else {
    MsgBox("Roblox window not found. Please start the game and try again.")
    ExitApp
}
#MaxThreadsPerHotkey 2
F9:: {
    global isScriptRunning
    ; If the macro is not running yet, start it
    if (!isScriptRunning) {
        isScriptRunning := True
        ToolTip("Macro Started")
        SetTimer(() => ToolTip(), -1000)
        startGameplay()
    }
    ; If already running, toggle Pause / Resume
    else {
        Pause(-1) ; Toggle pause state
        if (A_IsPaused) {
            ToolTip("Macro Paused")
        } else {
            ToolTip("Macro Resumed")
            SetTimer(() => ToolTip(), -1000)
        }
    }
}

F8::{
    ToolTip("Resetting Macro...")
    Sleep(500)
    Reload()
}

F7::{
    upgUnits()
runFinished()
}

F6::{
    runFinished()
}

F5::{
    Send("{s down}")
    Sleep(500)
    Send("{s up}")
    Sleep(200)
    Send("{d down}")
    Sleep(2300)
    Send("{d up}")
}

F4::{
    try {
        text := OCR(237, 290, 341, 49)
        text := RegExReplace(String(text), "[^0-9]")

        ToolTip("Detected text:`n`n" text, 100, 100)

        BetterClick(399, 341)
        Sleep(500)

        TypeNumberCaptcha(text)
    } catch Error as err {
        ToolTip("OCR error:`n" err.Message, 100, 100)
    }
}
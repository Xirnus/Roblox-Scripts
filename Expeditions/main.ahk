#Requires AutoHotkey v2.0

#Include lib\gui.ahk
#Include lib\navigation.ahk
#Include lib\placeUnits.ahk
#Include lib\webhook.ahk

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
        StartGameplay()
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
    placeid :=84515722934860
    JoinRobloxPlace(placeId) {
    ; Launches the Roblox client and joins the specified Place ID directly
    Run("https://www.roblox.com/games/start?placeId=" . placeId)
}

JoinRobloxPlace(placeid)
}
F6::{
    global wheeldownCount := 15
    LookDown()
}

F1::{ 
IngameCheck()
}
#Requires AutoHotkey v2.0

#Include lib\gui.ahk
#Include lib\navigation.ahk

CoordMode("Mouse", "Client")
RobloxWindow := "ahk_exe RobloxPlayerBeta.exe"
Esc::ExitApp  ; Exit script with Escape key

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
F9:: {
    StartGameplay()
}

F7::{
    stages := [
        ["SchoolGrounds", SchoolGrounds],
        ["FlowerForest", FlowerForest],
        ["RoseKingdom", RoseKingdom],
        ["FairyKingForest", FairyKingForest],
        ["KingsTomb", KingsTomb]
    ]
    for stage in stages {
        name := stage[1]
        pattern := stage[2]
        if (FindText(&X, &Y, 0, 0, 816, 638, 0, 0, pattern)) {
            ToolTip(name . " Found")
            Sleep(1000)
        }
        else {
            ToolTip(name . " Not Found")
            Sleep(1000)
        }
    }
}

F8::{
    wheeldownCount := 15
    LookDown() {
        centerX := 408
        centerY := 319

        BetterClick(centerX, centerY)
        loop 40 {
            SendInput("{WheelUp}")
            Sleep 50
        }
        Sleep 1000
        SendInput(Format("{Click {} {} Left}", centerX, centerY + 200))
        Sleep 1000
        loop wheeldownCount {
            SendInput("{WheelDown}")
            Sleep 50
        }
    }
    LookDown()
}
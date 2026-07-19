#Requires AutoHotkey v2.0

#Include lib\gui.ahk
#Include lib\navigation.ahk

CoordMode("Mouse", "Screen")
RobloxWindow := "ahk_exe RobloxPlayerBeta.exe"
Esc::ExitApp  ; Exit script with Escape key

;ShowGUI()
if WinExist(RobloxWindow) {
    WinActivate(RobloxWindow)
    Sleep(50)
    WinMove(0, 0, 816, 638, RobloxWindow)
    MoveGui()
} else {
    MsgBox("Roblox window not found. Please start the game and try again.")
    ExitApp
}
F9:: {
    StartGameplay()
}

F8::{

}
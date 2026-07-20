#Requires AutoHotkey v2.0

#Include lib\gui.ahk
#Include lib\navigation.ahk
#Include lib\placeUnits.ahk

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
Send("{s down}{d down}")
Sleep(3000)
Send("{s up}{d up}")
}
F6::{
    global wheeldownCount := 15
    LookDown()
}
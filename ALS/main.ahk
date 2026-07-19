#Requires AutoHotkey v2.0

#Include lib\placeUnits.ahk
#Include lib\gui.ahk

CoordMode("Mouse", "Screen")
RobloxWindow := "ahk_exe RobloxPlayerBeta.exe"
Esc::ExitApp  ; Exit script with Escape key

ShowGUI()

F9:: {
    if WinExist(RobloxWindow) {
        WinActivate(RobloxWindow)
        Sleep(50)
        WinMove(0, 0, 800, 600, RobloxWindow)
        StartGameplay()  ; Start the selected mode

    }
}

F8::{
    if WinExist(RobloxWindow) {
        WinActivate(RobloxWindow)
	WinMove(0, 0, 800, 600, RobloxWindow)
	}
}
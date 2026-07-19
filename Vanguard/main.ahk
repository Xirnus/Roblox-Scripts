#Requires AutoHotkey v2.0

#Include lib\gui.ahk
#Include lib\FindText.ahk
#Include lib\functions.ahk
#Include lib\fixpos.ahk
#Include lib\placeUnits.ahk

CoordMode("Mouse", "Screen")
RobloxWindow := "ahk_exe RobloxPlayerBeta.exe"

Esc::ExitApp  ; Exit script with Escape key


showGUI()
F9:: {
    if WinExist(RobloxWindow) {
        WinActivate(RobloxWindow)
        Sleep 50
        WinMove(0, 0, 800, 600, RobloxWindow)
        Sleep 50
        lobby()
        story()
    }
}

F8:: {
    if WinExist(RobloxWindow) {
        CoordMode("Mouse", "Screen")
        WinActivate(RobloxWindow)
        Sleep 50
        WinMove(0, 0, 800, 600, RobloxWindow)
        Sleep 50
        ; fixCamera()
        PlaceUnits("6", "speed")
        PlaceUnits("5", "taka")
        upgradeUnit("6", "speed", "2")
        upgradeUnit("5", "taka", "2")
    }
}

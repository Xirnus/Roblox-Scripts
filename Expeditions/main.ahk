#Requires AutoHotkey v2.0

#Include lib\gui.ahk
#Include lib\navigation.ahk
#Include lib\placeUnits.ahk
#Include lib\webhook.ahk

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

F8::{
ChalStoryGameplay() 
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

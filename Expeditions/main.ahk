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
Send("{w down}")
Sleep(3000)
Send("{w up}")
}
F8::{
SpiritCity:="|<SpiritCity>*89$39.01nU3U3sGbDb0VzSh2jwsE0nU9l84CQ9LV0Zn5WV24Z0Yntzzbz41s000BU60000kU"

if (ok:=FindText(&X, &Y, 0, 0, 800, 599, 0, 0, SpiritCity))
{
  FindText().Click(X, Y, "L")
}
}

F6::{
    global wheeldownCount := 15
    LookDown()
}
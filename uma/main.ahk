#Requires AutoHotkey v2.0

#Include lib\gui.ahk
#Include lib\FindText.ahk
#Include lib\idk.ahk
CoordMode("Mouse", "Screen")
GameWindow := "ahk_exe UmamusumePrettyDerby.exe"

Esc::ExitApp  ; Exit script with Escape key
showGUI()

F9:: {
    if WinExist(GameWindow) {
        WinActivate(GameWindow)
        DeleteAccount() 
        CreateAccount()
        GetGifts()
    }
}

F8::{
    Send("Xsrn")
}
#Requires AutoHotkey v2.0

#Include navigation.ahk
#Include placeUnits.ahk

global wins := 0
global losses := 0
global games := 0
global StatsText

if !IsSet(MyGui) {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.Title := "Anime Adventures Macro"
    MyGui.SetFont("s10", "Segoe UI")

    MyGui.Add("Text", "x15 y20 w320 vWinText Center", "F9: Start / Pause / Resume | F8: Reload | ESC: Stop")
    MyGui.Add("Text", "x15 y40 w320 vControlsText Center", "F9: Event | F7: Shibuya Inf | F6: Portal")


    ; Sleep Input (Positioned right below Game Mode selection)
    StatsText := MyGui.Add("Text", "x15 y+200 w200", "Wins: 0 | Loss: 0 | Games: 0")

}

UpdateStats() {
    global wins, losses, games, StatsText
    StatsText.Text := "Wins: " wins " | Loss: " losses " | Games: " games
}

MoveGui(){
    global MyGui, RobloxWindow

    if WinExist(RobloxWindow) {
        WinGetPos(&x, &y, &w, &h, RobloxWindow)
        MyGui.Show("x" (x + w - 10) " y" y " w350 h275")
    } else {
        MyGui.Show("w350 h275")
    }
}

startGameplay(){
    while True{
        goToEvent()
        if findMatch() {
            continue  ; restarts loop, calling goToEvent() again
        }
        unitPlacements()
        upgUnits()
        runFinished()
    }
}
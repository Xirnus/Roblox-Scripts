#Requires AutoHotkey v2.0

#Include navigation.ahk

if !IsSet(MyGui) {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.Title := "Omsim Macro"
    MyGui.SetFont("s10", "Segoe UI")

    ; --- LEFT COLUMN ---
    MyGui.Add("Text", "x15 y15 w150 Center", "Select Game Mode:")
    modeDDL := MyGui.Add("DropDownList", "x15 y+5 w150 vMode Choose1", ["Story", "Raid", "Challenge", "Expedition", "Event Stages"])

    ; Sleep Input (Positioned right below Game Mode selection)
    MyGui.Add("Text", "x15 y+20 w75", "Sleep (ms):")
    MyGui.Add("Edit", "x+2 yp-3 w73 vSleepMs", "1000")
    
    ; Helper text
    MyGui.SetFont("s8 cGray")
    MyGui.Add("Text", "x15 y+2 w150", "1sec = 1000")
    MyGui.SetFont("s10 cDefault")

    ; --- BOTTOM SECTION ---
    MyGui.Add("Text", "x15 y200 w320 vWinText Center", "F9: Start / Pause / Resume | F8: Reload | ESC: Stop")
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
        findMatch()
        unitPlacements()
        upgUnits()
        runFinished()
    }
}
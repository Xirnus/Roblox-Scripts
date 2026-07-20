#Requires AutoHotkey v2.0

#Include navigation.ahk


if !IsSet(MyGui) {
    MyGui := Gui("+AlwaysOnTop")  ; Keeps GUI above game window
    MyGui.Title := "Omsim Macro"
    MyGui.SetFont("s10", "Segoe UI")

    MyGui.Add("Text", "w150 Center", "Select Game Mode:")
    MyGui.Add("DropDownList", "w150 vMode Choose1", ["Gem Farm", "Story", "Raid", "Challenge", "Expedition"])
    MyGui.Add("Text", "w200 Center", "Challenge Only: (Auto Start OFF)")

    MyGui.Add("Text", "y+10 w150 Center", "Select Expedition Map:")
    MyGui.Add("DropDownList", "w150 vExpeditionMap Choose1", ["School Grounds", "Flower Forest", "Rose Kingdom"])

    ; Sleep input inline with Mode selector
    MyGui.Add("Text", "y+10 w150", "Sleep (ms):")
    MyGui.Add("Edit", "w80 vSleepMs", "1000") ; example/shadow value inside box
    MyGui.Add("Text", "w80", "1sec = 1000")

    ; Win/Loss counters side-by-side
    MyGui.Add("Text", "vWinText x20 y+20 w120", "F9: Start | ESC: Stop")

}

MoveGui(){
    global MyGui, RobloxWindow

    if WinExist(RobloxWindow) {
        WinGetPos(&x, &y, &w, &h, RobloxWindow)
        ; Show GUI to the right of Roblox window
        MyGui.Show("x" (x + w + -10) " y" y " w300 h300")
    } else {
        MyGui.Show("w300 h150")
    }
}

ShowGUI() {
    MyGui.Show("w400 h400")
}

StartGameplay(){
    selectedMode := MyGui["Mode"].Text

    Switch selectedMode {
        Case "Gem Farm":
            ;while (true) {
                GemFarmGameplay()
                Sleep(500)
            ;}
        Case "Story":
            while (true) {
                ;StoryGameplay()
                Sleep(5000)
            }
        Case "Raid":
            while (true) {
                ;RaidGameplay()
                Sleep(5000)
            }
        Case "Challenge":
            while (true) {
                ChallengeGameplay()
                Sleep(5000)
            }
        Case "Expedition":
            ;while (true) {
                ExpeditionGameplay()
                Sleep(5000)
            ;}
    }
}
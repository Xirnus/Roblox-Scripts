#Requires AutoHotkey v2.0
#Include placeUnits.ahk


if !IsSet(MyGui) {
    MyGui := Gui("+AlwaysOnTop")  ; Keeps GUI above game window
    MyGui.Title := "Yippie Macro"
    MyGui.SetFont("s10", "Segoe UI")

    MyGui.Add("Text", "w300 Center", "Select Game Mode:")
    MyGui.Add("DropDownList", "w300 vMode Choose1", ["RR", "Cavern", "Boost", "InfernalDungeon", "LegendBeni", "SJWDungeon", "BossRush", "OPMSurvival", "EasterEvent", "BlackCloverLegend"])

    ; Win/Loss counters side-by-side
    MyGui.Add("Text", "vWinText x20 y+20 w120", "Wins: 0")
    MyGui.Add("Text", "vLoseText x160 yp w120", "Losses: 0")
}



UpdateWinLossText() {
    myGui["WinText"].Text := "Wins: " WinCount
    myGui["LoseText"].Text := "Losses: " LoseCount
}


MoveGui(){
    global MyGui, RobloxWindow

    if WinExist(RobloxWindow) {
        WinGetPos(&x, &y, &w, &h, RobloxWindow)
        ; Show GUI to the right of Roblox window
        MyGui.Show("x" (x + w + 10) " y" y " w300 h150")
    } else {
        MyGui.Show("w300 h150")
    }
}

ShowGUI() {
    MyGui.Show("w400 h400")
}

StartGameplay() {
    selectedMode := MyGui["Mode"].Text

    Switch selectedMode {
        Case "RR":
	    LookDown()
   	    sleep 400
   	    VoteStart()
	    while (true){
            	RRGameplay()
	}
        Case "Cavern":
            while (true) {
                CavernGameplay()
                Sleep(5000)
            }
        Case "Boost":
            while (true) {
                BoostGameplay()
                Sleep(30000)
            }
        Case "InfernalDungeon":
            while (true) {
                if (!InfernalDungeonGameplay()){
		continue
		}
                Sleep(10000)
            }
        Case "SJWDungeon":
            while (true) {
                SJWDungeonGameplay()
                Sleep(20000)
            }
	Case "LegendBeni":

            LookDown()
   	    sleep 400
   	    VoteStart()
	    while (true) {
		LegendBeni()
		sleep(5000)
	    }
	Case "BossRush":
	   while (true) {
	   	BossRushGameplay()
		sleep(15000)
	}
	Case "OPMSurvival":

	    LookDown()
    	    sleep 400
    	    VoteStart()
	   while (true) {
		OPMSurvivalGameplay()
		sleep 15000
	}

    Case "EasterEvent":
        while (true) {
            lobby()
            if (!EasterEventGameplay()) {
                continue  ; Game reset early — restart from lobby
            }
            Sleep 10000
        }

	Case "BlackCloverLegend":
	while (true){
		BlackCloverLegendGameplay()
		Sleep 5000
	}
}
}
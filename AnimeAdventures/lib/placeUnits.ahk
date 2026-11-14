#Requires AutoHotkey v2.0

#Include mainfunctions.ahk
#Include gui.ahk

units := [
    ["1", "1", "Unit1"],
    ["2", "3", "Unit2"],
    ["3", "3", "Unit3"],
    ["4", "1", "Unit4"],
    ["5", "1", "Unit5"],
    ["6", "1", "Unit6"]
]

unitPlacements(){
    ToolTip("Finding Vote Start")
    while !checkImage(voteStart){
        Sleep(500)
    }
    if (checkImage(voteStart)){
        BetterClick(358, 107)
        Sleep(50000)
        ToolTip("InGame", 100, 100)
        Sleep(300)
        ToolTip("")
        LookDown()
        Sleep(300)
        startingx := 40
        startingy := 480
        tries := 0
        for unit in units{
            unitHotkey := unit[1]
            unitNumberPlacements :=unit[2]
            unitNumber := unit[3]
            loop unitNumberPlacements{
                while true{
                    Send(unitHotkey)
                    Sleep(300)
		    ToolTip("Tries " . tries)
                    if (startingx >= 800  || startingy >= 600){
                        startingx := 40
                        startingy -= 70
                    }if (tries >= 50){
                        break
                    }else{
                        BetterClick(startingx, startingy)
                        tries += 1
                        Sleep(1000)
                        if (unitPlaceCheck()){
                            startingx += 50
                            ToolTip("Unit placed", 100, 100)
                            break
                        }
                        startingx += 50
                        Sleep(100)
                    }
                }
            }
        }
    }
}

unitPlaceCheck(){
    if (FindText(&X, &Y, 230, 253, 291, 297, 0, 0, unitplaced)) {
        return true
    }
    return false
}

upgUnits(){
    startx := 630
    starty := 130
    if (checkImage(upgMenu)){
        Send("f")
        Sleep(500)
    While true{
        if (startx >= 800){
            starty += 87
            startx := 630
        }
        if (starty >= 600){
            startx := 630
            starty := 130
        }
        if (startx < 800 && starty < 600){
            BetterClick(startx, starty)
            Sleep(200)
            startx += 130
        }
        BetterClick(100,100)
        Sleep(100)
        if (FindText(&X, &Y, 437, 184, 501, 249, 0, 0, victory)){
            ToolTip("Victory Screen Found")
            wins += 1
            games += 1
            UpdateStats()
            break
        }
        if (FindText(&X, &Y, 319, 173, 513, 257, 0, 0, defeat)){
            ToolTip("Defeat Screen Found")
                losses += 1
                games += 1
                UpdateStats()
                break
            }
        }
    }
}

runFinished(){
    Sleep(300)
    BetterClick(320, 400)
	Sleep(300)
    Loop 5{
        BetterClick(100, 100)
    Sleep(300)
    }
    Sleep(300)
    BetterClick(310, 122)
}
#Requires AutoHotkey v2.0

#Include mainfunctions.ahk

units := [
    ["1", "1", "Unit1"],
    ["2", "3", "Unit2"],
    ["3", "3", "Unit3"],
    ["4", "1", "Unit4"],
    ["5", "1", "Unit5"],
    ["6", "1", "Unit6"]
]

unitPlacements(){
    while (!checkImage(voteStart)){
        ToolTip("Finding Vote Start")
        if (checkImage(voteStart)){
            Sleep(55000)
            ToolTip("InGame", 100, 100)
            Sleep(300)
            BetterClick(358, 107)
            Sleep(300)
            ToolTip("")
            LookDown()
            Sleep(300)
            startingx := 40
            startingy := 480
            for unit in units{
                unitHotkey := unit[1]
                unitNumberPlacements :=unit[2]
                unitNumber := unit[3]
                loop unitNumberPlacements{
                    while true{
                        Send(unitHotkey)
                        Sleep(300)
                        if (startingx >= 800  || startingy >= 600){
                            startingx := 40
                            startingy -= 70
                        }else{
                            BetterClick(startingx, startingy)
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
            break
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
        if (checkImage(victory)){
            break
        }else{
            ToolTip("No Upg Button Found")
            SetTimer(() => ToolTip(), -1000)
            }
        }
    }
}

runFinished(){
    if (checkImage(victory)){
        Sleep(300)
        BetterClick(320, 400)
        Loop 5{
            BetterClick(100, 100)
        }
        Sleep(300)
        BetterClick(315, 320)
    }
}
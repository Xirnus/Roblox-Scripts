#Include functions.ahk
#Include placeUnits.ahk

rightposition := [
    [[121, 376], [266, 297], [455, 220], [608, 156], [425, 86], [293, 78]], ;Namek
   ;[[106, 456], [173, 314], [233, 172], [126, 119], [443, 84], [545, 210], [606, 362], [692, 495]], ;Shibuya station
]

namekRightPosition:="|<NamekRightSpot>*90$71.000000001U00000000003U0000000000770000000000DTk600000000DTUA00000000QzUM00000000NzUk00000000PzU000000000HzU0002000007zk0000Dzzw07zU000zzzzzzzz0003zzzzzzzyE00/zzzzzzzwk00nzzbzzzzs003nzzjzzzzk00Dzzzzzzzzk00zzzzzzzzzk03zzzzzzzzzU0Dzzzzzzzzz00zznzzzzzzy03zz3zzzzzzkFzzzzzzzzzzVzzzzzzzzzzz7zzzzzzzzzzz"

SearchDelay := 1000


fixCamera() {
    global upg0, namekRightPosition
    
    VoteStart()
    Sleep 1000
    LookDown()
    Sleep 1000
    
    while (!FindText(&X, &Y, 568, 434, 792, 573, 0, 0, namekRightPosition)) {
        ; Keep trying to place taka until upg0 is found
        while (!FindText(&X, &Y, 8, 31, 809, 627, 0, 0, upg0)) {
            if (placeTaka()) {
                ; If all placements failed, try recovery
                ClickSpectate()
                Sleep 1000
                
                if (FindText(&X, &Y, 568, 434, 792, 573, 0, 0, namekRightPosition)) {
                    restartGame()
                    break 2  ; Break both loops if we found the right position
                }
                
                tpToSpawn()
                Sleep 1000
            }
        }
        
        ; After upg0 is found, check camera position
        if (FindText(&X, &Y, 568, 434, 792, 573, 0, 0, namekRightPosition)) {
            break
        }
    }
}

innitialPlace :=[
    [285, 369], 
    [234, 177], 
    [545, 118],
    [190, 258], 
    [367, 255], 
    [520, 248]
]

placeTaka() {
    global initialPlace
    
    SendInput("q")
    Sleep 100
    
    ; Loop through all positions
    for i, pos in innitialPlace {
        PlaceUnit(pos[1], pos[2], 6)  ; Assuming PlaceUnit takes x, y, and unit type
        Sleep 500
        
        ; Check if upg0 is found after placement
        if FindText(&X, &Y, 8, 31, 809, 627, 0, 0, upg0) {
            return true  ; Exit if successful
        }
    }
    
    return false  ; Return false if none of the placements worked
}
    
UnitManager := [
    [489, 166],
    [553, 166],
    [615, 166],
    [679, 166],
    [737, 166]
]

VoteStart() {
    BetterClick(375, 155)
}

LookDown() {
    BetterClick(700, 299)
    loop 40 {
        SendInput("{WheelUp}")
        Sleep 50
    }
    Sleep 1000
    MouseGetPos(&x, &y)
    SendInput(Format("{Click {} {} Left}", x, y + 150))
    Sleep 1000

    loop 40 {
        SendInput("{WheelDown}")
        Sleep 50
    }
}

tpToSpawn() {
    SendInput("q")
    Sleep 100
    BetterClick(25, 615) ; Click settings
    Sleep 400
    BetterClick(520, 240) ; Click tp to spawn
    Sleep 400
    BetterClick(578, 154) ; Close setting
    Sleep 400
}

restartGame() {
    SendInput("q")
    Sleep 100
    BetterClick(25, 615) ; Click settings
    Sleep 400
    BetterClick(522, 313) ; Click restart game
    Sleep 400
    BetterClick(350, 345) ; Close yes
    Sleep 400
    BetterClick(408, 334) ; Close cancel
    Sleep 400
    BetterClick(375, 155) ; Click Vote
}


PlaceUnit(x, y, slot) {
    Send("q")
    Sleep 100
    Send(slot)
    Sleep (SearchDelay / 2)
    clickmethod("Left", x, y)
}

ClickMethod(button, x, y, clickDelay := 0) {
    MouseMove(x, y)
    MouseMove(1, 0, , "R")
    MouseClick("Left", -1, 0, , , , "R")
}


ClickSpectate(){
    BetterClick(235, 440) ; Click Spectate
    Sleep 500
    BetterClick(330, 540) ; Click top side view
    sleep 1000
    Send("x")
    ; BetterClick(400, 610) ; Click Leave Button
    Sleep 500
}



FixPos(){
    VoteStart()
    Sleep 1000
    LookDown()
    Sleep 1000
    tpToSpawn()
    Sleep 1000
    fixCamera()

}

openCamera2() {
    nullClick()
    Sleep 300
    SendInput("q")
    Sleep 300
    SendInput("f")
    Sleep 500
    Loop 5{ 
        if (FindText(&Xe, &Ye, 340, 395, 470, 499, 0, 0, spectateButton)){
            break
        }
        BetterClick(UnitManager[A_Index][1], UnitManager[A_Index][2])
        Send("x")
        Sleep 500
    }
    SendInput("f")
    Sleep 500
}

nullClick() {
    SendInput("q")
    BetterClick(xNull, yNull)
}

xNull := 738
yNull := 425
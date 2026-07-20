#Include FindText.ahk


Start:="|<VoteStart>*98$43.8LzGDzC4l06S1NX003000FGUPY00MV8Ack14Dzvnzzw0000000E"

; Common functions
BetterClick(x, y) {
    MouseMove(x, y)
    MouseMove(1, 0, , "R")
    Sleep(100)
    MouseClick("Left", -1, 0, , , , "R")
    Sleep(50)
}

IngameCheck() {
    if (FindText(&X, &Y, 0, 0, 809, 627, 0, 0, ingame)) {
        return true
    }
    return false
}

LookDown() {
    centerX := 408
    centerY := 319

    BetterClick(centerX, centerY)
    loop 40 {
        SendInput("{WheelUp}")
        Sleep 50
    }
    Sleep 1000
    SendInput(Format("{Click {} {} Left}", centerX, centerY + 200))
    Sleep 1000
    loop wheeldownCount {
        SendInput("{WheelDown}")
        Sleep 50
    }
}

FindLobby() {
    if (FindText(&X, &Y, 0, 0, 809, 627, 0, 0, Lobby)) {
        ToolTip("Lobby Found")
        return true
    }
    return false
}

VoteStart(){
    BetterClick(406, 180)
}

FailedRun(){
    if FindText(&X, &Y, 0, 0, 809, 627, 0, 0, Start) {
        ToolTip("Failed Run")
        return true
    }
}
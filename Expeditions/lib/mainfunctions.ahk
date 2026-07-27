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

BetterClickFindText(x, y) {
        WinGetClientPos(&clientX, &clientY, , , RobloxWindow)
        
        targetX := X - clientX
        targetY := Y - clientY

        BetterClick(targetX, targetY)
}

IngameCheck() {
    if (FindText(&X, &Y, 0, 0, 809, 627, 0, 0, ingame)) {
        return true
    }
    return false
}

LookDown() {
    ; Get the width and height of the currently active window's client area
    WinGetClientPos(,, &clientWidth, &clientHeight, "A")
    
    ; Calculate the center coordinates dynamically
    centerX := clientWidth // 2
    centerY := clientHeight // 2

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
        return true
    }
}

LobbySetUp(){
    Loop 5{
        if FindLobby() {
            ClickPlay()
            return true
        } if (A_Index = 5) {
            ToolTip("Lobby Not Found, Stopping Script")
            Sleep(5000)
            ToolTip("")
            ExitApp
        }
        Sleep(3000)
        ToolTip("Lobby Not Found, Retrying... (" A_Index "/5)")
    }
}

EnterGameMode() {
    confirmStage := [
        ["selectbtn", SelectStage], 
        ["startbtn", StartButton]
    ]
    Loop 2{
        for stage in confirmStage {
            name := stage[1]
            pattern := stage[2]
                if FindText(&X, &Y, 0, 0, 800, 599, 0, 0, pattern) {
                    BetterClickFindText(x, y)
                } else {
                    ToolTip(name . " Not Found")
                    Sleep(1000)
                }
                Sleep(1000)
            }
            ToolTip("")
    }
    ToolTip("Entered Game Mode")
    Sleep(2000)
    ToolTip("")
    return true
}

ClickPlay(){
    WinActivate(RobloxWindow)
    CoordMode("Mouse", "Client")
    Sleep(Integer(MyGui["SleepMs"].Value))
    BetterClick(70, 372) ;play btn
    Sleep(Integer(MyGui["SleepMs"].Value))
}

StageSetUp(){
    global wheeldownCount := 15
    while True {
        if IngameCheck(){
            Sleep(Integer(MyGui["SleepMs"].Value))
            break
        }
    }
    ToolTip("Waiting 5 seconds for map to load...")
    Sleep(5000)
    ToolTip("")
    LookDown()
}

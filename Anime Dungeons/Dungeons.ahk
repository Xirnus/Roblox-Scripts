#Requires AutoHotkey v2.0
Esc::ExitApp  ; Exit script with Escape key
; Run a program on Middle Click
global isScriptRunning := False
#MaxThreadsPerHotkey 2
CoordMode("Mouse", "Screen")
spellIndex := 1
v::Send("^v")

.:: {
    global isScriptRunning
    if (!isScriptRunning) {
        isScriptRunning := True
        ToolTip("Macro Started")
        SetTimer(() => ToolTip(), -1000)
        SetTimer(SpellLoop, 1000) ; Start the spell loop every 1 second
    }
    ; If already running, toggle Pause / Resume
    else {
        Pause(-1) ; Toggle pause state
        if (A_IsPaused) {
            ToolTip("Macro Paused")
        } else {
            ToolTip("Macro Resumed")
            SetTimer(() => ToolTip(), -1000)
        }
    }
}

,::{
SpawnBoss()
}

BuffLoop() {
    Send("{1}")
    Sleep(500)
    Send("{2}")
    Sleep(500)
    Send("{3}")
}

SpellLoop() {
    global spellIndex

    switch spellIndex {
        case 1:Send("{Q}")
        Sleep(500)
        case 2:Send("{XButton1}")
        Sleep(500)
        case 3:Send("{XButton2}")
        Sleep(500)
        case 4:Send("{E}")
        Sleep(500)
    }

    if (spellIndex >= 4){
        spellIndex := 1
    } else{
        spellIndex := spellIndex + 1
    }
    ;Send("{R}")
    ;Sleep(630)
    ;Send("{1}")
    ;Send(550)
    ;Send("{2}")
}

SpawnBoss() {
    Send("{b}")
    Sleep(350)
    BetterClick(1056, 124)
    Sleep(350)
    BetterClick(1192, 285)
    Sleep(100)
    BetterClick(1192, 275)
    Sleep(200) 
    MouseMove(960, 534)
}

BetterClick(x, y) {
    MouseMove(x, y)
    MouseMove(1, 0, , "R")
    Sleep(100)
    MouseClick("Left", -1, 0, , , , "R")
    Sleep(50)
}

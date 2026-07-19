#Requires AutoHotkey v2.0

#Include lib\FindText.ahk
#Include lib\gui.ahk
#Include lib\functions.ahk

CoordMode("Mouse", "Client")
COCwindow := "ahk_exe crosvm.exe"
Esc::ExitApp  ; Exit script with Escape key

;ShowGUI()
BetterClick(x, y) { ; credits to yuh for this, lowk a life saver
    MouseMove(x, y)
    Sleep(100)
    MouseClick()
    Sleep(50)
}


F9:: {
    if WinExist(COCwindow) {
        WinActivate(COCwindow)
        Sleep(200)
        ; Move to top-left without changing size: leave width/height blank
        FindMatch()
    }
}

FindMatch(){
    ; Use actual pattern variables from lib\functions.ahk
    steps := [
        { name: "AttackButton",      pattern: AttackButton },
        { name: "FindAMatchButton",  pattern: FindAMatchButton },
        { name: "LaunchAttackButton",pattern: LaunchAttackButton },
        { name: "EndBattleButton",   pattern: EndBattleButton }
    ]
    ; Activate the target window and get its client rect
    if !WinExist(COCwindow) {
        MsgBox("Target window not found")
        return
    }
    WinActivate(COCwindow)
    Sleep(100)
    WinGetClientPos(&cx, &cy, &cw, &ch, COCwindow)
    ; Ensure searches use client coordinates
    CoordMode("Pixel", "Client")
    for step in steps {
        x := 0, y := 0
        found := FindText(&x, &y, step.pattern, COCwindow, 0.8, 5, 5)
        ; Only accept hits within the client area
        if found && (x >= 0 && y >= 0 && x <= cw && y <= ch) {
            BetterClick(x, y)
            Sleep(1000)
            ; Optionally break after first success:
            ; break
        } else {
            MsgBox("Could not find " step.name)
            return
        }
    }
}

CameraSetup(){
    Sleep(100)
    loop 20{
        Click("WheelDown", , , 10)
        Sleep(50)
    }
}
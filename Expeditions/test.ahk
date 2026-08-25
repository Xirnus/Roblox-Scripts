#Requires AutoHotkey v2.0

#Include lib\gui.ahk
#Include lib\navigation.ahk
#Include lib\placeUnits.ahk
#Include lib\webhook.ahk
#Include lib\FindText.ahk

CoordMode("Mouse", "Client")
RobloxWindow := "ahk_exe RobloxPlayerBeta.exe"
Esc::ExitApp  ; Exit script with Escape key
global isScriptRunning := False

;ShowGUI()
if WinExist(RobloxWindow) {
    WinActivate(RobloxWindow)
} else {
    MsgBox("Roblox window not found. Please start the game and try again.")
    ExitApp
}

pattern:=0x7d7d7d


#Requires AutoHotkey v2.0
CoordMode "Pixel", "Screen"
CoordMode "Mouse", "Screen"
colors := [0x7d7d7d, 0xc2c2c2, 0xadadae]

global found:=[]

F8:: {
    targetColor := 0x7d7d7d
    x1 := 325, y1 := 238, x2 := 1265, y2 := 860
    for index in [1, 2, 3, 4, 5, 6] {
        foundX := 0, foundY := 0
        if PixelSearch(&foundX, &foundY, x1, y1, x2, y2, targetColor, 3) {
            ToolTip("Found color " index " at " foundX "," foundY)
            found.push([foundX, foundY])
            MouseMove(foundX, foundY)
            Sleep(1000)
        } else {
            ToolTip("Sequence broken at color " index)
            return
        }
    }
    ToolTip("Full sequence found!")
}


#MaxThreadsPerHotkey 2
F9:: {
    global isScriptRunning
    ; If the macro is not running yet, start it
    if (!isScriptRunning) {
        isScriptRunning := True
        ToolTip("Macro Started")
        SetTimer(() => ToolTip(), -1000)
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
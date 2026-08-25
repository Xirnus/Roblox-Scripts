#Requires AutoHotkey v2.0
Esc::ExitApp  ; Exit script with Escape key
; Run a program on Middle Click
global isScriptRunning := False
#MaxThreadsPerHotkey 2
F9:: {
    global isScriptRunning
    if (!isScriptRunning) {
        isScriptRunning := True
        ToolTip("Macro Started")
        SetTimer(() => ToolTip(), -1000)
        SetTimer(BuffLoop, 60000)
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

BuffLoop() {
    Send("{1}")
    Sleep(500)
    Send("{2}")
    Sleep(500)
    Send("{3}")
}

SpellLoop() {
    Send("{Q}")
    Sleep(300)
    Send("{XButton1}")
    Sleep(300)
    Send("{XButton2}")
    Sleep(300)
    Send("{E}")
    Sleep(300)
    Send("{r}")
    Sleep(300)
    Send("{tab}")
}



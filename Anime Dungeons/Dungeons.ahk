#Requires AutoHotkey v2.0
Esc::ExitApp  ; Exit script with Escape key
; Run a program on Middle Click
global isScriptRunning := False
#MaxThreadsPerHotkey 2
XButton1:: {
    global isScriptRunning
    if (!isScriptRunning) {
        isScriptRunning := True
        ToolTip("Macro Started")
        SetTimer(() => ToolTip(), -1000)
        while true {
            Send("{f down} {e down}")
            Sleep 500
            Send("{f up} {e up}")
        }
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
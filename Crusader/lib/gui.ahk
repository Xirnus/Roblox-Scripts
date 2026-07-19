#Requires AutoHotkey v2.0

if !IsSet(MyGui) {
    MyGui := Gui("+AlwaysOnTop")  ; Keeps GUI above game window
    MyGui.Title := "Yippie Macro"
    MyGui.SetFont("s10", "Segoe UI")

    MyGui.Add("Text", "vInstructionText x20 y10 w360", "Instructions: Press F9 to start macro, Esc to Stop the Macro")

    ; Win/Loss counters side-by-side, below instructions
    MyGui.Add("Text", "vWinText x20 y+10 w120", "Wins: 0")
    MyGui.Add("Text", "vLoseText x160 yp w120", "Losses: 0")
    
    ; Console section
    MyGui.Add("Text", "x20 y+20 w200", "Console Output:")
    MyGui.Add("Edit", "vConsole x20 y+5 w360 h250 ReadOnly VScroll")
    
    ; Clear console button
    MyGui.Add("Button", "vClearBtn x20 y+10 w100 h30", "Clear Console").OnEvent("Click", ClearConsole)
}

; Console functions
LogToConsole(message) {
    global MyGui
    currentTime := FormatTime(, "HH:mm:ss")
    logMessage := "[" . currentTime . "] " . message . "`r`n"
    
    ; Get current console text and append new message
    currentText := MyGui["Console"].Text
    newText := currentText . logMessage
    
    ; Keep only last 50 lines to prevent GUI from getting too slow
    lines := StrSplit(newText, "`r`n")
    if (lines.Length > 50) {
        newText := ""
        Loop 50 {
            idx := lines.Length - 50 + A_Index
            if (idx > 0)
                newText .= lines[idx] . "`r`n"
        }
    }
    
    MyGui["Console"].Text := newText
    
    ; Auto-scroll to bottom without focusing
    ControlSend("^{End}", "Edit1", MyGui)
}

ClearConsole(*) {
    global MyGui
    MyGui["Console"].Text := ""
}

MoveGui(){
    global MyGui, RobloxWindow

    if WinExist(RobloxWindow) {
        WinGetPos(&x, &y, &w, &h, RobloxWindow)
        ; Show GUI to the right of Roblox window
        MyGui.Show("x" (x + w + 10) " y" y " w300 h150")
    } else {
        MyGui.Show("w300 h150")
    }
}

ShowGUI() {
    MyGui.Show("w400 h400")
    LogToConsole("GUI Started - Macro Ready")
}

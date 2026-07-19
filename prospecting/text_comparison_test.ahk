; Test macro to check if minigame is active using Python for pixel detection
; Checks for specific pixel color at coordinates (487, 308) with color 0xEEFAFD

; Initialize monitoring variable
monitoringActive := false

; JSON parser class for Python responses
class JSON {
    static parse(text) {
        try {
            text := StrReplace(text, "{", "")
            text := StrReplace(text, "}", "")
            text := StrReplace(text, '"', "")
            
            result := Map()
            parts := StrSplit(text, ",")
            
            for part in parts {
                keyValue := StrSplit(Trim(part), ":")
                if (keyValue.Length >= 2) {
                    key := Trim(keyValue[1])
                    value := Trim(keyValue[2])
                    
                    if (value = "true") {
                        result[key] := true
                    } else if (value = "false") {
                        result[key] := false
                    } else {
                        result[key] := value
                    }
                }
            }
            return result
        } catch {
            return Map()
        }
    }
}

; Function to run Python command and get output
RunWaitOne(command) {
    try {
        tempFile := A_Temp . "\ahk_python_output_" . A_TickCount . ".txt"
        RunWait('cmd /c "' . command . '" > "' . tempFile . '"', , "Hide")
        
        if (FileExist(tempFile)) {
            output := FileRead(tempFile)
            FileDelete(tempFile)
            return Trim(output)
        }
        return ""
    } catch {
        return ""
    }
}

; Python-based pixel color getter
GetPixelColorPython(x, y) {
    try {
        cmd := 'python "' . A_ScriptDir . '\pixel_detector.py" get_pixel --x ' . x . ' --y ' . y
        result := RunWaitOne(cmd)
        
        if (result != "") {
            jsonObj := JSON.parse(result)
            if (jsonObj.Has("color")) {
                colorStr := jsonObj["color"]
                if (colorStr != "ERROR") {
                    return Integer(colorStr)
                }
            }
        }
        return 0
    } catch {
        return 0
    }
}

; Python-based minigame pixel checker
CheckMinigamePixelPython(x, y, targetColor) {
    try {
        cmd := 'python "' . A_ScriptDir . '\pixel_detector.py" check_minigame_pixel --x ' . x . ' --y ' . y . ' --target_color 0x' . Format("{:06X}", targetColor)
        result := RunWaitOne(cmd)
        
        if (result != "") {
            jsonObj := JSON.parse(result)
            if (jsonObj.Has("matches")) {
                return jsonObj["matches"]
            }
        }
        return false
    } catch {
        return false
    }
}

; Python-based pixel search with tolerance
PixelSearchPython(left, top, right, bottom, targetColor, tolerance := 0) {
    try {
        cmd := 'python "' . A_ScriptDir . '\pixel_detector.py" pixel_search '
        cmd .= '--left ' . left . ' --top ' . top . ' --right ' . right . ' --bottom ' . bottom . ' '
        cmd .= '--target_color 0x' . Format("{:06X}", targetColor) . ' --tolerance ' . tolerance
        
        result := RunWaitOne(cmd)
        
        if (result != "") {
            jsonObj := JSON.parse(result)
            if (jsonObj.Has("found") && jsonObj["found"]) {
                return {found: true, x: Integer(jsonObj["x"]), y: Integer(jsonObj["y"])}
            }
        }
        return {found: false}
    } catch {
        return {found: false}
    }
}

; Hotkey to test minigame detection (F1 key)
F1:: {
    CheckMinigameActive()
}

; Function to check if minigame is active using Python
CheckMinigameActive() {
    ; Define the target coordinates and color
    targetX := 487
    targetY := 308
    targetColor := 0xEEFAFD
    
    ; Get the pixel color using Python
    currentColor := GetPixelColorPython(targetX, targetY)
    
    ; Check if the color matches
    if (currentColor = targetColor) {
        ; Minigame is active
        MsgBox("Minigame is ACTIVE! (Python detection)", "Minigame Status", "T2")
        ToolTip("Minigame ACTIVE (Python)", 10, 10)
        SetTimer(RemoveTooltip, 2000)
        return true
    } else {
        ; Minigame is not active
        MsgBox("Minigame is NOT active. Current color: " . Format("0x{:06X}", currentColor), "Minigame Status", "T2")
        ToolTip("Minigame NOT ACTIVE (Python)", 10, 10)
        SetTimer(RemoveTooltip, 2000)
        return false
    }
}

; Function with color tolerance for more reliable detection using Python
CheckMinigameActiveWithTolerance() {
    targetX := 487
    targetY := 308
    targetColor := 0xEEFAFD
    tolerance := 5  ; Allow slight color variations
    
    ; Use Python pixel search with tolerance
    searchResult := PixelSearchPython(targetX, targetY, targetX, targetY, targetColor, tolerance)
    
    if (searchResult.found) {
        ; Color found within tolerance
        MsgBox("Minigame is ACTIVE! (Python with tolerance)", "Minigame Status", "T2")
        ToolTip("Minigame ACTIVE (Python tolerance)", 10, 10)
        SetTimer(RemoveTooltip, 2000)
        return true
    } else {
        ; Color not found
        currentColor := GetPixelColorPython(targetX, targetY)
        MsgBox("Minigame is NOT active. Current color: " . Format("0x{:06X}", currentColor), "Minigame Status", "T2")
        ToolTip("Minigame NOT ACTIVE (Python)", 10, 10)
        SetTimer(RemoveTooltip, 2000)
        return false
    }
}

; Hotkey for tolerance-based detection (F2 key)
F2:: {
    CheckMinigameActiveWithTolerance()
}

; Continuous monitoring function (F3 to start/stop)
F3:: {
    if (monitoringActive) {
        monitoringActive := false
        SetTimer(ContinuousCheck, 0)
        ToolTip("Monitoring STOPPED (Python)", 10, 30)
        SetTimer(RemoveTooltip, 2000)
    } else {
        monitoringActive := true
        SetTimer(ContinuousCheck, 1000)  ; Check every 1 second
        ToolTip("Monitoring STARTED (Python)", 10, 30)
        SetTimer(RemoveTooltip, 2000)
    }
}

; Continuous checking function
ContinuousCheck() {
    if (CheckMinigameActive()) {
        ; You can add actions here when minigame is detected
        ; For example: start automated actions, play sound, etc.
    }
}

; Remove tooltip function
RemoveTooltip() {
    ToolTip()
    SetTimer(RemoveTooltip, 0)
}

; ESC key to exit
Esc::ExitApp

; Display instructions on startup
MsgBox("Minigame Detection Test Macro (Python-Enhanced)`n`nControls:`nF1 - Test minigame detection (exact color match)`nF2 - Test minigame detection (with color tolerance)`nF3 - Start/Stop continuous monitoring`nESC - Exit script`n`nTarget: Pixel at (487, 308) with color 0xEEFAFD`nUsing Python for pixel detection", "Instructions", "T5")
#Requires AutoHotkey v2
#SingleInstance Force
#Include FindText.ahk

CoordMode("Mouse", "Screen")
SetControlDelay(-1)
SetWinDelay(-1)

; JSON parser class for Python responses
class JSON {
    static parse(text) {
        ; Simple JSON parser for our use case
        try {
            ; Remove outer braces and split by comma
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
                    
                    ; Convert boolean strings
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

; Function to run command and get output
RunWaitOne(command) {
    try {
        ; Create a temporary file for output
        tempFile := A_Temp . "\ahk_python_output_" . A_TickCount . ".txt"
        
        ; Run command and redirect output to file
        RunWait('cmd /c "' . command . '" > "' . tempFile . '"', , "Hide")
        
        ; Read the output
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

; Constants
RobloxWindow := "ahk_exe RobloxPlayerBeta.exe"
isPaused := false
lastProgressTime := 0
currentStep := ""

; Cached patterns for better performance
collectsand := "|<collectSand>*113$53.000Sw0000TU0bA003lVU1CM004a1U2Qk0098uTYtbkznWRVdnMP21A61nbUQ02E8lbCAlyQUGnCQxYgVUYaQs38N1D/AtnyHmFqAMlXwTbU61lXUQ32kq6HbVgD4z7sxtyDnw"
collectsand2 := "|<collectsand2>*156$52.zzznbzzzzVzzCTzzww3zwtzzznbjznbzzzATwDCT7sM3zUQts710DwMnbCMzAznnCQxbwnzDAtk6Tn7wwnbDtzCSlXCQTXww3USQs70ksT3tnky7W"

emptyPan :="|<EmptyPan>*115$9.7lXM+NbghZAdZAtaQ7lfv0E2U"
pan := "|<pan>*105$29.Tk0010M0020E004QLnz8gsIVFN0M1XXQlX0/1aa0wnBASHaOMUaAol10NdW34nGw3zwy"
pan2 := "|<Pan2>*136$26.0zzzk7zzwszzzDC78Hm0k4trAM0T3D0DAnkzbAwDtXD3y0nkzlAwU"


; Optimized constants
SEARCH_AREA := {left: 344, top: 520, right: 471, bottom: 537}
MINIGAME_AREA := {left: 483, top: 307, right: 489, bottom: 415}
EMPTY_PAN_AREA := {left: 387, top: 466, right: 395, bottom: 480}
TARGET_Y := 307
WHITE_THRESHOLD := 0xF0F0F0
PAN_FULL_COORD := {x: 500, y: 477}
PAN_FULL_COLORS := {full: 0xEAD568, notFull: 0xFEE770}

Esc::ExitApp
F2:: {
    global isPaused
    isPaused := !isPaused
    ToolTip(isPaused ? "PAUSED - F2 to resume" : "RESUMED")
    if (!isPaused) {
        SetTimer(() => ToolTip(""), -500)
    }
}

; Debug hotkey to test pan detection
F3:: {
    minigameActive := IsMinigameActive()
    panFull := IsPanFull()
    
    ; Also check specific target area using Python
    whiteAtTarget := IsWhiteAtY(TARGET_Y)
    
    ; Get current pixel color at target coordinates using Python
    currentColor := GetPixelColorPython(487, 308)
    
    result := "DETAILED PAN DEBUG (Python):`n"
    result .= "Minigame Area: " . MINIGAME_AREA.left . "," . MINIGAME_AREA.top . " to " . MINIGAME_AREA.right . "," . MINIGAME_AREA.bottom . "`n"
    result .= "Target Y: " . TARGET_Y . "`n"
    result .= "White at Target Y: " . (whiteAtTarget ? "YES" : "NO") . "`n"
    result .= "Minigame Active: " . (minigameActive ? "YES" : "NO") . "`n"
    result .= "Pan Full: " . (panFull ? "YES" : "NO") . "`n"
    result .= "Color at (487,308): " . Format("0x{:06X}", currentColor)
    
    ToolTip(result)
    SetTimer(() => ToolTip(""), -8000)
}

; Progress tracking function
UpdateProgress(step) {
    global lastProgressTime, currentStep
    lastProgressTime := A_TickCount
    currentStep := step
    ToolTip("STEP: " . step)
    SetTimer(() => ToolTip(""), -1500)  ; Show step for 1.5 seconds
}

; Emergency reset check
CheckEmergencyReset() {
    global lastProgressTime, currentStep
    if (A_TickCount - lastProgressTime > 300000) { ; 5 minutes = 300000ms
        ToolTip("EMERGENCY RESET - No progress for 5 minutes at: " . currentStep)
        SetTimer(() => ToolTip(""), -2000)
        
        ; Force release any held keys/mouse
        Click("Up")
        Send("{w up}")
        Send("{s up}")
        Send("{a up}")
        Send("{d up}")
        
        ; Reset progress tracking
        lastProgressTime := A_TickCount
        return true
    }
    return false
}

; Check if minigame is active (white bar present anywhere in minigame area)
; Check if minigame is active using Python
IsMinigameActive() {
    try {
        ; Call Python script for minigame detection
        cmd := 'python "' . A_ScriptDir . '\pixel_detector.py" is_minigame_active '
        cmd .= '--left ' . MINIGAME_AREA.left . ' '
        cmd .= '--top ' . MINIGAME_AREA.top . ' '
        cmd .= '--right ' . MINIGAME_AREA.right . ' '
        cmd .= '--bottom ' . MINIGAME_AREA.bottom . ' '
        cmd .= '--target_y ' . TARGET_Y
        
        result := RunWaitOne(cmd)
        
        if (result != "") {
            ; Parse JSON response
            jsonObj := JSON.parse(result)
            if (jsonObj.Has("is_active")) {
                return jsonObj["is_active"]
            }
        }
        return false
    } catch {
        return false
    }
}

; Pan is full when minigame is no longer active
IsPanFull() {
    isActive := IsMinigameActive()
    isFull := !isActive
    
    ; Debug tooltip
    ToolTip("Minigame Active: " . (isActive ? "YES" : "NO") . " | Pan Full: " . (isFull ? "YES" : "NO"))
    SetTimer(() => ToolTip(""), -1000)
    
    return isFull
}

; White bar detection using Python
IsWhiteAtY(y) {
    try {
        ; Call Python script for white pixel detection
        cmd := 'python "' . A_ScriptDir . '\pixel_detector.py" is_white_at_y '
        cmd .= '--y ' . y . ' '
        cmd .= '--left ' . MINIGAME_AREA.left . ' '
        cmd .= '--right ' . MINIGAME_AREA.right . ' '
        cmd .= '--threshold 0xF0F0F0'
        
        result := RunWaitOne(cmd)
        
        if (result != "") {
            ; Parse JSON response
            jsonObj := JSON.parse(result)
            if (jsonObj.Has("is_white")) {
                return jsonObj["is_white"]
            }
        }
        return false
    } catch {
        return false
    }
}

; Ultra-optimized minigame
Minigame() {
    global isPaused
    
    UpdateProgress("Minigame Start")
    
    if (IsPanFull()) {
        ToolTip("STEP: PAN ALREADY FULL - No minigame active")
        SetTimer(() => ToolTip(""), -800)
        UpdateProgress("Minigame Complete - Pan Full")
        return true
    }
    
    mousePressed := false
    startTime := A_TickCount
    alignedCount := 0
    consecutiveMisses := 0
    checkCount := 0
    
    try {
        Click("Down")
        mousePressed := true
        ToolTip("Minigame started - targeting Y:" . TARGET_Y)
        
        loop {
            checkCount++
            
            ; Emergency reset check
            if (CheckEmergencyReset()) {
                if (mousePressed) {
                    Click("Up")
                    mousePressed := false
                }
                ToolTip("Emergency reset triggered in minigame")
                SetTimer(() => ToolTip(""), -1000)
                return false
            }
            
            ; Pause/ESC check (optimized) - moved to top for immediate response
            while (isPaused) {
                if (mousePressed) {
                    Click("Up")
                    mousePressed := false
                }
                Sleep(100)
                if (GetKeyState("Escape", "P")) {
                    ToolTip("Stopped")
                    SetTimer(() => ToolTip(""), -300)
                    return false
                }
            }
            
            if (GetKeyState("Escape", "P")) {
                if (mousePressed) {
                    Click("Up")
                    mousePressed := false
                }
                ToolTip("Stopped")
                SetTimer(() => ToolTip(""), -300)
                return false
            }
            
            ; Quick pan full check - if no minigame active, pan is full
            if (IsPanFull()) {
                if (mousePressed) {
                    Click("Up")
                    mousePressed := false
                }
                ToolTip("STEP: PAN FULL - Minigame ended after " . alignedCount . " hits")
                SetTimer(() => ToolTip(""), -800)
                UpdateProgress("Minigame Complete - " . alignedCount . " hits")
                return true
            }
            
            ; White bar detection using Python - only at exact target Y or very close
            whiteDetected := false
            detectedY := -1  ; Track which Y position triggered
            
            ; Check if white bar is at target Y (±1 pixel for precision) using Python
            if (IsWhiteAtY(TARGET_Y)) {
                whiteDetected := true
                detectedY := TARGET_Y
            } else if (IsWhiteAtY(TARGET_Y - 1)) {
                whiteDetected := true
                detectedY := TARGET_Y - 1
            } else if (IsWhiteAtY(TARGET_Y + 1)) {
                whiteDetected := true
                detectedY := TARGET_Y + 1
            }
            
            if (whiteDetected) {
                alignedCount++
                consecutiveMisses := 0
                ToolTip("HIT " . alignedCount . " at Y:" . detectedY . " (Target:" . TARGET_Y . ")")
                UpdateProgress("Minigame Hit " . alignedCount)
                
                if (mousePressed) {
                    Click("Up")
                    mousePressed := false
                    Sleep(30)
                }
                
                ; Early exit if pan is full after hits (minigame disappeared)
                if (IsPanFull()) {
                    ToolTip("STEP: PAN FULL - Minigame ended after " . alignedCount . " hits")
                    SetTimer(() => ToolTip(""), -800)
                    UpdateProgress("Minigame Complete - " . alignedCount . " hits")
                    return true
                }
                
                ; Wait for bar to move away, then restart clicking
                Sleep(1000)  ; Longer wait to ensure bar moves away
                Click("Down")
                mousePressed := true
                ToolTip("Restarted after hit " . alignedCount . " - Tracking Y:" . TARGET_Y)
                
            } else {
                consecutiveMisses++
                
                if (!mousePressed) {
                    Click("Down")
                    mousePressed := true
                }
                
                ; Status updates (less frequent)
                if (Mod(checkCount, 1000) == 0) {
                    ToolTip("Tracking Y:" . TARGET_Y . " - " . alignedCount . " hits - " . checkCount . " checks")
                }
                
                ; Anti-stuck mechanism
                if (consecutiveMisses > 150) {
                    Click("Up")
                    Sleep(50)
                    Click("Down")
                    consecutiveMisses := 0
                }
            }
            
            ; Emergency restart
            if (checkCount > 0 && Mod(checkCount, 1500) == 0 && alignedCount == 0) {
                if (mousePressed) {
                    Click("Up")
                    mousePressed := false
                }
                Sleep(100)
                Click()
                Sleep(150)
                Click("Down")
                mousePressed := true
            }
            
            ; Timeout - 2 minutes
            if (A_TickCount - startTime > 120000) {
                if (mousePressed) {
                    Click("Up")
                    mousePressed := false
                }
                ToolTip("Timeout")
                SetTimer(() => ToolTip(""), -500)
                return false
            }
            
            Sleep(1)  ; Minimal delay for responsiveness
        }
    } catch Error as e {
        if (mousePressed) {
            Click("Up")
            mousePressed := false
        }
        ToolTip("Error: " . e.message)
        SetTimer(() => ToolTip(""), -1000)
        return false
    }
}

; Ultra-fast search function
FastSearch(patterns, movementKey, searchName, timeout := 80000) {
    global isPaused
    
    UpdateProgress("Searching for " . searchName)
    ToolTip("STEP: Searching for " . searchName . "...")
    startTime := A_TickCount
    moveCount := 0
    
    loop {
        ; Emergency reset check
        if (CheckEmergencyReset()) {
            ToolTip("Emergency reset triggered during " . searchName . " search")
            SetTimer(() => ToolTip(""), -1000)
            return false
        }
        ; Pause/ESC check
        while (isPaused) {
            Sleep(100)
            if (GetKeyState("Escape", "P")) {
                ToolTip("Search stopped")
                SetTimer(() => ToolTip(""), -300)
                return false
            }
        }
        
        if (GetKeyState("Escape", "P")) {
            ToolTip("Search stopped")
            SetTimer(() => ToolTip(""), -300)
            return false
        }
        
        ; Check all patterns
        for pattern in patterns {
            if (FindText(&X, &Y, SEARCH_AREA.left, SEARCH_AREA.top, SEARCH_AREA.right, SEARCH_AREA.bottom, 0.12, 0.12, pattern)) {
                ToolTip("STEP: " . searchName . " found!")
                SetTimer(() => ToolTip(""), -800)
                UpdateProgress(searchName . " found")
                return true
            }
        }
        
        ; Movement
        moveCount++
        Send("{" . movementKey . " down}")
        Sleep(100)
        Send("{" . movementKey . " up}")
        Sleep(150)
        
        ; Status update
        if (Mod(moveCount, 25) == 0) {
            ToolTip("STEP: Searching " . searchName . "... " . moveCount . " moves")
        }
        
        ; Timeout
        if (A_TickCount - startTime > timeout) {
            ToolTip(searchName . " search timeout")
            SetTimer(() => ToolTip(""), -500)
            return false
        }
    }
}

; Optimized collect sand search
FastCollectSandSearch() => FastSearch([collectsand, collectsand2], "w", "collect sand")

; Optimized pan search
FastPanSearch() => FastSearch([pan, pan2], "s", "pan")

; Ultra-optimized shake minigame with better false positive prevention
FastShakeMinigame() {
    global isPaused
    
    UpdateProgress("Shake minigame starting")
    ToolTip("STEP: Starting shake minigame...")
    SetTimer(() => ToolTip(""), -800)
    
    ; Quick initial check
    if (FindText(&X, &Y, EMPTY_PAN_AREA.left, EMPTY_PAN_AREA.top, EMPTY_PAN_AREA.right, EMPTY_PAN_AREA.bottom, 0.08, 0.08, emptyPan)) {
        ToolTip("STEP: Pan already empty")
        SetTimer(() => ToolTip(""), -800)
        UpdateProgress("Shake Complete - Already Empty")
        return true
    }
    
    Click()
    Sleep(400)
    Click("Down")
    
    startTime := A_TickCount
    checkCount := 0
    consecutiveDetections := 0
    
    loop {
        checkCount++
        Sleep(1200)  ; Optimized check interval
        
        ; Emergency reset check
        if (CheckEmergencyReset()) {
            Click("Up")
            ToolTip("Emergency reset triggered during shake")
            SetTimer(() => ToolTip(""), -1000)
            return false
        }
        
        ; Pause/ESC check
        while (isPaused) {
            Click("Up")
            Sleep(100)
            if (GetKeyState("Escape", "P")) {
                ToolTip("Shake stopped")
                SetTimer(() => ToolTip(""), -300)
                return false
            }
        }
        
        if (GetKeyState("Escape", "P")) {
            Click("Up")
            ToolTip("Shake stopped")
            SetTimer(() => ToolTip(""), -300)
            return false
        }
        
        try {
            ; Enhanced empty pan detection with consecutive validation
            if (FindText(&X, &Y, EMPTY_PAN_AREA.left, EMPTY_PAN_AREA.top, EMPTY_PAN_AREA.right, EMPTY_PAN_AREA.bottom, 0.08, 0.08, emptyPan)) {
                ; Position validation
                expectedCenterX := (EMPTY_PAN_AREA.left + EMPTY_PAN_AREA.right) / 2
                expectedCenterY := (EMPTY_PAN_AREA.top + EMPTY_PAN_AREA.bottom) / 2
                
                if (Abs(X - expectedCenterX) <= 8 && Abs(Y - expectedCenterY) <= 8) {
                    consecutiveDetections++
                    ToolTip("STEP: Empty pan detected " . consecutiveDetections . "/2")
                    
                    ; Require 2 consecutive detections
                    if (consecutiveDetections >= 2) {
                        ; Final strict validation
                        Sleep(200)
                        if (FindText(&X2, &Y2, EMPTY_PAN_AREA.left, EMPTY_PAN_AREA.top, EMPTY_PAN_AREA.right, EMPTY_PAN_AREA.bottom, 0.04, 0.04, emptyPan)) {
                            Click("Up")
                            ToolTip("STEP: Pan empty confirmed - " . checkCount . " checks")
                            SetTimer(() => ToolTip(""), -1000)
                            UpdateProgress("Shake Complete - Pan Empty")
                            return true
                        }
                    }
                    Sleep(300)
                } else {
                    consecutiveDetections := 0
                    ToolTip("STEP: False positive at " . X . "," . Y . " - continuing...")
                    Sleep(200)
                }
            } else {
                consecutiveDetections := 0
            }
            
            ; Status update
            if (Mod(checkCount, 4) == 0) {
                ToolTip("STEP: Shaking pan... " . checkCount . " checks")
            }
            
            ; Re-click mechanism
            if (checkCount > 6 && Mod(checkCount, 8) == 0) {
                Click("Up")
                Sleep(40)
                Click("Down")
            }
            
            ; Emergency restart
            if (checkCount == 12) {
                Click("Up")
                Sleep(80)
                ToolTip("STEP: Emergency restart shake")
                SetTimer(() => ToolTip(""), -800)
                Click()
                Sleep(150)
                Click("Down")
            }
            
        } catch Error as e {
            Click("Up")
            ToolTip("Shake error: " . e.message)
            SetTimer(() => ToolTip(""), -300)
            return false
        }
        
        ; Timeout - 60 seconds
        if (A_TickCount - startTime > 60000) {
            Click("Up")
            ToolTip("STEP: Shake timeout - assuming success")
            SetTimer(() => ToolTip(""), -1000)
            return true
        }
    }
}

; Streamlined macro execution
OptimizedMacro() {
    try {
        UpdateProgress("Starting collect sand search")
        if (!FastCollectSandSearch()) {
            ToolTip("STEP: Failed - collect sand search")
            SetTimer(() => ToolTip(""), -1500)
            return false
        }
        
        Sleep(100)
        
        UpdateProgress("Starting minigame")
        if (!Minigame()) {
            ToolTip("STEP: Failed - minigame")
            SetTimer(() => ToolTip(""), -1500)
            return false
        }
        
        Sleep(100)
        
        UpdateProgress("Starting pan search")
        if (!FastPanSearch()) {
            ToolTip("STEP: Failed - pan search")
            SetTimer(() => ToolTip(""), -1500)
            return false
        }
        
        Sleep(100)
        
        UpdateProgress("Starting shake minigame")
        if (!FastShakeMinigame()) {
            ToolTip("STEP: Failed - shake minigame")
            SetTimer(() => ToolTip(""), -1500)
            return false
        }
        
        ToolTip("STEP: Cycle complete ✓")
        SetTimer(() => ToolTip(""), -1000)
        return true
        
    } catch Error as e {
        ToolTip("STEP: Macro error - " . e.message)
        SetTimer(() => ToolTip(""), -2000)
        return false
    }
}

; Main execution hotkey with better error recovery
F1:: {
    global isPaused, lastProgressTime
    
    ; Ensure clean start
    isPaused := false
    lastProgressTime := A_TickCount  ; Initialize progress tracking
    
    ; Activate window with retry
    try {
        WinActivate(RobloxWindow)
        WinMove(0, 0, 800, 600, RobloxWindow)
        Sleep(200)
        if (!WinActive(RobloxWindow)) {
            ToolTip("Failed to activate Roblox window")
            SetTimer(() => ToolTip(""), -2000)
            return
        }
    } catch {
        ToolTip("Roblox window not found")
        SetTimer(() => ToolTip(""), -2000)
        return
    }
    
    ToolTip("STEP: Starting optimized macro...")
    SetTimer(() => ToolTip(""), -1000)
    
    cycleCount := 0
    
    loop {
        ; Emergency reset check at cycle level
        if (CheckEmergencyReset()) {
            ToolTip("Emergency reset - restarting cycle " . (cycleCount + 1))
            SetTimer(() => ToolTip(""), -2000)
            ; Continue to next cycle instead of breaking
            Sleep(1000)
        }
        
        ; Check pause state at the beginning of each cycle
        while (isPaused) {
            Sleep(100)
            if (GetKeyState("Escape", "P")) {
                ToolTip("Macro stopped")
                SetTimer(() => ToolTip(""), -1000)
                return
            }
        }
        
        if (GetKeyState("Escape", "P")) {
            ToolTip("Macro stopped")
            SetTimer(() => ToolTip(""), -1000)
            return
        }
        
        cycleCount++
        ToolTip("STEP: Starting cycle " . cycleCount)
        SetTimer(() => ToolTip(""), -800)
        
        try {
            if (!OptimizedMacro()) {
                ToolTip("STEP: Macro failed on cycle " . cycleCount . " - stopping")
                SetTimer(() => ToolTip(""), -3000)
                break
            }
            
            ; Brief pause between cycles to prevent overwhelming
            Sleep(500)
            
        } catch Error as e {
            ToolTip("STEP: Unexpected error on cycle " . cycleCount . " - " . e.message)
            SetTimer(() => ToolTip(""), -3000)
            break
        }
    }
}
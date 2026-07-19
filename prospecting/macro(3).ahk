#Requires AutoHotkey v2
#SingleInstance Force
#Include FindText.ahk

CoordMode("Mouse", "Screen")
SetControlDelay(-1)
SetWinDelay(-1)

; Constants
RobloxWindow := "ahk_exe RobloxPlayerBeta.exe"
isPaused := false

; Cached patterns for better performance
collectsand := "|<collect>*137$92.000000zDk0000000000008G400000001z00024V000003k1kQ000V8E0000160k1U008G400000FUE0A0024V000004MA7W000V8E00001626D0Tk8G43y07tlx30kA624V1Uk63k1EU0A0MV8FU220A0IM02028G4E0l03076011kG4V8S4UxwTl00EW4V8GAF8Nl6AE0AMlcG5XwSA0FX40244+4VE03204MFU0V12V8I01kU164808EEcG53zo80FV30n6AO4VMU1X04M8MuEW4V8G6C8Nl623so718O6UyW3mEwE04U0X2kY04E0Y1306A0MEoBU360AUEQ71kQ6BX63UsCA41z07w0yDUzU3y0zU"
collectsand2 := "|<collect2>*177$88.zzzzzwD3zzzzzzzzzzzzkwDzzzzzzzUzzzz3kzzzzzzDs0zzzwD3zzzzzsz01zzzkwDzzzzzXsT7zzz3kzzzzzyD3zzzzwD3zzzzzswTzzUzkwDwDzsS01zzs0z3kz0Dw0M0Dzz01wD3s0TU1U0zzwT7kwDXsy7jXnzzVwD3kwTXkzyDDzyDswD3lzD7zswzzszXkwD00wTzXnzz3y73ks03VzyD7zyDswD3lzz7zswTzszXkwD7zwTzXkzzVwD3kwDzkzyDVwS7kyDXkTT1vsS01w07sS7U1y07UC0Ds0zVsT07w0T0y3zsDz7lzVzw7z2"
emptyPan := "|<emptyPan>*173$14.zzzzzyDy0z07VlsyQTX7sXy8zWDsXyNz4Tl7wFzCTXXlswS0Dk7z7zzzzzs"
pan := "|<Pan>*187$47.zzzzzzzz07zzzzzy03zzzzzw03zzzzzsz3zzzzzlz7zzzzzXyDsTswT7wC0DlUCDsw0DU0QTltwT1sMz3zwS7sk0DzUwDlU0zk1sTX07y7Xkz6Dzsz7VyATzlyD3wMzzXsS7slzz7UwDlXzy01sTX7zy0Xkz6Dzy77VyDzzzzzzzs"
pan2 := "|<pan2>*130$47.zy000001030000020100000401000008z200000F327w7rsW25kA8sB44C0AF0+88M08U0AEldw90sMy2TsG6Ek0AS0Y8lU0lU18EX07632EV6Ds8S4V2AE0l4924MU12MG48l033UY8FW02018EX4040WEV680674V2Dk07vty7s"

; Optimized constants
SEARCH_AREA := {left: 855, top: 891, right: 1066, bottom: 920}
MINIGAME_AREA := {left: 1145, top: 455, right: 1160, bottom: 652}
EMPTY_PAN_AREA := {left: 916, top: 795, right: 943, bottom: 826}
TARGET_Y := 460
WHITE_THRESHOLD := 0xF0F0F0
PAN_FULL_COORD := {x: 1188, y: 796}
PAN_FULL_COLORS := {full: 0xEAD568, notFull: 0xFBE56F}

Esc::ExitApp
F2:: {
    global isPaused
    isPaused := !isPaused
    ToolTip(isPaused ? "PAUSED - F2 to resume" : "RESUMED")
    if (!isPaused) {
        SetTimer(() => ToolTip(""), -500)
    }
}

; Ultra-fast pan full detection
IsPanFull() => PixelGetColor(PAN_FULL_COORD.x, PAN_FULL_COORD.y) == PAN_FULL_COLORS.full

; Optimized white bar detection
IsWhiteAtY(y) {
    loop MINIGAME_AREA.right - MINIGAME_AREA.left + 1 {
        if ((PixelGetColor(MINIGAME_AREA.left + A_Index - 1, y) & WHITE_THRESHOLD) == WHITE_THRESHOLD)
            return true
    }
    return false
}

; Ultra-optimized minigame
Minigame() {
    global isPaused
    
    if (IsPanFull()) {
        ToolTip("PAN ALREADY FULL")
        SetTimer(() => ToolTip(""), -300)
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
            
            ; Pause/ESC check (optimized)
            if (isPaused || GetKeyState("Escape", "P")) {
                if (mousePressed) {
                    Click("Up")
                    mousePressed := false
                }
                ToolTip("Stopped")
                SetTimer(() => ToolTip(""), -300)
                return false
            }
            
            ; Quick pan full check
            if (IsPanFull()) {
                if (mousePressed) {
                    Click("Up")
                    mousePressed := false
                }
                ToolTip("PAN FULL - " . alignedCount . " hits")
                SetTimer(() => ToolTip(""), -300)
                return true
            }
            
            ; White bar detection at target Y with tolerance
            whiteDetected := false
            loop 4 {  ; Check TARGET_Y ±3 pixels
                checkY := TARGET_Y + (A_Index - 2)
                if (checkY >= MINIGAME_AREA.top && checkY <= MINIGAME_AREA.bottom && IsWhiteAtY(checkY)) {
                    whiteDetected := true
                    break
                }
            }
            
            if (whiteDetected) {
                alignedCount++
                consecutiveMisses := 0
                ToolTip("HIT " . alignedCount)
                
                if (mousePressed) {
                    Click("Up")
                    mousePressed := false
                    Sleep(30)
                }
                
                ; Early exit if pan is full after hits
                if (IsPanFull()) {
                    ToolTip("PAN FULL - " . alignedCount . " hits")
                    SetTimer(() => ToolTip(""), -300)
                    return true
                }
                
                ; Wait for bar to move away, then restart clicking
                Sleep(1000)  ; Longer wait to ensure bar moves away
                Click("Down")
                mousePressed := true
                ToolTip("Restarted after hit " . alignedCount)
                
            } else {
                consecutiveMisses++
                
                if (!mousePressed) {
                    Click("Down")
                    mousePressed := true
                }
                
                ; Status updates (less frequent)
                if (Mod(checkCount, 1000) == 0) {
                    ToolTip("Tracking... " . alignedCount . " hits - " . checkCount . " checks")
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
    
    ToolTip("Searching " . searchName . "...")
    startTime := A_TickCount
    moveCount := 0
    
    loop {
        ; Pause/ESC check
        if (isPaused || GetKeyState("Escape", "P")) {
            ToolTip("Search stopped")
            SetTimer(() => ToolTip(""), -300)
            return false
        }
        
        ; Check all patterns
        for pattern in patterns {
            if (FindText(&X, &Y, SEARCH_AREA.left, SEARCH_AREA.top, SEARCH_AREA.right, SEARCH_AREA.bottom, 0.12, 0.12, pattern)) {
                ToolTip(searchName . " found")
                SetTimer(() => ToolTip(""), -200)
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
            ToolTip("Searching " . searchName . "... " . moveCount . " moves")
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
    
    ToolTip("Starting shake...")
    
    ; Quick initial check
    if (FindText(&X, &Y, EMPTY_PAN_AREA.left, EMPTY_PAN_AREA.top, EMPTY_PAN_AREA.right, EMPTY_PAN_AREA.bottom, 0.08, 0.08, emptyPan)) {
        ToolTip("Pan already empty")
        SetTimer(() => ToolTip(""), -200)
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
        
        ; Pause/ESC check
        if (isPaused || GetKeyState("Escape", "P")) {
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
                    ToolTip("Empty pan detected " . consecutiveDetections . "/2")
                    
                    ; Require 2 consecutive detections
                    if (consecutiveDetections >= 2) {
                        ; Final strict validation
                        Sleep(200)
                        if (FindText(&X2, &Y2, EMPTY_PAN_AREA.left, EMPTY_PAN_AREA.top, EMPTY_PAN_AREA.right, EMPTY_PAN_AREA.bottom, 0.04, 0.04, emptyPan)) {
                            Click("Up")
                            ToolTip("Pan empty confirmed - " . checkCount . " checks")
                            SetTimer(() => ToolTip(""), -300)
                            return true
                        }
                    }
                    Sleep(300)
                } else {
                    consecutiveDetections := 0
                    ToolTip("False positive at " . X . "," . Y . " - continuing...")
                    Sleep(200)
                }
            } else {
                consecutiveDetections := 0
            }
            
            ; Status update
            if (Mod(checkCount, 4) == 0) {
                ToolTip("Shaking... " . checkCount)
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
                ToolTip("Emergency restart")
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
            ToolTip("Shake timeout - assuming success")
            SetTimer(() => ToolTip(""), -500)
            return true
        }
    }
}

; Streamlined macro execution
OptimizedMacro() {
    try {
        if (!FastCollectSandSearch()) {
            ToolTip("Failed: collect sand")
            SetTimer(() => ToolTip(""), -1000)
            return false
        }
        
        Sleep(100)
        
        if (!Minigame()) {
            ToolTip("Failed: minigame")
            SetTimer(() => ToolTip(""), -500)
            return false
        }
        
        Sleep(100)
        
        if (!FastPanSearch()) {
            ToolTip("Failed: pan")
            SetTimer(() => ToolTip(""), -500)
            return false
        }
        
        Sleep(100)
        
        if (!FastShakeMinigame()) {
            ToolTip("Failed: shake")
            SetTimer(() => ToolTip(""), -500)
            return false
        }
        
        ToolTip("Cycle complete ✓")
        SetTimer(() => ToolTip(""), -500)
        return true
        
    } catch Error as e {
        ToolTip("Macro error: " . e.message)
        SetTimer(() => ToolTip(""), -1000)
        return false
    }
}

; Main execution hotkey
F1:: {
    global isPaused
    WinActivate(RobloxWindow)
    ToolTip("Starting optimized macro...")
    SetTimer(() => ToolTip(""), -500)
    
    loop {
        while (isPaused) {
            Sleep(100)
        }
        
        if (!OptimizedMacro()) {
            ToolTip("Macro failed - stopping")
            SetTimer(() => ToolTip(""), -2000)
            break
        }
        Sleep(200)
    }
}
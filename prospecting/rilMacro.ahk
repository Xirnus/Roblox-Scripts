#Requires AutoHotkey v2
#SingleInstance Force
#Include FindText.ahk

CoordMode("Pixel", "Screen")
CoordMode("Mouse", "Screen")
SetControlDelay(-1)
SetWinDelay(-1)

; Constants
RobloxWindow := "ahk_exe RobloxPlayerBeta.exe"

; Cached patterns for better performance
collectsand := "|<collectSand>*113$53.000Sw0000TU0bA003lVU1CM004a1U2Qk0098uTYtbkznWRVdnMP21A61nbUQ02E8lbCAlyQUGnCQxYgVUYaQs38N1D/AtnyHmFqAMlXwTbU61lXUQ32kq6HbVgD4z7sxtyDnw"
collectsand2 := "|<collectsand2>*156$52.zzznbzzzzVzzCTzzww3zwtzzznbjznbzzzATwDCT7sM3zUQts710DwMnbCMzAznnCQxbwnzDAtk6Tn7wwnbDtzCSlXCQTXww3USQs70ksT3tnky7W"

emptyPan :="|<EmptyPan>*115$9.7lXM+NbghZAdZAtaQ7lfv0E2U" 
pan := "|<pan>*105$29.Tk0010M0020E004QLnz8gsIVFN0M1XXQlX0/1aa0wnBASHaOMUaAol10NdW34nGw3zwy"
pan2 := "|<Pan2>*136$26.0zzzk7zzwszzzDC78Hm0k4trAM0T3D0DAnkzbAwDtXD3y0nkzlAwU"


; Optimized constants
SEARCH_AREA := {left: 344, top: 520, right: 471, bottom: 537}
MINIGAME_AREA := {left: 483, top: 307, right: 489, bottom: 415}
EMPTY_PAN_AREA := {left: 385, top: 467, right: 402, bottom: 482}
TARGET_Y := 306
WHITE_THRESHOLD := 0xF0F0F0
MINIGAME_CHECK := {x: 488, y: 306}
MINIGAME_CHECK_COLOR := {Found: 0x0DD50A}

ColorCloseEnough(a, b, tol := 16) {
    ; returns true if the largest per-channel difference <= tol
    r1 := (a >> 16) & 0xFF, g1 := (a >> 8) & 0xFF, bb1 := a & 0xFF
    r2 := (b >> 16) & 0xFF, g2 := (b >> 8) & 0xFF, bb2 := b & 0xFF
    rd := Abs(r1 - r2), gd := Abs(g1 - g2), bd := Abs(bb1 - bb2)
    return (Max(Max(rd, gd), bd) <= tol)
}

Max(a, b) {
    return a > b ? a : b
}

minigameCheck() {
    Click("Down")
    Sleep 100  ; wait 200ms before checking
    return minigameDetect()
}

minigameDetect() {
    currentColor := PixelGetColor(MINIGAME_CHECK.x, MINIGAME_CHECK.y, "RGB")
    expectedColor := MINIGAME_CHECK_COLOR.Found
    isFound := ColorCloseEnough(currentColor, expectedColor, 18)
    
    if isFound {
        ToolTip("Minigame Found")
    } else {
        ToolTip("Minigame Not Found")
    }
    SetTimer(() => ToolTip(""), -1500)
    
    return isFound
}

detectTargetTransition() {
    ; Multiple green variations at different Y levels
    greenColors := [0x0DD50A, 0x32CC2E, 0x40AF44, 0x54965C, 0x677C74]
    white := 0xFFFFFF
    tol := 25  ; Increased tolerance for better detection
    
    ; Scan multiple Y coordinates for better coverage
    yCoords := [306, 307, 308, 309, 310]
    
    ; Keep looping until we find the transition
    Loop {
        ; Check each Y coordinate
        for y in yCoords {
            ; Scan from left to right in the minigame area
            Loop MINIGAME_AREA.right - MINIGAME_AREA.left {
                x := MINIGAME_AREA.left + A_Index - 1
                ; Don't check the last pixel to avoid out of bounds on x+1
                if x >= MINIGAME_AREA.right {
                    break
                }
                color := PixelGetColor(x, y, "RGB")
                
                ; Check against all green variations
                for greenColor in greenColors {
                    if ColorCloseEnough(color, greenColor, tol) {
                        ; Look ahead for a white transition
                        nextColor := PixelGetColor(x+1, y, "RGB")
                        if ColorCloseEnough(nextColor, white, tol) {
                            Click("Up")
                            ToolTip("Transition Found at Y:" . y)
                            SetTimer(() => ToolTip(""), -1500)
                            return True
                        }
                    }
                }
            }
        }
        ; Small delay to prevent excessive CPU usage
        Sleep 10
    }
}

minigameGameplay(){
    if minigameCheck() {
        detectTargetTransition()
        Sleep 2000
        return "continue"  ; Continue with same pan
    } else {
        ToolTip("Pan Full")
        SetTimer(() => ToolTip(""), -1500)
        Click("Up")
        Sleep 500
        return "pan_full"  ; Pan is full, need to search for new pan
    }
}

; Optimized collect sand search
FastCollectSandSearch() => FastSearch([collectsand, collectsand2], "w", "collect sand")

; Optimized pan search
FastPanSearch() => FastSearch([pan, pan2], "s", "pan")

FastSearch(patterns, movementKey, searchName, timeout := 80000) {
    global isPaused
    
    ToolTip("Searching " . searchName . "...")
    startTime := A_TickCount
    moveCount := 0
    
    loop {
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

FastShakeMinigame() {
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
        Sleep(1000)

        
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

Macro(){
    try{
    if (!FastCollectSandSearch()) {
        ToolTip("Failed: collect sand search")
        SetTimer(() => ToolTip(""), -500)
        return false
    }

    Sleep (100)

    result := minigameGameplay()
    
    ; Only search for pan and shake if pan is full
    if (result == "pan_full") {
        if (!FastPanSearch()) {
            ToolTip("Failed: pan search")
            SetTimer(() => ToolTip(""), -500)
            return false
        }

        if (!FastShakeMinigame()) {
            ToolTip("Failed: shake")
            SetTimer(() => ToolTip(""), -500)
            return false
        }
        ToolTip("New pan ready ✓")
        SetTimer(() => ToolTip(""), -500)
    } else if (result == "continue") {
        ToolTip("Continuing with current pan ✓")
        SetTimer(() => ToolTip(""), -500)
    }
    
    return true
        
    } catch Error as e {
        ToolTip("Macro error: " . e.message)
        SetTimer(() => ToolTip(""), -1000)
        return false
    }
}
F1::{
    WinActivate(RobloxWindow)
    WinMove(0, 0, 800, 600, RobloxWindow)
    Sleep 200

    loop{
        if (!Macro()) {
            break  ; Only exit on actual errors, not pan full
        }
    }
    
    ToolTip("Macro Stopped - Error Occurred")
    SetTimer(() => ToolTip(""), -3000)
}

F2::{
    FastPanSearch()
}
Esc::ExitApp
#Requires AutoHotkey v2
#SingleInstance Force
#Include FindText.ahk

CoordMode("Mouse", "Screen")
RobloxWindow := "ahk_exe RobloxPlayerBeta.exe"

Esc::ExitApp  ; Exit script with Escape key


; Helper function to get coordinates for setting up minigame area
GetCoordinates() {
    MouseGetPos(&mouseX, &mouseY)
    pixelColor := PixelGetColor(mouseX, mouseY)
    ToolTip("Position: " . mouseX . ", " . mouseY . " | Color: 0x" . Format("{:06X}", pixelColor) . "`nUse this to set minigame boundaries")
    Sleep(20000)
    ToolTip("")
    return {x: mouseX, y: mouseY, color: pixelColor}
}

; Test function to screenshot the minigame area
TestMinigameArea() {
    ; Use the same coordinates as in FindMinigame function
    minigameLeft := 1145
    minigameTop := 461
    minigameRight := 1150
    minigameBottom := 652
    
    ; Calculate width and height
    width := minigameRight - minigameLeft
    height := minigameBottom - minigameTop
    
    ; Create timestamp for unique filename
    timestamp := FormatTime(A_Now, "yyyyMMdd_HHmmss")
    filename := "minigame_area_" . timestamp . ".png"
    
    try {
        ; Take screenshot of the defined area
        ToolTip("Taking screenshot of minigame area...")
        
        ; Use FindText library method
        if (FileExist("FindText.ahk")) {
            ; Take screenshot and save it directly
            ; SavePic method: SavePic(file, x1, y1, x2, y2, ScreenShot)
            FindText().SavePic(filename, minigameLeft, minigameTop, minigameRight, minigameBottom, 1)
            
            ; Check if file was created successfully
            if (FileExist(filename)) {
                ToolTip("Screenshot saved as: " . filename . "`nArea: " . minigameLeft . "," . minigameTop . " to " . minigameRight . "," . minigameBottom . "`nSize: " . width . "x" . height)
                Sleep(3000)
                ToolTip("")
                return true
            } else {
                ToolTip("Failed to save screenshot file: " . filename)
                Sleep(3000)
                ToolTip("")
                return false
            }
        }
        
        ; Fallback: Show area info
        ToolTip("FindText.ahk not found - Minigame area defined:`nLeft: " . minigameLeft . "`nTop: " . minigameTop . "`nRight: " . minigameRight . "`nBottom: " . minigameBottom . "`nWidth: " . width . "x" . height)
        Sleep(5000)
        ToolTip("")
        return false
        
    } catch Error as e {
        ToolTip("Error taking screenshot: " . e.message)
        Sleep(3000)
        ToolTip("")
        return false
    }
}

; Function to continuously check if bar is at target Y level
CheckBarAtTarget() {
    ; Use the same coordinates as in other functions
    minigameLeft := 1145
    minigameTop := 461
    minigameRight := 1160
    minigameBottom := 652
    
    ; Define the colors
    targetColor := 0x140807  ; Target color (green bar)
    barColor := 0xFFFFFF     ; White bar color
    variation := 10          ; Color variation tolerance
    tolerance := 12          ; Y position tolerance (pixels)
    
    ; Pan full detection coordinates and color
    panCheckX := 1197
    panCheckY := 800
    panFullColor := 0xFBE56F
    panVariation := 5
    
    try {
        ; First, find the target Y level
        if (PixelSearch(&targetX, &targetY, minigameLeft, minigameTop, minigameRight, minigameBottom, targetColor, variation)) {
            ToolTip("Target found at Y: " . targetY . " - Starting continuous monitoring until pan is full... (Press ESC to stop)")
            Sleep(1000)
            
            ; Continuous monitoring loop
            lastBarY := -1
            startTime := A_TickCount
            checkCount := 0
            alignedCount := 0
            
            loop {
                checkCount++
                
                ; Check for ESC key to stop monitoring
                if (GetKeyState("Escape", "P")) {
                    ToolTip("Monitoring stopped by user")
                    Sleep(1000)
                    ToolTip("")
                    return false
                }
                
                ; Search for the white bar
                if (PixelSearch(&barX, &barY, minigameLeft, minigameTop, minigameRight, minigameBottom, barColor, variation)) {
                    ; Calculate the difference
                    difference := Abs(barY - targetY)
                    
                    ; Update display every time bar position changes or every 100 checks
                    if (lastBarY != barY || Mod(checkCount, 100) == 0) {
                        ; Check if they're at the same level (within tolerance)
                        if (difference <= tolerance) {
                            alignedCount++
                            ToolTip("✓ BAR AT TARGET! Bar Y: " . barY . " | Target Y: " . targetY . " | Diff: " . difference . " pixels | Aligned: " . alignedCount . " times | Checks: " . checkCount)
                            Click("Up")
                            
                            ; Check if pan is full after hitting target
                            Sleep(500)  ; Wait a moment for game to process
                            panColor := PixelGetColor(panCheckX, panCheckY)
                            
                            ; Check if pan is full
                            if (Abs((panColor & 0xFF) - (panFullColor & 0xFF)) <= panVariation &&
                                Abs(((panColor >> 8) & 0xFF) - ((panFullColor >> 8) & 0xFF)) <= panVariation &&
                                Abs(((panColor >> 16) & 0xFF) - ((panFullColor >> 16) & 0xFF)) <= panVariation) {
                                
                                ToolTip("✓ PAN FULL! Minigame complete! Total aligned hits: " . alignedCount)
                                Sleep(3000)
                                ToolTip("")
                                return true
                            } else {
                                ToolTip("Pan not full yet - continuing minigame... (Pan color: 0x" . Format("{:06X}", panColor) . ")")
                                Sleep(1000)
                                ; Continue the loop to keep playing
                            }
                        } else {
                            direction := (barY < targetY ? " (Bar above target)" : " (Bar below target)")
                            ToolTip("Bar Y: " . barY . " | Target Y: " . targetY . " | Diff: " . difference . " pixels" . direction . " | Checks: " . checkCount)
                        }
                        lastBarY := barY
                    }
                } else {
                    ; Bar not found - show searching message every 500 checks
                    if (Mod(checkCount, 500) == 0) {
                        ToolTip("Searching for white bar... Checks: " . checkCount . " | Target at Y: " . targetY . " | Aligned: " . alignedCount)
                    }
                }
                
                ; Timeout safety - stop after 10 minutes (extended for multiple rounds)
                if (A_TickCount - startTime > 600000) {
                    ToolTip("Monitoring timeout after 10 minutes. Total aligned: " . alignedCount . " times")
                    Sleep(2000)
                    ToolTip("")
                    return false
                }
                
                ; Small delay to prevent 100% CPU usage but keep responsive
                Sleep(10)
            }
        } else {
            ToolTip("Target (green bar) not found in minigame area")
            Sleep(2000)
            ToolTip("")
            return false
        }
    } catch Error as e {
        ToolTip("Error checking bar position: " . e.message)
        Sleep(2000)
        ToolTip("")
        return false
    }
}

; Function to find target and monitor bar position
FindMinigame() {
    ; Define minigame search area (adjust these coordinates to match your minigame location)
    ; You can use F3 to get coordinates where your minigame appears
    minigameLeft := 1145    ; Left boundary (center - 200px)
    minigameTop := 461    ; Top boundary (center - 150px)
    minigameRight := 1160   ; Right boundary (center + 200px)
    minigameBottom := 652 ; Bottom boundary (center + 150px)
    
    ; Define the colors
    targetColor := 0x386241  ; Target color (green bar)
    barColor := 0xFFFFFF     ; White bar color
    variation := 10          ; Color variation tolerance
    
    ; First, find the target Y level within the minigame area
    targetY := -1
    try {
        if (PixelSearch(&targetX, &targetY, minigameLeft, minigameTop, minigameRight, minigameBottom, targetColor, variation)) {
            ToolTip("Target found at Y: " . targetY . " - Starting monitoring...")
            Sleep(200)  ; Give user time to see the message
            
            ; Fast pixel monitoring loop - check for bar pixel changes
            lastBarY := -1
            startTime := A_TickCount
            checkCount := 0
            
            loop {
                checkCount++
                
                ; Search for the white bar - only within the minigame area
                if (PixelSearch(&barX, &barY, minigameLeft, minigameTop, minigameRight, minigameBottom, barColor, variation)) {
                    ; Show position every 50 checks for more frequent debugging
                    if (Mod(checkCount, 50) == 0 || lastBarY != barY) {
                        ToolTip("Bar Y: " . barY . " | Target: " . targetY . " | Diff: " . (targetY - barY) . " | Checks: " . checkCount)
                        lastBarY := barY
                    }
                    
                    ; Check if bar has reached the target Y level
                    ; Bar starts high (low Y value) and moves down (higher Y value)
                    ; Release when bar Y is close to or past target Y
                    if (barY >= targetY - 10) {
                        ToolTip("Bar reached target level! Bar Y: " . barY . " Target Y: " . targetY . " - Releasing...")
                        Click("Up")  ; Release mouse immediately
                        Sleep(500)
                        ToolTip("")
                        return true
                    }
                    
                } else {
                    ; Bar not found - show searching message every 500 checks
                    if (Mod(checkCount, 500) == 0) {
                        ToolTip("Searching for bar... Checks: " . checkCount)
                    }
                }
                
                ; Timeout safety - release after 15 seconds
                if (A_TickCount - startTime > 15000) {
                    ToolTip("Timeout after 15 seconds - releasing mouse")
                    Click("Up")
                    Sleep(1000)
                    ToolTip("")
                    return false
                }
                
                ; Very small delay to prevent 100% CPU usage
                Sleep(1)
            }
        } else {
            ToolTip("Target color not found on screen")
            Sleep(2000)
            ToolTip("")
            return false
        }
    } catch Error as e {
        ToolTip("Error during pixel search: " . e.message)
        Sleep(2000)
        ToolTip("")
        Click("Up")  ; Safety release
        return false
    }
}

collectsand:="|<collect>*182$89.zzzzzy7VzzzzzzzzzzzzwD3zzzzzzzy7zzzsS7zzzzztzU3zzzkwDzzzzzXy03zzzVsTzzzzz7sT7zzz3kzzzzzyDVzzzzy7VzzzzzwT7zzwTwD3z3zy7U0Dzz07sS7s1zk300zzw07kwDU1y0601zzsyDVsT7lwDT7XzzVwD3kwTXkzyD7zz7wS7VszbXzwSDzyDswD3k0D7zswTzwTksS7U0SDzlsTzszXkwD7zwTzXszzlz7VsSDzszz7kzzVwD3kwDzkzyDkyDXsz7lsDjUxwDk0T01y7Vs0TU1s3k1z07wD3s0zU3s7sDzUzwT7y7zkTw8"

emptyPan:="|<emptyPan>*173$14.zzzzzyDy0z07VlsyQTX7sXy8zWDsXyNz4Tl7wFzCTXXlswS0Dk7z7zzzzzs"

pan:="|<Pan>*187$47.zzzzzzzz07zzzzzy03zzzzzw03zzzzzsz3zzzzzlz7zzzzzXyDsTswT7wC0DlUCDsw0DU0QTltwT1sMz3zwS7sk0DzUwDlU0zk1sTX07y7Xkz6Dzsz7VyATzlyD3wMzzXsS7slzz7UwDlXzy01sTX7zy0Xkz6Dzy77VyDzzzzzzzs"


    collectionLeft := 855
    collectionTop := 891
    collectionRight := 1066
    collectionBottom := 920

panSand(){
    Send("{s down}")
    Sleep(500)
    Send("{s up}")
}

lookCollectSand() {
    Send("{w down}")
    Sleep(500)
    Send("{w up}")
}

; Function to continuously move with S until pan text is found
ContinuousPanSearch() {
    ; Use the collection box coordinates you defined
    collectionLeft := 855
    collectionTop := 891
    collectionRight := 1066
    collectionBottom := 920
    
    ; Error tolerance for image matching
    errorTolerance := 0.1
    
    ToolTip("Starting continuous pan search... Moving with S until pan is found (Press ESC to stop)")
    Sleep(1000)
    
    startTime := A_TickCount
    moveCount := 0
    searchCount := 0
    
    loop {
        searchCount++
        
        ; Check for ESC key to stop the search
        if (GetKeyState("Escape", "P")) {
            ToolTip("Pan search stopped by user")
            Sleep(1000)
            ToolTip("")
            return false
        }
        
        ; Search for Pan image in the collection box area
        if (ok := FindText(&X, &Y, collectionLeft, collectionTop, collectionRight, collectionBottom, errorTolerance, errorTolerance, pan)) {
            ToolTip("✓ PAN FOUND! X: " . X . ", Y: " . Y . " after " . moveCount . " moves and " . searchCount . " searches")
            Sleep(2000)
            ToolTip("")
            return true
        }
        
        ; Pan not found, move with S key
        moveCount++
        Send("{s down}")
        Sleep(200)  ; Hold S for 200ms
        Send("{s up}")
        Sleep(300)  ; Wait 300ms before next search
        
        ; Show status every 10 moves
        if (Mod(moveCount, 10) == 0) {
            ToolTip("Searching for pan... Moves: " . moveCount . " | Searches: " . searchCount)
        }
        
        ; Timeout safety - stop after 5 minutes
        if (A_TickCount - startTime > 300000) {
            ToolTip("Pan search timeout after 5 minutes. Total moves: " . moveCount)
            Sleep(2000)
            ToolTip("")
            return false
        }
    }
}

; Function to continuously move with W until collect sand text is found
ContinuousCollectSandSearch() {
    ; Use the collection box coordinates you defined
    collectionLeft := 855
    collectionTop := 891
    collectionRight := 1066
    collectionBottom := 920
    
    ; Error tolerance for image matching
    errorTolerance := 0.1
    
    ToolTip("Starting continuous collect sand search... Moving with W until collect sand is found (Press ESC to stop)")
    Sleep(1000)
    
    startTime := A_TickCount
    moveCount := 0
    searchCount := 0
    
    loop {
        searchCount++
        
        ; Check for ESC key to stop the search
        if (GetKeyState("Escape", "P")) {
            ToolTip("Collect sand search stopped by user")
            Sleep(1000)
            ToolTip("")
            return false
        }
        
        ; Search for Collect Sand image in the collection box area
        if (ok := FindText(&X, &Y, collectionLeft, collectionTop, collectionRight, collectionBottom, errorTolerance, errorTolerance, collectsand)) {
            ToolTip("✓ COLLECT SAND FOUND! X: " . X . ", Y: " . Y . " after " . moveCount . " moves and " . searchCount . " searches")
            Sleep(2000)
            ToolTip("")
            return true
        }
        
        ; Collect sand not found, move with W key
        moveCount++
        Send("{w down}")
        Sleep(200)  ; Hold W for 200ms
        Send("{w up}")
        Sleep(300)  ; Wait 300ms before next search
        
        ; Show status every 10 moves
        if (Mod(moveCount, 10) == 0) {
            ToolTip("Searching for collect sand... Moves: " . moveCount . " | Searches: " . searchCount)
        }
        
        ; Timeout safety - stop after 5 minutes
        if (A_TickCount - startTime > 300000) {
            ToolTip("Collect sand search timeout after 5 minutes. Total moves: " . moveCount)
            Sleep(2000)
            ToolTip("")
            return false
        }
    }
}


; Function to check if pan is full
CheckPanFull() {
    ; Coordinates and color for pan full detection
    checkX := 1197
    checkY := 808
    targetColor := 0x412B06
    variation := 5  ; Small variation tolerance for color matching
    
    try {
        ; Get the pixel color at the specified coordinates
        currentColor := PixelGetColor(checkX, checkY)
        
        ; Check if the color matches (with variation tolerance)
        if (Abs((currentColor & 0xFF) - (targetColor & 0xFF)) <= variation &&
            Abs(((currentColor >> 8) & 0xFF) - ((targetColor >> 8) & 0xFF)) <= variation &&
            Abs(((currentColor >> 16) & 0xFF) - ((targetColor >> 16) & 0xFF)) <= variation) {
            
            ToolTip("✓ PAN FULL! Color: 0x" . Format("{:06X}", currentColor) . " at " . checkX . ", " . checkY)
            Sleep(2000)
            ToolTip("")
            return true
        } else {
            ToolTip("Pan not full. Expected: 0x" . Format("{:06X}", targetColor) . " | Found: 0x" . Format("{:06X}", currentColor) . " at " . checkX . ", " . checkY)
            Sleep(2000)
            ToolTip("")
            return false
        }
    } catch Error as e {
        ToolTip("Error checking pan status: " . e.message)
        Sleep(2000)
        ToolTip("")
        return false
    }
}

; Function to continuously monitor pan status
ContinuousPanFullCheck() {
    ; Coordinates and color for pan full detection
    checkX := 1197
    checkY := 800
    targetColor := 0xFBE56F
    variation := 5  ; Small variation tolerance for color matching
    
    ToolTip("Starting continuous pan full monitoring... (Press ESC to stop)")
    Sleep(1000)
    
    startTime := A_TickCount
    checkCount := 0
    fullCount := 0
    
    loop {
        checkCount++
        
        ; Check for ESC key to stop monitoring
        if (GetKeyState("Escape", "P")) {
            ToolTip("Pan monitoring stopped by user")
            Sleep(1000)
            ToolTip("")
            return false
        }
        
        try {
            ; Get the pixel color at the specified coordinates
            currentColor := PixelGetColor(checkX, checkY)
            
            ; Check if the color matches (with variation tolerance)
            if (Abs((currentColor & 0xFF) - (targetColor & 0xFF)) <= variation &&
                Abs(((currentColor >> 8) & 0xFF) - ((targetColor >> 8) & 0xFF)) <= variation &&
                Abs(((currentColor >> 16) & 0xFF) - ((targetColor >> 16) & 0xFF)) <= variation) {
                
                fullCount++
                ToolTip("✓ PAN FULL! Count: " . fullCount . " | Checks: " . checkCount . " | Color: 0x" . Format("{:06X}", currentColor))
            } else {
                ; Show status every 100 checks when not full
                if (Mod(checkCount, 100) == 0) {
                    ToolTip("Pan not full | Checks: " . checkCount . " | Full count: " . fullCount . " | Current color: 0x" . Format("{:06X}", currentColor))
                }
            }
        } catch Error as e {
            ToolTip("Error checking pan status: " . e.message)
            Sleep(1000)
        }
        
        ; Timeout safety - stop after 10 minutes
        if (A_TickCount - startTime > 600000) {
            ToolTip("Pan monitoring timeout after 10 minutes. Full detections: " . fullCount)
            Sleep(2000)
            ToolTip("")
            return false
        }
        
        ; Small delay to prevent 100% CPU usage
        Sleep(100)
    }
}

; Function to monitor pan status and control mouse button
MonitorPanAndControlMouse() {
    ; Pan detection coordinates and colors
    panCheckX := 1197
    panCheckY := 800
    panEmptyColor := 0x412B06    ; Color when pan is empty
    panFullColor := 0xFBE56F     ; Color when pan is full
    variation := 5               ; Color variation tolerance
    
    ToolTip("Starting pan monitoring with mouse control... (Press ESC to stop)")
    Sleep(1000)
    
    startTime := A_TickCount
    checkCount := 0
    mouseHeld := false
    
    loop {
        checkCount++
        
        ; Check for ESC key to stop monitoring
        if (GetKeyState("Escape", "P")) {
            ; Release mouse if held when stopping
            if (mouseHeld) {
                Click("Up")
                mouseHeld := false
            }
            ToolTip("Pan monitoring stopped by user")
            Sleep(1000)
            ToolTip("")
            return false
        }
        
        try {
            ; Get the pixel color at the specified coordinates
            currentColor := PixelGetColor(panCheckX, panCheckY)
            
            ; Check if pan is empty (matches empty color)
            if (Abs((currentColor & 0xFF) - (panEmptyColor & 0xFF)) <= variation &&
                Abs(((currentColor >> 8) & 0xFF) - ((panEmptyColor >> 8) & 0xFF)) <= variation &&
                Abs(((currentColor >> 16) & 0xFF) - ((panEmptyColor >> 16) & 0xFF)) <= variation) {
                
                ; Pan is empty - release mouse button if held
                if (mouseHeld) {
                    Click("Up")
                    mouseHeld := false
                    ToolTip("✓ PAN EMPTY - Mouse button RELEASED | Checks: " . checkCount . " | Color: 0x" . Format("{:06X}", currentColor))
                } else {
                    ; Show status every 50 checks when already released
                    if (Mod(checkCount, 50) == 0) {
                        ToolTip("Pan empty - Mouse already released | Checks: " . checkCount . " | Color: 0x" . Format("{:06X}", currentColor))
                    }
                }
                
            } else {
                ; Pan is not empty (still has contents) - hold mouse button down
                if (!mouseHeld) {
                    Click("Down")
                    mouseHeld := true
                    ToolTip("✓ PAN FULL - Mouse button HELD DOWN | Checks: " . checkCount . " | Color: 0x" . Format("{:06X}", currentColor))
                } else {
                    ; Show status every 50 checks when already held
                    if (Mod(checkCount, 50) == 0) {
                        ToolTip("Pan full - Mouse held down | Checks: " . checkCount . " | Color: 0x" . Format("{:06X}", currentColor))
                    }
                }
            }
            
        } catch Error as e {
            ; Release mouse on error for safety
            if (mouseHeld) {
                Click("Up")
                mouseHeld := false
            }
            ToolTip("Error checking pan status: " . e.message)
            Sleep(1000)
        }
        
        ; Timeout safety - stop after 10 minutes and release mouse
        if (A_TickCount - startTime > 600000) {
            if (mouseHeld) {
                Click("Up")
                mouseHeld := false
            }
            ToolTip("Pan monitoring timeout after 10 minutes")
            Sleep(2000)
            ToolTip("")
            return false
        }
        
        ; Small delay to prevent 100% CPU usage but keep responsive
        Sleep(50)
    }
}

; Improved shake minigame using text detection for empty pan
shakeMinigame(){
    ; Collection area coordinates where the empty pan text appears
    collectionLeft := 855
    collectionTop := 891
    collectionRight := 1066
    collectionBottom := 920
    
    ; Error tolerance for image matching
    errorTolerance := 0.1
    
    ToolTip("🔄 Starting shake minigame... Checking if pan is already empty")
    Sleep(500)
    
    ; Quick initial check - see if pan is already empty
    if (FindText(&X, &Y, collectionLeft, collectionTop, collectionRight, collectionBottom, errorTolerance, errorTolerance, emptyPan)) {
        ToolTip("✅ Pan already empty! No shaking needed")
        Sleep(1000)
        ToolTip("")
        return true
    }
    
    ToolTip("🔄 Pan not empty - starting shake process...")
    Sleep(500)
    
    ; Start shaking - click and hold
    Click()
    Sleep(200)
    Click("Down")
    
    startTime := A_TickCount
    checkCount := 0
    
    loop {
        checkCount++
        Sleep(1000)  ; Check every 1 second
        
        ; Quick ESC check
        if (GetKeyState("Escape", "P")) {
            Click("Up")
            ToolTip("Shake minigame stopped by user")
            Sleep(500)
            ToolTip("")
            return false
        }
        
        try {
            ; Check for empty pan text in collection area
            if (FindText(&X, &Y, collectionLeft, collectionTop, collectionRight, collectionBottom, errorTolerance, errorTolerance, emptyPan)) {
                Click("Up")  ; Release mouse
                ToolTip("✅ EMPTY PAN DETECTED! Shake complete after " . checkCount . " checks")
                Sleep(1000)
                ToolTip("")
                return true
            }
            
            ; Show status every 3 checks
            if (Mod(checkCount, 3) == 0) {
                ToolTip("🔄 Shaking... Check #" . checkCount . " (Looking for empty pan text)")
            }
            
        } catch Error as e {
            Click("Up")
            ToolTip("❌ Error during shake: " . e.message)
            Sleep(1000)
            ToolTip("")
            return false
        }
        
        ; Timeout safety - stop after 2 minutes
        if (A_TickCount - startTime > 120000) {
            Click("Up")
            ToolTip("⏰ Shake timeout after 2 minutes")
            Sleep(1000)
            ToolTip("")
            return false
        }
    }
}

; Test function to check empty pan text detection
TestEmptyPanDetection() {
    ; Collection area coordinates
    collectionLeft := 855
    collectionTop := 891
    collectionRight := 1066
    collectionBottom := 920
    
    ; Error tolerance for image matching
    errorTolerance := 0.1
    
    ToolTip("🔍 Testing empty pan text detection...")
    Sleep(1000)
    
    try {
        if (FindText(&X, &Y, collectionLeft, collectionTop, collectionRight, collectionBottom, errorTolerance, errorTolerance, emptyPan)) {
            ToolTip("✅ EMPTY PAN TEXT FOUND! X: " . X . ", Y: " . Y)
            Sleep(3000)
            ToolTip("")
            return true
        } else {
            ToolTip("❌ Empty pan text NOT found in collection area")
            Sleep(3000)
            ToolTip("")
            return false
        }
    } catch Error as e {
        ToolTip("❌ Error testing empty pan detection: " . e.message)
        Sleep(2000)
        ToolTip("")
        return false
    }
}


F2::
{
    ; Activate the game window
    WinActivate(RobloxWindow)
    Sleep(200)

    Click("Down")
}

; Optimized pan full detection using text comparison
IsPanFullOptimized() {
    ;if PixelGetColor(1188,796) == 0xEAD568
    ;    MsgBox("Pixel is pan full")
    if PixelGetColor(734,810) == 0x225931  ; Pan Empty Pixel
        MsgBox("Pixel is pan empty")
    else
        MsgBox("Pixel is not pan full or empty")
}

F6::{
    WinActivate(RobloxWindow)
    Sleep(200)
    IsPanFullOptimized()
}

; Hotkey to get coordinates for setting up minigame area
F3::GetCoordinates()

; Hotkey to check if bar is at target level
F4::CheckBarAtTarget()

; Hotkey to test minigame area (screenshot)
F5::TestMinigameArea()



; Hotkey to start continuous collect sand search with W movement
F7::ContinuousCollectSandSearch()

; Hotkey to check if pan is full (single check)
F8::CheckPanFull()

; Hotkey to continuously monitor pan full status
F9::ContinuousPanFullCheck()

; Hotkey to monitor pan and control mouse button
F10::MonitorPanAndControlMouse()

; Hotkey to test empty pan text detection
F11::TestEmptyPanDetection()

; Hotkey to test improved shake minigame
F12::shakeMinigame()

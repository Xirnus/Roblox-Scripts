
#Requires AutoHotkey v2.0

#Include lib/FindText.ahk
#Include lib/webhook.ahk

F9::{
    global wheeldownCount := 14
    webhook()
}
Esc::ExitApp

PlayAgain:="|<PlayAgainBtn>*144$27.k01zw001z0003s000D0000s00030000M000107s081zk10Dz001zs00DzU01zw00Dz001zs00Dy080z010000800030000M00070001s000z000Ds00Dz0Dzzs1zzz0Dzzs1zzz0Dzzs1zzz0Dzzw1zzzUDzzzjzzzU"
UltimateReady:="|<UltimateReady>*123$47.zzzzzzzttw7y3yDnVk3s1sDA307U3WCE60703CNU8QAC68n0EwMSC3DEVsEwCATV3kVsTtb27V3kzaC4D67Xz8w8QAC7wnsM0Q0Dtblk1s0zbDXk7s3zT7bwzyTyzc"
StartBtn:="|<StartBtn>*129$27.zs1zzs00zy001zU007s000S0001U000A0003U000M0DU703y1s0TwT03zzs0Tzz01zzw03zzU00zw000zk001z0003w000Ds001zk007zk00zzs07zzk0xzz063zw0UDz000zs003y000300000000001U000C0003s000zk00Dz007zz07zU"

LookDown() {
    global wheeldownCount := 14
    ; Get the width and height of the currently active window's client area
    WinGetClientPos(,, &clientWidth, &clientHeight, "A")
    
    ; Calculate the center coordinates dynamically
    centerX := clientWidth // 2
    centerY := clientHeight // 2

    BetterClick(centerX, centerY)
    loop 40 {
        SendInput("{WheelUp}")
        Sleep 50
    }
    Sleep 500
    SendInput(Format("{Click {} {} Left}", centerX, centerY + 200))
    Sleep 500
    loop wheeldownCount {
        SendInput("{WheelDown}")
        Sleep 50
    }
}

BetterClick(x, y) {
    MouseMove(x, y)
    MouseMove(1, 0, , "R")
    Sleep(100)
    MouseClick("Left", -1, 0, , , , "R")
    Sleep(50)
}

#SingleInstance Force

ScanWithExclusionZone() {
    ; Outer Bounding Box
    outLeft   := 329
    outTop    := 236
    outRight  := 1640
    outBottom := 843

    ; Character Exclusion Box (The area in the middle to IGNORE)
    ; Adjust these offset values based on your screen size
    deadLeft   := 873
    deadTop    := 477
    deadRight  := 1035
    deadBottom := 610

    targetColor := 0x411c25 ; Red color to match
    variation   := 10

    ; Define the 4 search regions around the deadzone:
    ; Each array contains [X1, Y1, X2, Y2]
    regions := [
        [outLeft,  outTop,     outRight,  deadTop],     ; Top
        [outLeft,  deadBottom, outRight,  outBottom],   ; Bottom
        [outLeft,  deadTop,    deadLeft,  deadBottom],  ; Left
        [deadRight, deadTop,   outRight,  deadBottom]   ; Right
    ]

    ; Loop through all 4 regions until a pixel is found
    for region in regions {
        if PixelSearch(&foundX, &foundY, region[1], region[2], region[3], region[4], targetColor, variation) {
            ; Enemy found outside character zone!
            MouseMove(foundX, foundY, 5)
            return true
        }
    }

    return false ; No targets found outside the deadzone
}

global isRunning := false
global moveStep := 1

; Press F7 to Start / Stop the Macro
F7:: {
    global isRunning, moveStep
    isRunning := !isRunning
    
    if (isRunning) {
        moveStep := 1
        ToolTip("Macro Started")
        
        ; Start Scanner Loop (Runs every 100 ms)
        SetTimer(ScanLoop, 100)
        
        ; Start Movement Loop (Runs every step interval)
        SetTimer(MovementStep, 10)
    }else {
        ; Stop both loops and release movement keys
        SetTimer(ScanLoop, 0)
        SetTimer(MovementStep, 0)
        ReleaseMovementKeys()
        
        ToolTip("Macro Stopped")
        SetTimer(() => ToolTip(), -1000)
    }
}

; -------------------------------------------------------------
; 1. ENEMY SCANNING LOOP (Runs in background)
; -------------------------------------------------------------
ScanLoop() {
    if !WinActive("ahk_exe RobloxPlayerBeta.exe")
        return

    ; Replace 'UltimateReady' with your actual FindText string/variable
    if FindText(&X, &Y, 1065, 845, 1126, 878, 0, 0, UltimateReady) {
        ToolTip("Casting Ultimate!")

        ; Wait for the ultimate to be cast
        While FindText(&X, &Y, 1065, 845, 1126, 878, 0, 0, UltimateReady) {
            Send("c")
            Sleep(200)

            If !FindText(&X, &Y, 1065, 845, 1126, 878, 0, 0, UltimateReady) {
                ToolTip("Ultimate Casted!")
                Sleep(500)
                break
            }
        }
        
        ; Temporarily pause this scanner loop while unleashing Ultimate
        SetTimer(ScanLoop, 0) 
        
        Sleep(6000) ; Brief delay to let the animation start
        LookDown()
        Sleep(200)
        
        ; Resume the scanner loop if macro is still toggled on
        if (isRunning)
            SetTimer(ScanLoop, 100)
            
        return ; Skip normal skill/aiming scan for this cycle
    }

    if FindText(&X, &Y, 533, 743, 621, 805, 0, 0, PlayAgain) {
        ToolTip("Play Again Detected!")
        webhook()
        BetterClick(X, Y)
        Sleep(1000)
        SetTimer(MovementStep, 0)
        ReleaseMovementKeys()
    }

    if FindText(&X, &Y, 882, 669, 930, 734, 0, 0, StartBtn) {
        ToolTip("Start Button Detected!")
        LookDown()
        Sleep(200)
        BetterClick(X, Y)
        Sleep(200)
        SetTimer(ScanLoop, 100)
        SetTimer(MovementStep, 10)
    }

    if ScanWithExclusionZone() {
        ToolTip("Enemy Targeted!")
        Send("e")
        Sleep(50)
        Send("f")
        Sleep(50)
        Click("Down")
    } else {
        ToolTip("Scanning...")
        Click("Up")
    }
}

; -------------------------------------------------------------
; 2. NON-BLOCKING MOVEMENT STATE MACHINE
; -------------------------------------------------------------
MovementStep() {
    global moveStep
    if !WinActive("ahk_exe RobloxPlayerBeta.exe")
        return

    switch moveStep {
        case 1: ; Press W
            Send("{w down} {a down}")
            SetTimer(MovementStep, -1000) ; Hold for 1000ms
            moveStep := 2

        case 2: ; Release W
            Send("{w up} {a up}")
            SetTimer(MovementStep, -100)  ; Pause for 100ms
            moveStep := 3

        case 3: ; Press A
            Send("{a down} {s down}")
            SetTimer(MovementStep, -1000)
            moveStep := 4

        case 4: ; Release A
            Send("{a up} {s up}")
            SetTimer(MovementStep, -100)
            moveStep := 5

        case 5: ; Press S
            Send("{s down} {d down}")
            SetTimer(MovementStep, -1000)
            moveStep := 6

        case 6: ; Release S
            Send("{s up} {d up}")
            SetTimer(MovementStep, -100)
            moveStep := 7

        case 7: ; Press D
            Send("{d down} {w down}")
            SetTimer(MovementStep, -1000)
            moveStep := 8

        case 8: ; Release D
            Send("{d up} {w up}")
            SetTimer(MovementStep, -100)
            moveStep := 1 ; Loop back to start
    }
}

; Safely release all movement keys when stopping
ReleaseMovementKeys() {
    Send("{w up} {a up}")
    Send("{a up} {s up}")
    Send("{s up} {d up}")
    Send("{d up} {w up}")
    Click("Up")
}
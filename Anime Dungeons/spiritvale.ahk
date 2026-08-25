#Requires AutoHotkey v2.0
Esc::ExitApp
#SingleInstance Force

global isRunning := false
global moveStep := 1
global spellIndex := 1

F8::{
    global spellIndex
    spellIndex := 1
    SetTimer(SpellLoop, 150)
}

; Press F7 to Start / Stop the Macro
F7:: {
    global isRunning, moveStep, spellIndex
    isRunning := !isRunning
    
    if (isRunning) {
        moveStep := 1
        spellIndex := 1
        ToolTip("Macro Started", 100, 100)
        
        ; Start Non-Blocking Spell Loop (Ticks every 150ms)
        SetTimer(SpellLoop, 150)
        
        ; Start Movement Loop
        SetTimer(MovementStep, 10)
    } else {
        ; Stop both loops and release movement keys
        SetTimer(SpellLoop, 0)
        SetTimer(MovementStep, 0)
        ReleaseMovementKeys()
        
        ToolTip("Macro Stopped", 100, 100)
        SetTimer(() => ToolTip(), -1000)
    }
}

; -------------------------------------------------------------
; 1. NON-BLOCKING SPELL LOOP
; -------------------------------------------------------------
SpellLoop() {
    global spellIndex
    
    ; Keep constant toggles held down
    if (!GetKeyState("e"))
        Send("{e down}")

    ; Rotate through actions without using Sleep()
    switch spellIndex {
        case 1: Send("{1}")
        case 3: Send("{XButton1}")
        case 4: Send("{XButton2}")
        case 5: Send("{q}")
        case 7: Send("{r}")
    }
    
    spellIndex := (spellIndex >= 5) ? 1 : spellIndex + 1
}

; -------------------------------------------------------------
; 2. MOVEMENT STATE MACHINE
; -------------------------------------------------------------
SmoothMouseMove(targetX, targetY, stepDelay := 5, totalSteps := 15) {
    MouseGetPos(&startX, &startY)

    Loop totalSteps {
        currentX := startX + (targetX - startX) * (A_Index / totalSteps)
        currentY := startY + (targetY - startY) * (A_Index / totalSteps)
        
        MouseMove(currentX, currentY, 0)
        Sleep(stepDelay)
    }
}

MovementStep() {
    global moveStep

    switch moveStep {
        case 1: ; Hold W and Move Mouse
            Send("{w down}")
            targetX := 950 + Random(-25, 10)
            targetY := 472 + Random(-25, 10)

            SmoothMouseMove(targetX, targetY, 10, 12)
            
            moveStep := 2   
            SetTimer(MovementStep, -Random(6000, 7000))

        case 2: ; Release W
            Send("{w up}")
            moveStep := 3
            SetTimer(MovementStep, -100)  ; Pause 100ms before pressing S

        case 3: ; Hold S and Move Mouse
            Send("{s down}")
            targetX := 950 + Random(-25, 10)
            targetY := 674 + Random(-25, 10)

            SmoothMouseMove(targetX, targetY, 10, 12)
            
            moveStep := 4
            SetTimer(MovementStep, -Random(6000, 7000))

        case 4: ; Release S
            Send("{s up}")
            moveStep := 1
            SetTimer(MovementStep, -100)  ; Pause 100ms before pressing W
    }
}

; Safely release all movement and held keys when stopping
ReleaseMovementKeys() {
    Send("{w up}")
    Send("{s up}")
    Send("{e up}")
    Send("{space up}")
}
#Requires AutoHotkey v2.0
Esc::ExitApp
#SingleInstance Force

global isRunning := false
global moveStep := 1
global spellIndex := 1
global buffIndex := 1

; Press F7 to Start / Stop the Macro
F9:: {
    global isRunning, moveStep, spellIndex
    isRunning := !isRunning

    if (isRunning) {
        SetTimer(SpellLoop, 0)
        SetTimer(MovementStep, 0)
        ReleaseMovementKeys()

        moveStep := 1
        spellIndex := 1
        ToolTip("Macro Started", 100, 100)

        ; Start Non-Blocking Spell Loop (Ticks every 150ms)
        SetTimer(SpellLoop, 150)
	    SetTimer(BuffLoop, 60000) 

        ; Start movement state machine from a clean state
        SetTimer(MovementStep, -10)
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

    ; Rotate through actions without using Sleep()
    switch spellIndex {
        case 1: Send("{1}")
        case 2: Send("{2}")
        case 3: Send("{XButton1}")
        case 4: Send("{XButton2}")
        case 5: Send("{q}")
        case 6: Send("{e}")
        case 7: Send("{r}")
    }

    spellIndex := (spellIndex >= 7) ? 1 : spellIndex + 1
}

BuffLoop() {
    global buffIndex

    ; Rotate through actions without using Sleep()
    switch buffIndex {
        case 1: Send("{3}")
	Sleep(300)
        case 2: Send("{4}")
    }

    buffIndex := (buffIndex >= 2) ? 1 : buffIndex + 1
}

MovementStep() {
    global moveStep, isRunning

    if (!isRunning) {
        return
    }

    switch moveStep {
        case 1: ; Hold W and move mouse
            Send("{a down}")
            moveStep := 2

        case 2: ; Release W
            Send("{a up}")
            Sleep(30000)
            moveStep := 3

        case 3: ; Hold S and move mouse
            Send("{d down}")
            moveStep := 4

        case 4: ; Release S
            Send("{d up}")
            Sleep(30000)
            moveStep := 1
    }

    SetTimer(MovementStep, -100)
}

; Safely release all movement and held keys when stopping
ReleaseMovementKeys() {
    Send("{w up}")
    Send("{s up}")
}
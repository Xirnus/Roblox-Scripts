#Requires AutoHotkey v2.0
#SingleInstance Force

; ===== MINECRAFT-SPECIFIC MOUSE SHAKER =====
#HotIf WinActive("Minecraft")  ; Only works in Minecraft

F10::
{

    ToolTip "Running.."
    Click "Down Left"
    ; Settings - adjust these as needed
    shakeStrength := 80    ; How far to shake (pixels)
    
    ; Calculate timing between movements
    delayBetween := 500
    
    ; Get initial mouse position (for reset later)
    MouseGetPos(&startX, &startY)
    
    ; Perform the shake using relative movements
    Loop
    {
        ; Move right
        DllCall("mouse_event", "UInt", 0x01, "UInt", shakeStrength, "UInt", 0, "UInt", 0, "UPtr", 0)
        Sleep delayBetween
        
        ; Move left
        DllCall("mouse_event", "UInt", 0x01, "UInt", -shakeStrength, "UInt", 0, "UInt", 0, "UPtr", 0)
        Sleep delayBetween

        Click "Up Right"
        Click "Down Right"
    }

}

#HotIf  ; End Minecraft-specific context

Esc::ExitApp
#Requires AutoHotkey v2

F1::{

    if PixelGetColor(500, 477) == 0x023D94 {
        ToolTip("Pan is full")
    } else {
        ToolTip("Pan is not full")
    }
}

F3::{
    WinActivate(RobloxWindow)
    WinMove(0, 0, 800, 600, RobloxWindow)
}

; ensure pixel coords use screen coordinates and mouse too
CoordMode("Pixel", "Screen")
CoordMode("Mouse", "Screen")

panActive := false

F2::{
    ; toggle continuous checking on/off
    global panActive := !panActive
    if panActive
        SetTimer(CheckPan, 150) ; check every 150 ms
    else
        SetTimer(CheckPan, "Off")
}

RobloxWindow := "ahk_exe RobloxPlayerBeta.exe"
PAN_FULL_COORD := {x: 488, y: 306}
PAN_FULL_COLORS := {full: 0x0DD50A, notFull: 0xFEE770}

CheckPan() {
    global PAN_FULL_COORD, PAN_FULL_COLORS, RobloxWindow

    ; make sure the game window is active (optional, helps consistent reads)
    WinActivate(RobloxWindow)
    Sleep 40  ; let the OS bring it forward

    ; read pixel (use "RGB" to be explicit)
    currentColor := PixelGetColor(PAN_FULL_COORD.x, PAN_FULL_COORD.y, "RGB")
    expectedColor := PAN_FULL_COLORS.full

    ; compare with tolerance (per-channel)
    if (ColorCloseEnough(currentColor, expectedColor, 18)) {
        ToolTip("Pan is full")
        Sleep 500
        ToolTip("")
    } else {
        ToolTip("Pan Color: " . Format("0x{:06X}", currentColor))
        SetTimer(() => ToolTip(""), -900)
    }
}

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
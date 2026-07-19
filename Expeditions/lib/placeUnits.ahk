#Requires AutoHotkey v2.0

#Include navigation.ahk

UnitPlacement(unit, position, mode) {
    targetPos := unitMaps[mode][position]
    x := targetPos[1]
    y := targetPos[2]
    
    SafePlacement(unit, x, y)
}

SafePlacement(unit, x, y) {
    ;loop {
        ; Try to place the unit
        MouseMove(x, y)
        Sleep 400
        Send(unit)
        Sleep 400
        BetterClick(x, y)
        Sleep 400

        ; Check for spectate screen to confirm success
        ;if (FindText(&X, &Y, 0, 0, 809, 627, 0, 0, unitplaced)) {
        ;    return true  ; Success
        ;}
    ;}
}
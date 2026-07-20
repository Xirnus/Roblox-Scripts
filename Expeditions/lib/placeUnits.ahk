#Requires AutoHotkey v2.0

#Include navigation.ahk

UnitPlacement(unit, position, mode) {
    targetPos := unitMaps[mode][position]
    x := targetPos[1]
    y := targetPos[2]
    
    SafePlacement(unit, x, y)
}

SafePlacement(unit, x, y) {
    MouseMove(x, y)
    Sleep 1000
    Send(unit)
    Sleep 1000
    BetterClick(x, y)
    Sleep 1000
}

/**
 * Reads coordinates from settings.ini and places a unit.
 * @param unit The hotkey or character to send (e.g., "1", "2", "3")
 * @param section The INI section to read from (e.g., "Slot1", "Slot2", "Senku", "Ramen")
 * @param unitNum The unit index number inside that section (1, 2, or 3)
 * @param mapName The map name (e.g., "School Grounds", "Flower Forest", "Rose Kingdom", "Fairy King Forest", "King's Tomb")
 */
UnitPlacementFromIni(unit, section, unitNum, mapName) {
    iniFile := A_ScriptDir . "\settings.ini"
    
    ; Construct keys matching your script's save format
    xKey := mapName . "_Unit" . unitNum . "_X"
    yKey := mapName . "_Unit" . unitNum . "_Y"
    
    ; Fetch X and Y coordinates with default fallback of 0
    xVal := Integer(IniRead(iniFile, section, xKey, "0"))
    yVal := Integer(IniRead(iniFile, section, yKey, "0"))
    
    ; Safety check: Only execute placement if valid coordinates exist
    if (xVal <= 0 || yVal <= 0) {
        MsgBox("No valid coordinates found for:`nSection: " section "`nMap: " mapName "`nUnit: " unitNum, "Placement Error", "4096 Icon!")
        return
    }
    
    ; Execute unit placement
    SafePlacement(unit, xVal, yVal)
}

/**
 * Loops through slots/units based on settings.ini configurations
 * @param mapName The detected map (e.g., "SchoolGrounds", "FlowerForest")
 */
PlaceUnitsFromIni(mapName) {
    iniFile := A_ScriptDir . "\settings.ini"
    
    slotSequence := [
        ["5", "Senku"],
        ["1", "Slot1"],
        ["6", "Ramen"],
        ["2", "Slot2"],
        ["3", "Slot3"],
        ["4", "Slot4"]
    ]
    
    for item in slotSequence {
        unitHotkey := item[1]
        iniSection := item[2]
        
        ; Set default placement: 3 for Senku, 1 for everything else
        defaultPlacements := (iniSection == "Senku") ? "3" : "1"
        placementCount := Integer(IniRead(iniFile, iniSection, "Placements", defaultPlacements))
        
        Loop placementCount {
            unitNum := A_Index
            if (unitNum > 3)
                break
                
            xKey := mapName . "_Unit" . unitNum . "_X"
            yKey := mapName . "_Unit" . unitNum . "_Y"
            
            xVal := Integer(IniRead(iniFile, iniSection, xKey, "0"))
            yVal := Integer(IniRead(iniFile, iniSection, yKey, "0"))
            
            if (xVal > 0 && yVal > 0) {
                SafePlacement(unitHotkey, xVal, yVal)
                
                if CheckGameState()
                    return true
            }
        }
    }
    return false
}

; Helper for gameplay state interrupts during placement
CheckGameState() {
    global MyGui, Modes, Results
    
    if FindLobby() {
        ChallengeGameplay()
        return true
    } else if FailedRun() {
        VoteStart()
        Sleep(Integer(MyGui["SleepMs"].Value))
        return true
    } 
    else if (modeDDL.Text == "Challenge" && FindText(&X, &Y, 0, 0, 800, 599, 0, 0, Results)) {
        ToolTip("Results Found")
        BetterClick(401, 488)
        Sleep(Integer(MyGui["SleepMs"].Value))
        ToolTip("")
        BetterClick(303, 433)
        Sleep(Integer(MyGui["SleepMs"].Value))
        BetterClick(655, 370)
        Sleep(Integer(MyGui["SleepMs"].Value))
        BetterClick(Modes[3][1], Modes[3][2])
        Sleep(Integer(MyGui["SleepMs"].Value))
        return true
    }
    return false
}
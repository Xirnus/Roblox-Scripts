#Requires AutoHotkey v2.0

#Include navigation.ahk

UnitPlacement(unit, position, mode) {
    targetPos := unitMaps[mode][position]
    x := targetPos[1]
    y := targetPos[2]
    
    SafePlacement(unit, x, y)
}

SafePlacement(unit, x, y) {
    BetterClick(40, 70)
    Sleep 500
    MouseMove(x, y)
    Sleep 500  
    Send(unit)
    Sleep 500
    BetterClick(x, y)
    Sleep 500
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

    runs:= 0
    
    for item in slotSequence {
        unitHotkey := item[1]
        iniSection := item[2]
        
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
                ; --- Dynamic Expedition Coordinate Adjustment ---
                if (modeDDL.Text == "Expedition") {
                    ; Check for Camera Position 1
                    /*
                    if FindText(&X, &Y, 362, 405, 415, 452, 0, 0, ExpeditionsView1) {
                        ; Option A: Apply a offset relative to camera angle 1
                        xVal += 20  ; Adjust offset as needed
                        yVal += 15  
                        
                        ; Option B: Read from a separate custom INI section if you saved specific coords
                        ; xVal := Integer(IniRead(iniFile, iniSection, mapName . "_Cam1_Unit" . unitNum . "_X", xVal))
                        ; yVal := Integer(IniRead(iniFile, iniSection, mapName . "_Cam1_Unit" . unitNum . "_Y", yVal))
                    }
                    */
                    ; Check for Camera Position 2
                    if FindText(&X, &Y, 363, 422, 421, 463, 0, 0, ExpeditionsView2) {
                        ToolTip("Camera Position 2 Detected, Added Offset")
                        yVal -= 15  
                    }
                    else if FindText(&X, &Y, 362, 405, 415, 452, 0, 0, ExpContinueRoseKingdom2) {
                        yVal -= 15  
                    }
                }

                SafePlacement(unitHotkey, xVal, yVal)
                
                if CheckGameState()
                    return true

                runs++
                ToolTip("") 
                if (runs >= 100) {
                    Send("{c down}")
                    Sleep(300)
                    Send("{c up}")
                    webhook()
                    Sleep(300)
                    Send("{c down}")
                    Sleep(300)
                    Send("{c up}")
                    runs := 0
                }
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
    } else if modeDDL.Text != "Challenge" && FindText(&X, &Y, 140, 171, 209, 203, 0, 0, Victory){
        ToolTip("Victory Detected")
        Sleep(2000)
        webhook()
        Sleep(Integer(MyGui["SleepMs"].Value))
        if FindText(&X, &Y, 0, 0, 800, 599, 0, 0, RepeatStage) {
            WinGetClientPos(&clientX, &clientY, , , RobloxWindow)
            
            targetX := X - clientX
            targetY := Y - clientY

            BetterClick(targetX, targetY)
            Sleep(Integer(MyGui["SleepMs"].Value))
        }
    }
    else if modeDDL.Text != "Challenge" && FindText(&X, &Y, 140, 171, 209, 203, 0, 0, Defeat) {
        ToolTip("Defeat Detected")
        Sleep(2000)
        webhook()
        Sleep(Integer(MyGui["SleepMs"].Value))
        if FindText(&X, &Y, 0, 0, 800, 599, 0, 0, RepeatStage) {
            WinGetClientPos(&clientX, &clientY, , , RobloxWindow)
            
            targetX := X - clientX
            targetY := Y - clientY

            BetterClick(targetX, targetY)
            Sleep(Integer(MyGui["SleepMs"].Value))
        }
    }
    else if (modeDDL.Text == "Challenge" && FindText(&X, &Y, 276, 451, 342, 469, 0, 0, ViewParty)) {
        ToolTip("View Party Found")
        Sleep(2000)
        webhook()
        Sleep(Integer(MyGui["SleepMs"].Value))
        ToolTip("")
        WinGetClientPos(&clientX, &clientY, , , RobloxWindow)
        
        targetX := X - clientX
        targetY := Y - clientY

        BetterClick(targetX, targetY)
        Sleep(2000)
        BetterClick(655, 370)
        Sleep(Integer(MyGui["SleepMs"].Value))
        BetterClick(Modes[3][1], Modes[3][2])
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
    else if modeDDL.Text == "Expedition" && FindText(&X, &Y, 0, 0, 800, 599, 0, 0, ExpContinue) {
            WinGetClientPos(&clientX, &clientY, , , RobloxWindow)
            
            targetX := X - clientX
            targetY := Y - clientY

            BetterClick(targetX, targetY)
        Sleep(Integer(MyGui["SleepMs"].Value))
        if FindText(&X, &Y, 0, 0, 800, 599, 0, 0, ExpContinue2) {
            WinGetClientPos(&clientX, &clientY, , , RobloxWindow)
            
            targetX := X - clientX
            targetY := Y - clientY

            BetterClick(targetX, targetY)
            Sleep(Integer(MyGui["SleepMs"].Value))
        }
    }
    else if FindText(&X, &Y, 0, 0, 800, 599, 0, 0, VoteStartBtn) {
        ToolTip("Vote Start Found")
        BetterClickFindText(X, Y)
        Sleep(Integer(MyGui["SleepMs"].Value))
    }
    else if FindText(&X, &Y, 0, 0, 800, 599, 0, 0, CloseBtn) {
        BetterClickFindText(X, Y)
        Sleep(Integer(MyGui["SleepMs"].Value))
    }
    return false
}
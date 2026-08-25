#Requires AutoHotkey v2.0
#Include navigation.ahk


SafePlacement(unit, x, y) {
    BetterClick(40, 70)
    Sleep(300)
    MouseMove(x, y)
    Sleep(300) 
    Send(unit)
    Sleep(300)
    BetterClick(x, y)
    Sleep(300)
}

global placedUnits := []

PlaceUnitsFromIni(mapName) {
    global placedUnits
    iniFile := A_ScriptDir . "\settings.ini"
    PlacementLoop:
    Loop{
        ResetPlacementState()
        
        slotSequence := [
            ["5", "Senku"],
            ["1", "Slot1"],
            ["6", "Ramen"],
            ["2", "Slot2"],
            ["3", "Slot3"],
            ["4", "Slot4"]
        ]

        ; Outer loop: Continues running until ALL valid configured units are placed
        While true {
            totalConfiguredUnits := 0

            for item in slotSequence {
                unitHotkey := item[1]
                iniSection := item[2]
                
                defaultPlacements := (iniSection == "Senku") ? "3" : "1"
                placementCount := Integer(IniRead(iniFile, iniSection, "Placements", defaultPlacements))
                
                Loop Min(placementCount, 3) {
                    unitNum := A_Index
                    unitID := iniSection . "_" . unitNum

                    ; Check INI coordinates
                    xVal := Integer(IniRead(iniFile, iniSection, mapName . "_Unit" . unitNum . "_X", "0"))
                    yVal := Integer(IniRead(iniFile, iniSection, mapName . "_Unit" . unitNum . "_Y", "0"))
                    
                    ; Skip unconfigured slots (won't be counted towards total)
                    if (xVal <= 0 || yVal <= 0)
                        continue

                    ; Track total valid configured units
                    totalConfiguredUnits++

                    ; Skip if already placed
                    if HasBeenPlaced(unitID)
                        continue

                    ; 1. Check game state before placement
                        state := CheckGameState()
                        if (state == "RETRY")
                            continue PlacementLoop
                        else if (state == true)
                            return true

                    ; Handle Mode-Specific Adjustments
                    if (modeDDL.Text == "Expedition") {
                        if FindText(&X, &Y, 363, 422, 421, 463, 0, 0, ExpeditionsView2) || FindText(&X, &Y, 362, 405, 415, 452, 0, 0, ExpContinueRoseKingdom2) {
                            yVal -= 15
                        }
                    }

                    ; 2. Execute Placement
                    SafePlacement(unitHotkey, xVal, yVal)

                    Sleep(500)

                    if (modeDDL.Text != "Expedition") && FindText(&X, &Y, 0, 0, 800, 599, 0, 0, UnitPlaced) {
                        placedUnits.Push(unitID)
                        ToolTip("Placed: " . unitID)
                        Sleep(500)
                        ToolTip("")
                    }
                    
                    ; 3. Check game state after placement
                    state := CheckGameState()
                    if (state == "RETRY")
                        continue PlacementLoop
                    else if (state == true)
                        return true
                }
            }

            ; Exit condition 1: No valid units configured in INI at all
            if (totalConfiguredUnits == 0) {
                ToolTip("No units configured in INI for this map.")
                Sleep(2000)
                ToolTip("")
                return false
            }

            ; Exit condition 2: Every configured unit has been pushed to placedUnits
            if (placedUnits.Length >= totalConfiguredUnits) {
                While true {
                    ToolTip("All configured units placed for this map. Waiting for Results...")
                    state := CheckGameState()
                    if (state == "RETRY")
                        continue PlacementLoop
                    else if (state == true)
                        return true
                    Sleep(1000) ; Prevents high CPU usage while waiting
                }
                return true
            }

            ; Optional small delay between full placement scan passes to prevent CPU thrashing
            Sleep(200)
        }
    }
}

; Helper to check if a unit identifier exists in our tracking list
HasBeenPlaced(unitID) {
    global placedUnits
    for id in placedUnits {
        if (id == unitID)
            return true
    }
    return false
}

; Function to reset tracking when starting a new round
ResetPlacementState() {
    global placedUnits
    placedUnits := [] 
}

CheckGameState() {
    global MyGui, Modes, Results, RobloxWindow
    
    ; Cache sleep duration once per check
    sleepMs := Integer(MyGui["SleepMs"].Value)
    mode := modeDDL.Text

    ; --- PRIORITY 1: LOBBY / END-GAME INTERRUPTS ---
    if FindLobby() {
        StartGameplay()
    }

    ; --- PRIORITY 2: GAMEPLAY OVERLAYS (Start/Close buttons) ---
    if FindText(&X, &Y, 0, 0, 800, 599, 0, 0, VoteStartBtn) {
        ToolTip("Vote Start Found")
        BetterClickFindText(X, Y)
        ToolTip("")
        Sleep(sleepMs)
        return false
    }
    
    if FindText(&X, &Y, 0, 0, 800, 599, 0, 0, CloseBtn) {
        BetterClickFindText(X, Y)
        Sleep(sleepMs)
        return false
    }

    ; --- PRIORITY 3: MODE-SPECIFIC FINISH SCREENS ---
    if (mode == "Challenge") {
        if FindText(&X, &Y, 276, 451, 342, 469, 0, 0, ViewParty) {
            ToolTip("View Party Found")
            Sleep(1500)
            webhook()
            Sleep(sleepMs)
            ToolTip("")
            
            BetterClickFindText(X, Y)
            Sleep(1500)
            BetterClick(655, 370)
            Sleep(sleepMs)
            BetterClick(Modes[3][1], Modes[3][2])
            Sleep(sleepMs)
            return true
        }
        
        if FindText(&X, &Y, 0, 0, 800, 599, 0, 0, Results) {
            ToolTip("Results Found")
            BetterClick(401, 488)
            Sleep(sleepMs)
            ToolTip("")
            BetterClick(303, 433)
            Sleep(sleepMs)
            BetterClick(655, 370)
            Sleep(sleepMs)
            BetterClick(Modes[3][1], Modes[3][2])
            Sleep(sleepMs)
            return true
        }
    } 
    else if (mode == "Expedition") {
        if FindText(&X, &Y, 0, 0, 800, 599, 0, 0, ExpContinue) {
            BetterClickFindText(X, Y)
            Sleep(sleepMs)
            if FindText(&X, &Y, 0, 0, 800, 599, 0, 0, ExpContinue2) {
                BetterClickFindText(X, Y)
                Sleep(sleepMs)
            }
        }
    } 
    else { ; Standard / Story Mode
        if FindText(&X, &Y, 140, 171, 209, 203, 0, 0, Victory) || FindText(&X, &Y, 140, 171, 209, 203, 0, 0, Defeat) {
            ToolTip("Game Over Detected")
            Sleep(1500)
            webhook()
            Sleep(sleepMs)
            if FindText(&X, &Y, 0, 0, 800, 599, 0, 0, RepeatStage) {
                BetterClickFindText(X, Y)
                Sleep(sleepMs)
                return "RETRY"
            }
        }
    }

    return false
}
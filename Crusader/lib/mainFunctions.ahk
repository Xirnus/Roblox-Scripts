BetterClick(x, y) {
    MouseMove(x, y)
    MouseMove(1, 0, , "R")
    Sleep(100)
    MouseClick("Left", -1, 0, , , , "R")
    Sleep(50)
}

UpdateWinCounter() {
    global WinCount, MyGui
    WinCount++
    MyGui["WinText"].Text := "Wins: " . WinCount
}

UpdateLossCounter() {
    global LossCount, MyGui
    LossCount++
    MyGui["LoseText"].Text := "Losses: " . LossCount
}

LookDown() {
    BetterClick(408, 331)
    loop 40 {
        SendInput("{WheelUp}")
        Sleep 50
    }
    Sleep 1000
    MouseGetPos(&x, &y)
    SendInput(Format("{Click {} {} Left}", x, y + 200))
    Sleep 1000
    loop 40 {
        SendInput("{WheelDown}")
        Sleep 50
    }
}

inGamePosition(){
    LookDown()
    Sleep 300
    return true
}

VoteStartClick(){
    if (FindText(&X, &Y, 0, 0, 800, 600, 0, 0, VoteStart)) {
        BetterClick(X, Y)
        Sleep(1300)
        return true
    } else {
        BetterClick(366, 149)
        LogToConsole("VoteStart button not found")
        Sleep(2000)
        return false
    }
}

EndGameCheck(){
    LogToConsole("Waiting for Victory or Defeat screen...")
    Sleep(1000)
    while true {
        if (FindText(&X, &Y, 0, 0, 800, 600, 0, 0, Victory)) {
            LogToConsole("Victory found! Proceeding to next gate...")
            Sleep(500)
            webhook()
            Sleep(500)
            UpdateWinCounter()
            Sleep(1000)
            BetterClick(270, 472)
            Sleep(500)
            return true
        }
        else if (FindText(&X, &Y, 0, 0, 800, 600, 0, 0, Defeat)) {
            LogToConsole("Defeat found! Proceeding to next gate...")
            Sleep(500)
            webhook()
            Sleep(500)
            UpdateLossCounter()
            Sleep(1000)
            BetterClick(270, 472)
            Sleep(500)
            return true
        }
        Sleep(5000)
    }
}

inGameCheck(){
    ;LogToConsole("Looking for Vote Start button...")
    Sleep(1000)
    timeout := 0
    while !(FindText(&X, &Y, 0, 0, 800, 600, 0, 0, UpgManager))
    {
        ;LogToConsole("Vote Start not found, waiting...")
        BetterClick(551, 357)
        Sleep(1000)
        timeout++
        if (timeout > 120) { ; 120 second timeout
            LogToConsole("Timeout waiting for UpgManager")
            Sleep(2000)
            return false
        }
    }
    ;LogToConsole("Vote Start found! Clicking...")
    Sleep(500)
    return true
}

unitsToPlace := [""]
PlaceUnits(unitsToPlace, coordsArray, unitType := "Unit", maxTries := 30) {
    usedCoords := Map()  ; Track which coordinates have been used
    
    Loop unitsToPlace.Length {
        unitNum := unitsToPlace[A_Index]
        placed := false
        
        LogToConsole("Attempting to place " unitType " " A_Index "/" unitsToPlace.Length ": " unitNum)
        
        for coordIndex, coords in coordsArray {
            ; Skip coordinates that have already been used
            if usedCoords.Has(coordIndex)
                continue
                
            tries := 0
            while (tries < maxTries) {
                tries++
                LogToConsole("Placing " unitType ": " unitNum " at (" coords[1] "," coords[2] ") - Try " tries "/" maxTries)
                Send(unitNum)
                Sleep(100)
                BetterClick(coords[1], coords[2])
                Sleep(800)
                if (FindText(&X, &Y, 0, 0, 816, 638, 0, 0, UnitPlaced)) {
                    LogToConsole(unitType " placed successfully at (" coords[1] "," coords[2] ")!")
                    Sleep(300)
                    BetterClick(100,100)
                    usedCoords[coordIndex] := true  ; Mark this coordinate as used
                    placed := true
                    break  ; Break out of tries loop
                } 
            }
            if (placed)  ; If placed successfully, break out of coordinates loop
                break
        }
        
        if (!placed) {
            LogToConsole("Failed to place " unitType ": " unitNum " after trying all available coordinates")
        }
    }
}

resetPosition(){
    BetterClick(37, 601) ; click Options Button
    Sleep(500)
    BetterClick(426, 358) ; click Reset Position

    ; Try to find the Reset button, scroll if not found, then check again
    if (!FindText(&X, &Y, 0, 0, 800, 600, 0, 0, ResetButton)) {
        Loop 10 {
            Send("{WheelUp}")
            Sleep(50)
        }
        Loop 4 {
            Send("{WheelDown}")
            Sleep(50)
        }
        Sleep(200)
        ; Check again after scrolling
        if (FindText(&X, &Y, 0, 0, 800, 600, 0, 0, ResetButton)) {
            BetterClick(X+ 247, Y)
            Sleep(200)
        } else {
            LogToConsole("Reset button not found after scrolling!")
        }
    } else {
        BetterClick(X+ 247, Y)
        Sleep(200)
    }
    Sleep(500)
    BetterClick(603, 155) ; Close Options
    Sleep(500)
}

clicks(){
    Sleep(500)
    BetterClick(551, 357)
    Sleep(500)
    BetterClick(496, 102)
}
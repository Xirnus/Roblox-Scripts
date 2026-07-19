#Include fixpos.ahk

upg0:="|<upg0>*78$69.zzzzzzzzzzzywzzzzznzklVXbzzzzwTyA6AQzzzzzXjlYNXY3010UES8nAQUM08421l6NnYE86840CMnCMW10l0U3n4NkA3070UESQ7D3Uw5w633nktzwTNzzzzyTzDznsDzzzzszVzyzbzzzzz7yTzzzzzzzzzzzzzzzzzzzzzzw"
upg1:="|<upg1>*75$16.zzzzzsN3X2C8AsUnXXCCQttnbbCSQtznVwD7tzzzU"
upg2:="|<upg2>*84$18.zzzzzzVX3X1Xa8naMnbsnbVnb3na0nb0nrznlz3lzbzzzU"
upg3:="|<upg3>*86$17.zzz366A6At6NwAnstbsnANaQ3CwCRzwszVlzbzzy"
upg4:="|<upg4>*77$19.zzzzzzw9cSAWD6FbW8nl0NtUAws6STXDDvbbznszVwTtzzzw"
upg5:="|<upg5>*84$16.zzy40MkFbDaMSNUNb1aRaNUNb3bTyQTVlzDzzs"
upg6:="|<upg6>*86$17.zzz3W6C6AsyNnwn1ta1nAHaQ7CwSRzwszVlzbzzy"
upg7:="|<upg7>*84$17.zzz02682AyCNwQnttbXnDDaQTAxyRzwszVlzbzzy"
upg8:="|<upg8>*87$17.zzz366A6AtCNkQnUta8nAFaQ7CwSRzwszVlzbzzy"
upg9:="|<upg9>*86$17.zzz366A6AlCNUQnUtbtnDXaQDCsyRzwszVlzbzzy"
upg10:="|<upg10>*88$20.zzzkvX0MkMAAX32AkwbAD8n3n8mwkQjC7/zzmDzkXzyTzzy"
maxupg:="|<maxUpg>*85$41.zzzzzzzzzzzzzz2zDTTEy8wQQQFwkkswFntUVUw7bn039wTDa8Y1kSTAP834QyMy3UQtyvwDZxnxzzzzzbszzzzwDlzzzzwzzzzzzzzzzzzzzs"

Text:="|<failedScreen>*151$57.zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzztnzzz7s0Tz6Dzzsz03zslzzz7s0TzyDzzsz7zzzlzTz7szk36D0S0z0A0Mlk3U7s1U36CC80z0AQMlll77szXX6C0Msz7wMMllz67szU3666M0z7y0Mks3U7tzsXD7US8zzzzzzzzzzzzzzzzzzzzzzzzzzzzzU"
Text:="|<returnToLobby>*120$61.0000000000000A0C0SS0000D0DUBhU7zyAz4lwwzzzzqTuPySTzUES4DDV11AkM7U3bU00GMQnmNnn338ECNs0sA08C87AyEw2447Dzzzzzzzzzbzzzzzzzzzbzzzzzzzzzzzzzzzzzzzzs"

retry := 402, 474
global coords := [
    Map( ; namek
        "Slot1", [[381, 127]], ;[485, 127], [296, 122]],
        "Slot2", [[285, 375], [234, 177], [545, 118]],
        "Slot3", [[352, 151]], ;[450, 149], [250, 117]],
        "Slot4", [[190, 258], [367, 255], [520, 248]],
        "taka", [[179, 127]],
        "speed", [[666, 111], [665, 170], [573, 265]]
    ),
]

PlaceUnits(slotName, unitKey := "", maxTries := 25) {
    if (unitKey == "")
        unitKey := slotName
    
    if (!coords[1].Has(unitKey)) {
        MsgBox "Coordinate not found for: " unitKey
        return false
    }
    
    positions := coords[1][unitKey]
    tries := 0
    
    Loop positions.Length {
        x := positions[A_Index][1]
        y := positions[A_Index][2]
        
        ; Attempt placement
        Send("q")
        Sleep 150
        Sleep (SearchDelay / 2)
        BetterClick(x, y)
        Send(slotName)
        Sleep (SearchDelay / 2)
        BetterClick(x, y)
        Sleep(searchDelay)
        
        if (!checkPlacement()) {
            nullClick()
            BetterClick(100, 100)
            tries++
            if (tries >= maxTries) {
                return false ; Hard exit after max attempts
            }
            A_Index-- ; Retry the same position
        }
    }
    
    return true
}
; Example usage:
; PlaceUnits("1", "Slot1")  ; Place Slot1 unit in position 1
; PlaceUnits("2", "Slot2")  ; Place Slot2 unit in position 2
; PlaceUnits("3")           ; Place Slot3 unit (uses "Slot3" as both slot and coordinate key)
; PlaceUnits("4", "speed")  ; Place speed unit in position 4
; PlaceUnits("5", "taka")   ; Place taka unit in position 5

checkPlacement() {
    placementCheck := FindText(&X, &Y, 8, 31, 809, 627, 0, 0, upg0)
    if (placementCheck) {
        return true
    } else {
        return false
    }
}

upgradePatterns := Map(
    "0", upg0,
    "1", upg1,
    "2", upg2,
    "3", upg3,
    "4", upg4,
    "5", upg5,
    "6", upg6,
    "7", upg7,
    "8", upg8,
    "9", upg9,
    "10", upg10,
    "max", maxUpg
)


upgradeUnit(slotName, unitKey := "", upg := "max") {
    global upgradePatterns
    
    ; Default to maxUpg if no specific upgrade level is provided
    upgPattern := upgradePatterns[upg]


    if (unitKey == "") {
        unitKey := slotName
    }
    
    if (!coords[1].Has(unitKey)) {
        MsgBox "Coordinate not found for: " unitKey
        return false
    }

    Send("q") ; Switch to building mode (if needed)
    
    positions := coords[1][unitKey]
    
    Loop positions.Length {
        x := positions[A_Index][1]
        y := positions[A_Index][2]

        ; Click the unit
        BetterClick(x, y)

        ; Wait until the specified upgrade level is found
        while (!FindText(&X, &Y, 8, 31, 809, 627, 0, 0, upgPattern)) {
            Sleep(1000)
            Send("t") ; Press 't' to attempt upgrade
            if FindText(&X, &Y, 8, 31, 809, 627, 0, 0, upgPattern) {
                break ; Exit loop if upgrade is found
            }
        }

        ; Optional: Add a small delay before moving to next position
        Sleep(500)
    }
    
    return true
}
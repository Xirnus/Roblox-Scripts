#Requires AutoHotkey v2.0
#Include FindText.ahk
#Include placeUnits.ahk
Esc::ExitApp  ; Exit script with Escape key
global PortalDone := "|<PortalDone>*73$134.zzzzzzzzzzzzzzzzzzzzzzyDzzzzzznztzznzzzzwzzzy0TzzyTzwTs3zwTzzyT7zzzU3zzzXzz7w0zz7zzzXnzzzs0Tzzszzlz2Dzlzzzszzzzy671mA3zwTlzkQS3sQ3D1zzXlUA20w17wDs370Q20lUA1sME00UC01z0Q0FU20UAE1060481w300Tw134MMXA34801U270TXlU7zk01600zXl70A81Vk7ssQ1zz00lU4DswFk727w81yD60Tll3wMPXSD481kXz04TUk03w0E320M3Ul04Q8zs37sC0Ez0C0Ek30sAM372Dz1nz3k6Dw7kCC1sT3D1ltzzzzzzzzzzzzzzzzzzzzzzs"

; Define all portal images
portals := Map(
    "TowerLimit", "|<>*104$50.zzzzzwzbw3zzzbzzTnzzztnyHwl026Q00T980bb01TmK09tkYHwloWS6d4zzzzzzzzy",
    "ShortRange", "|<PortalShortRange>*111$53.zzzzzzzzzzDzzzzzzzWTzrVzzzy4Dzj1zzzwMMU6G8MlyGYCw9GZ/mZ+Rt0Y27lv4tnF/6Dzzzzzzyjzzzzzzzyzzzzzzzzzzk", ; changed
    "Barebones", "|<PortalBarebones>*109$44.zzzzzzzzzztzzzy7zyTzzzUzzVzzzt808MVWCEd2IVEXY2EV+EAMMaAMZXDzzzzzzzU", ; changed
    "NoHit", "|<PortalNoHit>*111$27.zzzzzzzyTaznSwHyOLWFkEA4a2LYZnGQqCPHzzzzw",
    "Immunity", "|<PortalImmunity>*111$38.zzzzzzzzzzyTyTzzzxzbzzztTs00420a00125XV8Y0V8tG9F/HTzzzzzbzzzzzzzzzzzzy",
    "Speedy", "|<PortalSpeedy>*112$32.zzzzzzzzzzzzzzxzlzzzDsTzz3yAAMk9t+IdMtEV36D4QMlrzDzzxzzzzzzzzzzzU" ; changed

)

; Portal priority list (high to low)
portalPriority := ["NoHit", "Immunity", "TowerLimit", "ShortRange", "Speedy", "Barebones"]

; Fixed portal coordinates
portalCoords := [
    {x: 213, y: 333},  ; Portal 1
    {x: 416, y: 335},  ; Portal 2
    {x: 555, y: 328}   ; Portal 3
]

RobloxWindow := "ahk_exe RobloxPlayerBeta.exe"

; --- MAIN HOTKEY ---
F6:: {
    if WinExist(RobloxWindow) {
        WinActivate(RobloxWindow)
        Sleep(50)
        WinMove(0, 0, 800, 600, RobloxWindow)
        DemonSkullGameplay()
        ToolTip "Waiting for map to finish...", 10, 10
        while (!FindText(&X, &Y, 8, 31, 809, 627, 0, 0, PortalDone)) {
            Sleep(500)
        }
        ToolTip "Map complete. Checking portals...", 10, 10
        availablePortals := DetectAvailablePortals()
        SelectBestPortal(availablePortals)
        Sleep(500)
        GotoNextPortal()
    }
}

F5::{
    if WinExist(RobloxWindow) {
        WinActivate(RobloxWindow)
        GotoNextPortal() 
    }
}
; --- DETECT AVAILABLE PORTALS ---
DetectAvailablePortals() {
    available := Map()
    for index, coord in portalCoords {
        ; Click the reward to open the tooltip or selection
        Sleep (1000)
        BetterClick(coord.x, coord.y)
        Sleep(1000)  ; Wait for tooltip/modifier to appear

        for portalName, needle in portals {
            if (FindText(&X, &Y,  8, 31, 809, 627, 0, 0, needle)) {
                available[portalName] := {x: coord.x, y: coord.y, index: index, name: portalName}
                break  ; Stop checking once a match is found
            }
        }
    }
    return available
}

SelectBestPortal(availablePortals) {
    bestPortal := ""
    bestPriority := portalPriority.Length + 1

    for portalName, portalData in availablePortals {
        currentPriority := 0
        for i, name in portalPriority {
            if (name = portalName) {
                currentPriority := i
                break
            }
        }

        if (currentPriority > 0 && currentPriority < bestPriority) {
            bestPriority := currentPriority
            bestPortal := portalData
        }
    }

    if (bestPortal != "") {
        ToolTip "Selecting best portal: " bestPortal.name " (Portal " bestPortal.index ")", 10, 10
        BetterClick(bestPortal.x, bestPortal.y)
        ToolTip "Selected portal: " bestPortal.name " (Portal " bestPortal.index ")"
        Sleep(300)
        BetterClick(410, 445) ; Confirm Selected Portal
    } else {
        MsgBox "No known portals detected!"
    }
}

GotoNextPortal() {
    Sleep 500
    BetterClick(394, 425) ; Click View Portal
    Sleep 500
    BetterClick(292, 203) ; Click Search
    Sleep 500
    Send("demon")
    Sleep 500

    initialX := 250  ; Starting X coordinate
    y := 268         ; Y coordinate stays the same
    offset := 70

    available := Map()

    Loop 5 {
        x := initialX + ((A_Index - 1) * offset)
        Sleep 1000
        BetterClick(x, y)
        Sleep 1000

        for portalName, needle in portals {
            if (FindText(&X, &Y, 8, 31, 809, 627, 0, 0, needle)) {
                available[portalName] := {x: x, y: y, index: A_Index, name: portalName}
                break
            }
        }
    }

    SelectBestPortal(available)
}


global unitMaps := Map(
    "DemonSkullPortal",Map(
        1, [532, 380],
        2, [598, 297],
        3, [453, 371],
        4, [481, 459],
        5, [442, 452],
        6, [406, 350]
    )
)
DemonSkullGameplay(){
    LookDown()
    sleep 400
    VoteStart()
    UnitPlacement(5, 1, "DemonSkullPortal")
    UnitPlacement(3, 2, "DemonSkullPortal")
    UnitPlacement(6, 3, "DemonSkullPortal")
    UnitPlacement(1, 4, "DemonSkullPortal")
    UnitPlacement(2, 5, "DemonSkullPortal")
    UnitPlacement(4, 6, "DemonSkullPortal")
    Sleep(400)
    ClickUpg()
    Results()
    Sleep 1000
}
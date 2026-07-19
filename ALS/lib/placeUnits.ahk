#Include FindText.ahk
#Include mainfunctions.ahk
#Include gui.ahk



; Global variables and image patterns
global priorityButton := "|<firstButton>*117$27.zzzzzzzzzzvzzy0TzDk/zty3Ty7kG0Ey2F7DnmQNySHV7vvQQzzzzzzzzzzzzzzU"
global spectate := "|<spectate>*52$33.zzzzzyTzzzzVzzTjwFWF0Xk0200Q00O13kAH8UTnzzzzyzzzzw"
global win:="|<win>*105$34.zzzbzz7XkDzwCC1zzskMzzzX1WN7y44MU7w01W0Tk868lzUUsXXy73WCDsQC8szllsXXzDbaSTzzzzzs"
global gameResult:="|<gameResult>*138$58.zzzzzzzzzz3kCCwrk3Xs20kFmD0A7W8yD78zbXyAXwQQXyT7s21kFmDtw7U87kb8zbwC0XxWMXyTMsm0UM61ts7rA31kw3bkTzzzzzzzzzzzzzzzzzzzU"
global lobbycheck:="|<LobbyCheck>*139$36.zs3y3zzw3v3zw7nnzzs7znzztyD3X7nw6313ntYG97ttYm33s46333w6D313zzzzzzzzzzzzU"
global FindUnitManager:="|<UnitManager>*124$56.zzzzzzzzztjmwtzzzzyNzj4Tzzzza11k40kX49V2w0EV2VD2EbC0808HkY9nYGFX4zzzzzzzszzzzzzzzyTzzzzzzzzzzs"
global gameResult:="|<GameplayResults>*136$57.zzzzzzzzzy7UQRtjU77U83178w0kQF7lMt7wwLX8T778zblw10s8t7wy3U87kb8zbwA17v4l7wylX821UM3bUStUMC7UQy3zzzzzzzzzzzzzzzzzzzzzzzzzzzzw"


; Upgrade button coordinates
global upgButton := [
    [616, 221], [697, 216], [778,215], 
    [618, 326], [697, 328], [777, 331]
]

global sjwUpgButton := [
    [621, 444],
    [701, 443],
    [775, 438],
    [696, 554]
]

; Unit position maps for different modes
global unitMaps := Map(
    "RR", Map(
	1, [469, 302],
	2, [493, 363],
	3, [466, 372],
	4, [494, 335],
	5, [427, 319],
	6, [427, 280]
    ),
    "Cavern", Map(
        1, [345, 333], ; farm 1
        2, [350, 366], ; dps
        3, [398, 363], ; farm 2
        4, [405, 291], ; dps
        5, [315, 291], ; dps
        6, [307, 335]  ; dps
    ),
    "Boost", Map(
        1,    [220, 564], ; farm 1
        2,    [156, 601], ; dps
        3,    [186, 530], ; farm 2
        4,    [188, 487], ; dps
        5,    [294, 506], ; dps
        6,    [114, 598]  ; dps
    ),

    "InfernalDungeon", Map(
        1,    [225, 234],
        2,    [209, 258],
        3,    [363, 154],
        4,    [326, 255],
        5,    [609, 390],
        6,    [288, 445]
    ),
    "LegendBeni", Map(
        1, [423, 174],
        2, [413, 99],
        3, [445, 154],
        4, [453, 198],
        5, [515, 204],
        6, [524, 141]
        ),

	"SJWDungeon", Map(
        1, [340, 140],
        2, [352, 489],
        3, [664, 242],
        4, [633, 461],
        5, [388, 367],
        6, [605, 247]
        ),

	"BossRush", Map(
        1, [223, 468],
        2, [277, 345],
        3, [288, 452],
        4, [247, 355],
        5, [298, 396],
        6, [272, 478]
        ),

	"OPMSurvival",Map(
        1, [489, 349],
        2, [553, 333],
        3, [441, 355],
        4, [524, 319],
        5, [463, 396],
        6, [409, 354]
        ),

    "EasterEvent",Map(
        1, [427, 334],
        2, [420, 391],
        3, [460, 336],
        4, [410, 298],
        5, [351, 295],
        6, [348, 336]
    ),
    "BlackCloverLegend", Map(
	1, [451, 274],
	2, [477, 285],
	3, [408, 323],
	4, [391, 272],
	5, [266, 331],
	6, [246, 359]
    ),
)
UnitPlacement(unit, position, mode) {
    targetPos := unitMaps[mode][position]
    x := targetPos[1]
    y := targetPos[2]
    
    SafePlacement(unit, x, y)
}

SafePlacement(unit, x, y) {
    loop {
        ; Detect early game reset
        if (CheckEarlyGameReset()) {
            return false  ; Tell the caller that we failed due to early reset
        }

        ; Try to place the unit
        Send(unit)
        Sleep 400
        BetterClick(x, y)
        Sleep 400

        ; Check for spectate screen to confirm success
        if (FindText(&X, &Y, 8, 31, 809, 627, 0, 0, spectate)) {
            return true  ; Success
        }
    }
}


CheckEarlyGameReset() {
    return FindText(&X, &Y, 0, 0, 816, 638, 0, 0, gameResult)
}

ClickUpg() {
    Send("f")
    Sleep 1000
    for i, coord in upgButton {
        BetterClick(coord[1], coord[2])
        Sleep(400)
    }
    Send("f")
}

ClickSjwUpg() {
    Send("f")
    Sleep 1000
    for i, coord in sjwUpgButton {
        BetterClick(coord[1], coord[2])
        Sleep(400)
    }
    Send("f")
}

CavernPosFix() {
    Loop 8 {
        Send("{d down}")
        Sleep(500)
        Send("{d up}")
        Sleep(100)
    }
    Loop 5 {
        Send("{s down}")
        Sleep(500)
        Send("{s up}")
        Sleep(100)
    }
    Loop 5 {
        Send("{d down}")
        Sleep(500)
        Send("{d up}")
        Sleep(100)
    }
}

InfernalDungeonPosFix() {
    Loop 5 {
        Send("{w down}")
        Sleep(500)
        Send("{w up}")
        Sleep(100)
    }
    Loop 10 {
        Send("{a down}")
        Sleep(500)
        Send("{a up}")
        Sleep(100)
    }
    Loop 4 {
        Send("{s down}")
        Sleep(500)
        Send("{s up}")
        Sleep(100)
    }
    Loop 3 {
        Send("{a down}")
        Sleep(485)
        Send("{a up}")
        Sleep(100)
    }
}

SJWDungeonPosFix(){
    Loop 1 {
        Send("{d down}")
        Sleep(1000)
        Send("{d up}")
        Sleep(100)
    }
    Loop 14 {
        Send("{w down}")
        Sleep(850)
        Send("{w up}")
        Sleep(100)
    }
}

; Gameplay modes
RRGameplay() {
    Ingame()
    UnitPlacement(5, 1, "RR")
    UnitPlacement(3, 2, "RR")
    UnitPlacement(2, 3, "RR")
    UnitPlacement(6, 4, "RR")
    UnitPlacement(4, 5, "RR")
    UnitPlacement(1, 6, "RR")
    Sleep(400)
    ClickUpg()
    Sleep(1000)

    if (!Results()) {
        return false  ; Early exit — bubble it up to main loop
    }

    Sleep 1000
    return true
}

CavernGameplay() {
    Ingame()
    LookDown()
    CavernPosFix()
    sleep 400
    VoteStart()
    UnitPlacement(5, 1, "Cavern")
    UnitPlacement(6, 2, "Cavern")
    UnitPlacement(4, 3, "Cavern")
    UnitPlacement(3, 4, "Cavern")
    UnitPlacement(2, 5, "Cavern")
    UnitPlacement(1, 6, "Cavern")
    Sleep(400)
    ClickUpg()
    Sleep(1000)

    if (!Results()) {
        return false  ; Early exit — bubble it up to main loop
    }

    Sleep 1000
    return true
}

BoostGameplay() {
    Ingame()
    LookDown()
    sleep 400
    VoteStart()
    UnitPlacement(5, 1, "Boost")
    UnitPlacement(2, 2, "Boost")
    UnitPlacement(6, 3, "Boost")
    UnitPlacement(1, 4, "Boost")
    UnitPlacement(3, 5, "Boost")
    UnitPlacement(4, 6, "Boost")
    Sleep(400)
    ClickUpg()
    Sleep(15000)
    ClickSjwUpg()

    if (!Results()) {
        return false  ; Early exit — bubble it up to main loop
    }

    Sleep 1000
    return true
}

InfernalDungeonGameplay() {
    Ingame()
    LookDown()
    sleep 400
    InfernalDungeonPosFix()
    VoteStart()
    while (!FindText(&X, &Y, 8, 31, 809, 627, 0, 0, gameResult)) {
		UnitPlacement(5, 1, "InfernalDungeon")
		UnitPlacement(1, 2, "InfernalDungeon")
		UnitPlacement(6, 3, "InfernalDungeon")
		UnitPlacement(3, 4, "InfernalDungeon")
		UnitPlacement(2, 5, "InfernalDungeon")
		UnitPlacement(4, 6, "InfernalDungeon")
		Sleep(400)
    		ClickUpg()
	}

    if (!Results()) {
        return false  ; Early exit — bubble it up to main loop
    }
    return true
}

LegendBeni(){
    Ingame()
    UnitPlacement(5, 1, "LegendBeni")
    UnitPlacement(1, 2, "LegendBeni")
    UnitPlacement(6, 3, "LegendBeni")
    UnitPlacement(3, 4, "LegendBeni")
    UnitPlacement(2, 5, "LegendBeni")
    UnitPlacement(4, 6, "LegendBeni")
    Sleep(400)
    ClickUpg()

    if (!Results(1)) {
        return false  ; Early exit — bubble it up to main loop
    }

    Sleep 1000
    return true
}

SJWDungeonGameplay() {
    Ingame()
    LookDown()
    sleep 400
    SJWDungeonPosFix()
    VoteStart()
    while (!FindText(&X, &Y, 8, 31, 809, 627, 0, 0, win)) {
		UnitPlacement(5, 1, "SJWDungeon")
		UnitPlacement(2, 2, "SJWDungeon")
		UnitPlacement(6, 3, "SJWDungeon")
		UnitPlacement(1, 4, "SJWDungeon")
		UnitPlacement(3, 5, "SJWDungeon")
		UnitPlacement(4, 6, "SJWDungeon")
		Sleep(400)
    		ClickUpg()
		Sleep 3000
	}

    if (!Results()) {
        return false  ; Early exit — bubble it up to main loop
    }

    Sleep 1000
    return true
}

BossRushGameplay() {
    Ingame()
    LookDown()
    sleep 400
    VoteStart()
    UnitPlacement(5, 1, "BossRush")
    UnitPlacement(2, 2, "BossRush")
    UnitPlacement(6, 3, "BossRush")
    UnitPlacement(1, 4, "BossRush")
    UnitPlacement(3, 5, "BossRush")
    UnitPlacement(4, 6, "BossRush")
    Sleep(400)
    ClickUpg()

    if (!Results()) {
        return false  ; Early exit — bubble it up to main loop
    }

    Sleep 1000
    return true
}

OPMSurvivalGameplay() {
    Ingame()
    UnitPlacement(5, 1, "OPMSurvival")
    UnitPlacement(2, 2, "OPMSurvival")
    UnitPlacement(6, 3, "OPMSurvival")
    UnitPlacement(1, 4, "OPMSurvival")
    UnitPlacement(3, 5, "OPMSurvival")
    UnitPlacement(4, 6, "OPMSurvival")
    Sleep(400)
    ClickUpg()

    if (!Results()) {
        return false  ; Early exit — bubble it up to main loop
    }

    Sleep 1000
    return true
}


EasterEventGameplay(){
    Ingame()
    LookDown()
    sleep 400
    VoteStart()
    UnitPlacement(5, 1, "EasterEvent")
    UnitPlacement(3, 2, "EasterEvent")
    UnitPlacement(6, 3, "EasterEvent")
    UnitPlacement(1, 4, "EasterEvent")
    UnitPlacement(2, 5, "EasterEvent")
    UnitPlacement(4, 6, "EasterEvent")
    Sleep(400)
    ClickUpg()

    if (!Results()) {
        return false  ; Early exit — bubble it up to main loop
    }

    Sleep 1000
    return true
}

BlackCloverLegendGameplay() {
    Ingame()
    LookDown()
    sleep 400
    VoteStart()
    UnitPlacement(5, 1, "BlackCloverLegend")
    UnitPlacement(3, 2, "BlackCloverLegend")
    UnitPlacement(6, 3, "BlackCloverLegend")
    UnitPlacement(4, 4, "BlackCloverLegend")
    UnitPlacement(2, 5, "BlackCloverLegend")
    UnitPlacement(1, 6, "BlackCloverLegend")
    Sleep(400)
    ClickUpg()

    if (!Results()) {
        return false  ; Early exit — bubble it up to main loop
    }

    Sleep 1000
    return true
}


#Requires AutoHotkey v2.0

#Include mainfunctions.ahk
#Include gui.ahk
#Include placeUnits.ahk

Lobby:="|<Lobby>*109$33.zzzzzzXzzzzs9zzzzC4MXzwE00Dzt931zs90MTzX4HVzzzzzzzzzzzzzzzzzw"
ingame:="|<IngameCheck>*119$25.ByLb6Tvl30Us1dGw2YVCR6IbCU"


;Maps
SchoolGrounds:="|<SchoolGrounds>*115$63.syTznVzzztyS0lWNsWEA8MaEV3B9248Tkm48Nd8EVAkkGAHVAM4U4" ;ok
FlowerForest:="|<FlowerForest>*133$53.6zzzyDzzux5h6RsmAUMZ4hsYdHfl99vr9HtLcmMrj6l6E" 
RoseKingdom:="|<RoseKingdom>*114$15.zzzzz7zyX41399VYEbzzzzw" ;ok
FairyKingForest:="|<Fairy>*102$20.zwzkTzwwE43Y9HV34sEnzzszzzS" ;ok
KingsTomb:="|<Tomb>*112$21.U00rw0DUzzDMU8OEZ/G4dP4Z1zzzU" ;ok

Results:="|<GameResults>*121$51.s001w01y0U04Eo89N7zzu3zz/wl0lmF4U8YcIi4cY/2V+1m1U1A69KCG8ld4"
StageConfirm:="|<SelectStage>*123$55.DVs0QTs00CMY0DQy00C7nzww9zzyS9XYAsMl7X0kW748EVw0E7bt920m18EnYY00wMG4Msl24DzzzzzzzHzzzzzzzzXy"




global Modes := [
    [462, 102], ;Story
    [684, 102], ;Raid
    [462, 200], ;Challenge
    [695, 200]  ;Expedition
]

global ExpeditionMaps := Map(
    "School Grounds", [110, 227],
    "Flower Forest", [110, 277],
    "Rose Kingdom", [110, 325]
)

global StoryStages := [
    [172, 199], ;1
    [172, 238], ;2
    [172, 275], ;3
    [172, 315], ;4
    [172, 350], ;5
    [172. 392], ;Infinite
    [172, 428]  ;Mastery
]

global ChallengeStages := [
    [488, 238], ;1 RR
    [488, 320], ;2 STAT
    [488, 410]  ;3 EVO ITEMS
]

global unitMaps := Map(
    "Gem Farm", Map(
	1, [191, 425],
	2, [287, 439],
	3, [371, 428],
    4, [524, 345],
	5, [407, 198],
	6, [379, 64],
	7, [421, 59],
    8, [408, 105] 
    ),
    "Expedition", Map(
    1, [365, 302], ;unit 1
    2, [378, 106], ;farm 1
    3, [328, 138], ;farm 2
    4, [371, 267], ;unit 2
    5, [425, 286], ;unit 3
    6, [302, 281]  ;unit 4
    ),
    "SchoolGrounds", Map(
    1, [482, 389], ;farm 1
    2, [497, 344], ;farm 2
    3, [515, 18], ;unit 1
    4, [513, 262], ;farm 3
    5, [513, 183], ;farm 4
    6, [425, 325], ;dps 2
    7, [440, 301],  ;dps 3
    8, [411, 354]  ;dps 3
    ),
    "KingsTomb", Map(
	1, [191, 425],
	2, [287, 439],
	3, [407, 198],
    4, [524, 345],
	5, [371, 428],
	6, [379, 64],
	7, [421, 59],
    8, [408, 105] 
    ),
    "FairyKingForest", Map(
	1, [364, 356],
	2, [402, 353],
	3, [652, 167],
    4, [395, 339],
	5, [441, 331],
    6, [295, 97],
	7, [300, 166],
    8, [315, 166] 
    ),
    "FlowerForest", Map(
	1, [325, 229],
	2, [367, 227],
	3, [297, 587],
    4, [373, 270],
    5, [412, 216],
	6, [320, 401],
	7, [363, 397],
    8, [400, 392] 
    ),
    "RoseKingdom", Map(
	1, [516, 486],
	2, [512, 452],
	3, [399, 515],
    4, [554, 484],
    5, [562, 437],
	6, [401, 252],
	7, [437, 249],
    8, [474, 255] 
    )
)

ClickPlay(){
    WinActivate(RobloxWindow)
    BetterClick(100,100)
    Sleep(3000)
    FindLobby()
    Sleep(3000)
    BetterClick(70, 372)
    ToolTip("")
    Sleep(3000)
}

; GEM FARM
GemFarmGameplay(){
    ClickPlay()
    BetterClick(Modes[1][1], Modes[1][2])
    Sleep(2000)
    BetterClick(130,183)
    Sleep(2000)
    Send "{WheelDown 5}"
    Sleep(2000)
    BetterClick(690, 328)
    Sleep(2000)
    BetterClick(StoryStages[7][1], StoryStages[7][2])
    Sleep(2000)
    BetterClick(262, 430)
    Sleep(2000)
    BetterClick(474, 388)
    Sleep(2000)
    GemFarmRun()
}

GemFarmRun(){
    global wheeldownCount := 15
    while true {
        if IngameCheck() {
            Sleep(1000)
            LookDown()
            Sleep(1000)
            break
        }
        Sleep(1000)
    }
    Sleep(1000)
    steps := [
        [5, 1],
        [5, 2],
        [5, 3],
        [6, 4],
        [1, 5],
        [2, 6],
        [3, 7],
        [4, 8]
    ]

    while true {
        for step in steps {
            UnitPlacement(step[1], step[2], "Gem Farm")
            if FindLobby() {
                GemFarmGameplay()
                return
            }
            Sleep(100)
        }
    }
}

; END GEM FARM


;EXPEDITION 

ExpeditionGameplay() {
    global ExpeditionMaps
    ClickPlay()
    BetterClick(Modes[4][1], Modes[4][2])
    Sleep(2000)
    mapPos := ExpeditionMaps[MyGui["ExpeditionMap"].Text]
    BetterClick(mapPos[1], mapPos[2])
    BetterClick(759, 391)
    Sleep(1000)
    BetterClick(759, 391)
    Sleep(1000)
    BetterClick(759, 391)
    Sleep(2000)
    BetterClick(723, 526)
    Sleep(2000)
    BetterClick(479, 365)
    ExpeditionRun()
}

ExpeditionRun(){
    global wheeldownCount := 10
    while true {
        if IngameCheck() {
            Sleep(1000)
            LookDown()
            Sleep(1000)
            break
        }
        Sleep(1000)
    }
    UnitPlacement(1, 1, "Expedition")
    BetterClick(417, 491)
    Sleep(1000)
    BetterClick(348, 329)
    steps := [
        [1, 1],
        [5, 2],
        [6, 3],
        [2, 4],
        [3, 5],
        [4, 6]
    ]
    Sleep(1000)
    while true {
        for step in steps {
            UnitPlacement(step[1], step[2], "Expedition")
            BetterClick(417, 491)
            Sleep(1000)
            BetterClick(348, 329)
            Sleep(1000)
            if FindLobby() {
                ExpeditionGameplay()
                return
            }
            Sleep(100)
        }
    }
}

;EXPEDITION END

;Challenge START

ChallengeGameplay() {
    global ChallengeStages
    ClickPlay()
    BetterClick(Modes[3][1], Modes[3][2])
    Sleep(2000)
    loop 10 {
        for stage in ChallengeStages {
            BetterClick(stage[1], stage[2])
            Sleep(2000)
            While true {
                if FindText(&X, &Y, 0, 0, 800, 599, 0, 0, StageConfirm) {
                    ToolTip("Stage Confirm Found")
                    Sleep(2000)
                    BetterClick(425, 430)
                    ToolTip("")
                    Sleep(2000)
                    BetterClick(500, 389)
                    Sleep(2000)
                    BetterClick(500, 368)
                    ;if (ChallengeRun()) {
                    ;    Sleep(2000)
                    ;    continue
                    ;}
                    ChallengeRun()
                    break
                } else {
                    ToolTip("Stage Confirm Not Found")
                    Sleep(2000)
                }
            }
        }
    }
}

ChallengeRun(){
    global wheeldownCount := 15
    while True {
        if IngameCheck(){
            Sleep(2000)
            break
        }
    }
    LookDown()
    stages := [
        ["SchoolGrounds", SchoolGrounds],
        ["FlowerForest", FlowerForest],
        ["RoseKingdom", RoseKingdom],
        ["FairyKingForest", FairyKingForest],
        ["KingsTomb", KingsTomb]
    ]
    for stage in stages {
        name := stage[1]
        pattern := stage[2]
        if (FindText(&X, &Y, 0, 0, 800, 599, 0, 0, pattern)) {
            ToolTip(name . " Found")
            Sleep(3000)
            ToolTip("")
            Sleep(3000)
            BetterClick(406, 180)
            Sleep(3000)
            steps := [
                [5, 1],
                [5, 2],
                [1, 3],
                [5, 4],
                [6, 5],
                [2, 6],
                [3, 7],
                [4, 8]
            ]
            found := false
            loop 3{
                for step in steps {
                    UnitPlacement(step[1], step[2], name)
                    if FindLobby() {
                        found := true
                        ChallengeGameplay()
                        return
                    }
                }
                if found {
                    break
                }
            }
            While true {
                if FindText(&X, &Y, 0, 0, 800, 599, 0, 0, Results) {
                    ToolTip("Results Found")
                    BetterClick(401, 488)
                    Sleep(3000)
                    ToolTip("")
                    BetterClick(303, 433)
                    Sleep(3000)
                    BetterClick(655, 370)
                    Sleep(3000)
                    BetterClick(Modes[3][1], Modes[3][2])
                    Sleep(2000)
                    return 1
                } else {
                ToolTip("Results Not Found")
                Sleep(3000)
                }
            }
        } else {
            ToolTip(name . " Not Found")
            Sleep(1000)
        }
    }
}

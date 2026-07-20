#Requires AutoHotkey v2.0

#Include mainfunctions.ahk
#Include gui.ahk
#Include placeUnits.ahk

Lobby:="|<Lobby>*109$33.zzzzzzXzzzzs9zzzzC4MXzwE00Dzt931zs90MTzX4HVzzzzzzzzzzzzzzzzzw"
ingame:="|<IngameCheck>*119$25.ByLb6Tvl30Us1dGw2YVCR6IbCU"


;Story Maps
SchoolGrounds:="|<SchoolGrounds>*115$63.syTznVzzztyS0lWNsWEA8MaEV3B9248Tkm48Nd8EVAkkGAHVAM4U4"
FlowerForest:="|<FlowerForest>*133$53.6zzzyDzzux5h6RsmAUMZ4hsYdHfl99vr9HtLcmMrj6l6E" 
RoseKingdom:="|<RoseKingdom>*108$37.YzzwzzEkA8F0MMEV24gY8EV2KO4V29/zzlzzzU"

FairyKingForest:="|<Fairy>*102$20.zwzkTzwwE43Y9HV34sEnzzszzzS" 
KingsTomb:="|<Tomb>*112$21.U00rw0DUzzDMU8OEZ/G4dP4Z1zzzU"

;Raid Maps
SpiritCity123:="|<SpiritCity>*96$35.w9HbnUDvpcJxkU1b0EY27C4g84iMg249C19wzzrzWD000DgC000Tw"

Results:="|<GameResults>*121$51.s001w01y0U04Eo89N7zzu3zz/wl0lmF4U8YcIi4cY/2V+1m1U1A69KCG8ld4"
StageConfirm:="|<SelectStage>*123$55.DVs0QTs00CMY0DQy00C7nzww9zzyS9XYAsMl7X0kW748EVw0E7bt920m18EnYY00wMG4Msl24DzzzzzzzHzzzzzzzzXy"

Act2:="|<CorrectSpot>*79$21.0006000w007k00zU07y00Tw01zs03zU07z00Tw00zs03zk07z00Ds00z3U1sTU73w0ATk0ny07Tk0zy04"
SpiritCity:="|<Act3>*115$20.tziAQFvGQwkbjtYNW"
Act3SpiritCity:="|<Act3SpiritCity>*72$24.0zz00zzU3zzwDzzzzzzzTzzyTzzqDzzwDzzwDzzyDzzyTzzxTzzrbzzwLzzk2zz00xz00HT00CD0U"

global MyGui

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

global StoryMaps := Map(
    ; Format: [X, Y, NeedsScroll?]
    "School Grounds",    [152, 339, false],
    "Flower Forest",     [399, 330, false],
    "Rose Kingdom",      [636, 336, false],
    "Fairy King Forest", [432, 336, true],
    "King's Tomb",       [686, 322, true]
)

global StoryStages := Map(
    "Stage 1", [172, 199],
    "Stage 2", [172, 238],
    "Stage 3", [172, 275],
    "Stage 4", [172, 315],
    "Stage 5", [172, 350],
    "Infinite", [172, 392], 
    "Mastery", [172, 428]  
)

global RaidMaps := Map(
    ; Format: [X, Y, NeedsScroll?]
    "Spirit City",    [142, 343, false],
)

global RaidStages := Map(
    "Stage 1", [180, 223],
    "Stage 2", [180, 315],
    "Stage 3", [180, 401]
)


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
    1, [460, 490], ;farm 1
    2, [503, 490], ;farm 2
    3, [442, 98], ;unit 1
    4, [458, 423], ;farm 3
    5, [499, 425], ;farm 4
    6, [372, 97], ;dps 2
    7, [437, 130],  ;dps 3
    8, [437, 170]  ;dps 3
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
    ),
    /*
    Act 2
    "SpiritCity", Map(
    1, [448, 420],
    2, [481, 423],
    3, [543, 290],
    4, [523, 421],
    5, [595, 402],
    6, [472, 325],
    7, [537, 333],
    8, [500, 308]
    )
    */
    "SpiritCity", Map(
    1, [400, 415],
    2, [436, 413],
    3, [580, 366],
    4, [541, 417],
    5, [625, 419],
    6, [523, 357],
    7, [478, 355],
    8, [519, 401]
    )    
)

ClickPlay(){
    WinActivate(RobloxWindow)
    BetterClick(100,100)
    Sleep(Integer(MyGui["SleepMs"].Value))
    FindLobby()
    Sleep(Integer(MyGui["SleepMs"].Value))
    BetterClick(70, 372)
    ToolTip("")
    Sleep(Integer(MyGui["SleepMs"].Value))
}

; GEM FARM
GemFarmGameplay(){
    ClickPlay()
    BetterClick(Modes[1][1], Modes[1][2])
    Sleep(Integer(MyGui["SleepMs"].Value))
    BetterClick(130,183)
    Sleep(Integer(MyGui["SleepMs"].Value))
    Send "{WheelDown 5}"
    Sleep(Integer(MyGui["SleepMs"].Value))
    BetterClick(690, 328)
    Sleep(Integer(MyGui["SleepMs"].Value))
    BetterClick(StoryStages[7][1], StoryStages[7][2])
    Sleep(Integer(MyGui["SleepMs"].Value))
    BetterClick(262, 430)
    Sleep(Integer(MyGui["SleepMs"].Value))
    BetterClick(474, 388)
    Sleep(Integer(MyGui["SleepMs"].Value))
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
    Sleep(Integer(MyGui["SleepMs"].Value))
    mapPos := ExpeditionMaps[MyGui["ExpeditionMap"].Text]
    BetterClick(mapPos[1], mapPos[2])
    BetterClick(759, 391)
    Sleep(1000)
    BetterClick(759, 391)
    Sleep(1000)
    BetterClick(759, 391)
    Sleep(Integer(MyGui["SleepMs"].Value))
    BetterClick(723, 526)
    Sleep(Integer(MyGui["SleepMs"].Value))
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
    Sleep(Integer(MyGui["SleepMs"].Value))
    loop 10 {
        for stage in ChallengeStages {
            BetterClick(stage[1], stage[2])
            Sleep(Integer(MyGui["SleepMs"].Value))
            While true {
                if FindText(&X, &Y, 0, 0, 800, 599, 0, 0, StageConfirm) {
                    ToolTip("Stage Confirm Found")
                    Sleep(Integer(MyGui["SleepMs"].Value))
                    BetterClick(425, 430)
                    ToolTip("")
                    Sleep(Integer(MyGui["SleepMs"].Value))
                    BetterClick(500, 389)
                    Sleep(Integer(MyGui["SleepMs"].Value))
                    BetterClick(500, 368)
                    ;if (ChallengeRun()) {
                    ;    Sleep(Integer(MyGui["SleepMs"].Value))
                    ;    continue
                    ;}
                    ChallengeRun()
                    break
                } else {
                    ToolTip("Stage Confirm Not Found")
                    Sleep(Integer(MyGui["SleepMs"].Value))
                }
            }
        }
    }
}

SchoolGroundsPosition(){
    Send("{w down}")
    Sleep(3000)
    Send("{w up}")
}

ChallengeRun(){
    global wheeldownCount := 15
    while True {
        if IngameCheck(){
            Sleep(Integer(MyGui["SleepMs"].Value))
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
            Sleep(Integer(MyGui["SleepMs"].Value))
            if (name = "SchoolGrounds") {
                SchoolGroundsPosition()
            }
            ToolTip("")
            Sleep(Integer(MyGui["SleepMs"].Value))
            VoteStart()
            Sleep(Integer(MyGui["SleepMs"].Value))
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
            While true{
                for step in steps {
                    UnitPlacement(step[1], step[2], name)
                    if FindLobby() {
                        ChallengeGameplay()
                        return
                    } else if FailedRun() {
                        VoteStart()
                        Sleep(Integer(MyGui["SleepMs"].Value))
                        break
                    } else if FindText(&X, &Y, 0, 0, 800, 599, 0, 0, Results) {
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
                        return
                    }
                    ToolTip("")
                }
            }
        } else {
            ToolTip(name . " Not Found")
            Sleep(1000)
        }
    }
}
;CHALLENGE END

;STORY START

SelectStoryMap() {
    selectedName := MyGui["StoryMap"].Text
    
    mapInfo := StoryMaps[selectedName]
    posX := mapInfo[1]
    posY := mapInfo[2]
    needsScroll := mapInfo[3]

    ; Scroll if it's on the second page
    if (needsScroll) {
        ; Move mouse over the map selection container area first
        BetterClick(130,183)
        Sleep(Integer(MyGui["SleepMs"].Value))
        
        ; Scroll down/right (adjust WheelDown or Drag depending on game UI)
        Send "{WheelDown 5}"
        Sleep(Integer(MyGui["SleepMs"].Value))
    }

    ; Click the map
    BetterClick(posX, posY)
}

StoryGameplay(){
    ClickPlay()
    BetterClick(Modes[1][1], Modes[1][2])
    Sleep(Integer(MyGui["SleepMs"].Value))
    SelectStoryMap()
    Sleep(Integer(MyGui["SleepMs"].Value))
    stagePos := StoryStages[MyGui["StoryMapStage"].Text]
    BetterClick(stagePos[1], stagePos[2])
    Sleep(Integer(MyGui["SleepMs"].Value))
    BetterClick(254, 257)
    Sleep(Integer(MyGui["SleepMs"].Value))
    BetterClick(262, 430)
    Sleep(Integer(MyGui["SleepMs"].Value))
    BetterClick(474, 388)
    Sleep(Integer(MyGui["SleepMs"].Value))
    StoryRun()
}

StoryRun(){
    global wheeldownCount := 15
    while True {
        if IngameCheck(){
            Sleep(Integer(MyGui["SleepMs"].Value))
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
            Sleep(Integer(MyGui["SleepMs"].Value))
            ToolTip("")
            Sleep(Integer(MyGui["SleepMs"].Value))
            BetterClick(406, 180)
            Sleep(Integer(MyGui["SleepMs"].Value))
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
            while true{
                for step in steps {
                    UnitPlacement(step[1], step[2], name)
                    if FindLobby() {
                        StoryGameplay()
                        return
                    }
                }
            }
        }
    }
}

; Story END

; RAID START

SelectRaidMap() {
    selectedName := MyGui["RaidMap"].Text
    
    mapInfo := RaidMaps[selectedName]
    posX := mapInfo[1]
    posY := mapInfo[2]
    needsScroll := mapInfo[3]

    ; Scroll if it's on the second page
    if (needsScroll) {
        ; Move mouse over the map selection container area first
        BetterClick(130,183)
        Sleep(Integer(MyGui["SleepMs"].Value))
        
        ; Scroll down/right (adjust WheelDown or Drag depending on game UI)
        Send "{WheelDown 5}"
        Sleep(Integer(MyGui["SleepMs"].Value))
    }

    ; Click the map
    BetterClick(posX, posY)
}

RaidGameplay(){
    ClickPlay()
    BetterClick(Modes[2][1], Modes[2][2])
    Sleep(Integer(MyGui["SleepMs"].Value))
    SelectRaidMap()
    Sleep(Integer(MyGui["SleepMs"].Value))
    stagePos := RaidStages[MyGui["RaidMapStage"].Text]
    BetterClick(stagePos[1], stagePos[2])
    Sleep(Integer(MyGui["SleepMs"].Value))
    BetterClick(262, 431)
    Sleep(Integer(MyGui["SleepMs"].Value))
    BetterClick(474, 413)
    Sleep(Integer(MyGui["SleepMs"].Value))
    RaidRun()
}

Raidact2(){
    Send("{s down}{d down}")
    Sleep(2200)               
    Send("{s up}{d up}")
    Send("{d down}")
    Sleep(1800)               
    Send("{d up}")
    Send("{s down}")
    Sleep(1800)               
    Send("{s up}") 
}

RaidRun(){
    global wheeldownCount := 15
    while True {
        if IngameCheck(){
            Sleep(Integer(MyGui["SleepMs"].Value))
            break
        }
    }
    LookDown()
    While true{
        Sleep(Integer(MyGui["SleepMs"].Value))
        Send("{d down}")
        Sleep(3000)
        Send("{d up}")
        Sleep(Integer(MyGui["SleepMs"].Value))
        ;Act2 if FindText(&X, &Y, 443, 391, 502, 434, 0, 0, SpiritCity) {
        if FindText(&X, &Y, 0, 0, 800, 599, 0, 0, Act3SpiritCity) {
            ToolTip("Correct Spot")
            VoteStart()
            Sleep(Integer(MyGui["SleepMs"].Value))
            ToolTip("")
            break
        } else {
            ToolTip("Incorrect Spot")
            Sleep(Integer(MyGui["SleepMs"].Value))
            ToolTip("")
            BetterClick(277, 35)
            Sleep(Integer(MyGui["SleepMs"].Value))
            BetterClick(633, 308)
            Sleep(2000)
            BetterClick(658, 154)
            Sleep(Integer(MyGui["SleepMs"].Value))

        }
    }
    stages := [
        ["SpiritCity", SpiritCity]
    ]
    for stage in stages {
        name := stage[1]
        pattern := stage[2]
        if (FindText(&X, &Y, 0, 0, 800, 599, 0, 0, pattern)) {
            ToolTip(name . " Found")
            Sleep(Integer(MyGui["SleepMs"].Value))
            ToolTip("")
            Sleep(Integer(MyGui["SleepMs"].Value))
            BetterClick(406, 180)
            Sleep(Integer(MyGui["SleepMs"].Value))
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
            while true {
                for step in steps {
                    UnitPlacement(step[1], step[2], name)
                    if FindLobby() {
                        RaidGameplay()
                        return
                    }   else if FailedRun() {
                        VoteStart()
                        Sleep(Integer(MyGui["SleepMs"].Value))
                        break
                    }
                }
            }
        } else {
            ToolTip(name . " Not Found")
            Sleep(2000)
            ToolTip("")
        }
    }
}

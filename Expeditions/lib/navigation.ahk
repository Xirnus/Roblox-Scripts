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
KingsTomb:="|<Tomb>*91$23.z03E3zwvMU8SY9GR8GYv4Z3U"

;Raid Maps
Spirit1:="|<SpiritCityAct1>*118$18.nzQXWCdDSVDSAXCU"
Spirit2:="|<SpiritAct2>*120$20.nzQ8sXuYxwVDSH8n2"
Spirit3:="|<SpiritAct3>*125$19.Zys3WDIbj0HrtYNV"



Results:="|<GameResults>*121$51.s001w01y0U04Eo89N7zzu3zz/wl0lmF4U8YcIi4cY/2V+1m1U1A69KCG8ld4"
StageConfirm:="|<SelectStage>*123$55.DVs0QTs00CMY0DQy00C7nzww9zzyS9XYAsMl7X0kW748EVw0E7bt920m18EnYY00wMG4Msl24DzzzzzzzHzzzzzzzzXy"

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
    "Expedition", Map(
    1, [365, 302], ;unit 1
    2, [378, 106], ;farm 1
    3, [328, 138], ;farm 2
    4, [371, 267], ;unit 2
    5, [425, 286], ;unit 3
    6, [302, 281]  ;unit 4
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
        ["School Grounds", SchoolGrounds],
        ["Flower Forest", FlowerForest],
        ["Rose Kingdom", RoseKingdom],
        ["Fairy King Forest", FairyKingForest],
        ["King's Tomb", KingsTomb]
    ]
    for stage in stages {
        name := stage[1]
        pattern := stage[2]
        if (FindText(&X, &Y, 0, 0, 800, 599, 0, 0, pattern)) {
            ToolTip(name . " Found")
            Sleep(Integer(MyGui["SleepMs"].Value))
            if (name = "School Grounds") {
                Send("{w down}")
                Sleep(3000)
                Send("{w up}")
            }
            if (name = "Rose Kingdom") {
                Send("{s down}")
                Sleep(1500)
                Send("{s up}")
            }
            if (name = "Flower Forest") {
                Send("{s down}{a down}")
                Sleep(3000)
                Send("{s up}{a up}")
            }
            ToolTip("")
            Sleep(Integer(MyGui["SleepMs"].Value))
            VoteStart()
            Sleep(Integer(MyGui["SleepMs"].Value))
                While true {
                    isFinished := PlaceUnitsFromIni(name)
                    if (isFinished)
                        return
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
        ["School Grounds", SchoolGrounds],
        ["Flower Forest", FlowerForest],
        ["Rose Kingdom", RoseKingdom],
        ["Fairy King Forest", FairyKingForest],
        ["King's Tomb", KingsTomb]
    ]
    for stage in stages {
        name := stage[1]
        pattern := stage[2]
        if (FindText(&X, &Y, 0, 0, 800, 599, 0, 0, pattern)) {
            ToolTip(name . " Found")
            Sleep(Integer(MyGui["SleepMs"].Value))
            if (name = "School Grounds") {
                Send("{w down}")
                Sleep(3000)
                Send("{w up}")
            }
            if (name = "Rose Kingdom") {
                Send("{s down}")
                Sleep(1500)
                Send("{s up}")
            }
            if (name = "Flower Forest") {
                Send("{s down}{a down}")
                Sleep(3000)
                Send("{s up}{a up}")
            }
            ToolTip("")
            Sleep(Integer(MyGui["SleepMs"].Value))
            VoteStart()
            Sleep(Integer(MyGui["SleepMs"].Value))
                While true {
                    isFinished := PlaceUnitsFromIni(name)
                    if (isFinished)
                        return
                    }
                } else {
                    ToolTip(name . " Not Found")
                    Sleep(1000)
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

RaidRun(){
    global wheeldownCount := 15
    while True {
        if IngameCheck(){
            Sleep(Integer(MyGui["SleepMs"].Value))
            break
        }
    }
    LookDown()
    stages := [
        ["Spirit1", Spirit1],
        ["Spirit2", Spirit2],
        ["Spirit3", Spirit3]
    ]
    for stage in stages {
        name := stage[1]
        pattern := stage[2]
        if (FindText(&X, &Y, 0, 0, 800, 599, 0, 0, pattern)) {
            ToolTip(name . " Found")
            Sleep(Integer(MyGui["SleepMs"].Value))
            ToolTip("")
            if (name = "Spirit1") {
                Send("{d down}")
                Sleep(3000)
                Send("{d up}")
            }
            if (name = "Spirit2") {
                Send("{s down}{d down}")
                Sleep(3000)
                Send("{s up}{d up}")
            }
            if (name = "Spirit3") {
                Send("{d down}")
                Sleep(3000)
                Send("{d up}")
            }
            Sleep(Integer(MyGui["SleepMs"].Value))
            BetterClick(406, 180)
            Sleep(Integer(MyGui["SleepMs"].Value))
            While true {
                isFinished := PlaceUnitsFromIni(name)
                if (isFinished)
                    return
                }
        } else {
            ToolTip(name . " Not Found")
            Sleep(2000)
            ToolTip("")
        }
    }
}

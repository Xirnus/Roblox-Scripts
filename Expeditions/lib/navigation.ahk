#Requires AutoHotkey v2.0

#Include mainfunctions.ahk
#Include gui.ahk
#Include placeUnits.ahk

Lobby:="|<Lobby>*109$33.zzzzzzXzzzzs9zzzzC4MXzwE00Dzt931zs90MTzX4HVzzzzzzzzzzzzzzzzzw"
ingame:="|<IngameCheck>*119$25.ByLb6Tvl30Us1dGw2YVCR6IbCU"

global Modes := [
    [462, 127], ;Story
    [684, 128], ;Raid
    [476, 227], ;Challenge
    [704, 232]  ;Expedition
]

global ExpeditionMaps := Map(
    "School Grounds", [112, 260],
    "Flower Forest", [112, 301],
    "Rose Kingdom", [112, 356]
)

global StoryStages := [
    [178, 227], ;1
    [181, 268], ;2
    [189, 314], ;3
    [179, 346], ;4
    [182, 384], ;5
    [182. 422], ;Infinite
    [177, 462]  ;Mastery
]

global unitMaps := Map(
    "Gem Farm", Map(
	1, [223, 510],
	2, [223, 445],
	3, [223, 387],
	4, [327, 146],
	5, [387, 106],
	6, [423, 101] 
    ),
    "Expedition", Map(
    1, [376, 328], ;unit 1
    2, [385, 114], ;farm 1
    3, [330, 121], ;farm 2
    4, [336, 335], ;unit 2
    5, [424, 336], ;unit 3
    6, [381, 287]  ;unit 4
    )
)


; GEM FARM
GemFarmGameplay(){
    WinActivate(RobloxWindow)
    BetterClick(100,100)
    Sleep(1200)
    FindLobby()
    Sleep(1200)
    BetterClick(77, 395)
    ToolTip("")
    Sleep(1200)
    BetterClick(Modes[1][1], Modes[1][2])
    Sleep(1200)
    BetterClick(148,203)
    Sleep(1200)
    Send "{WheelDown 5}"
    Sleep(1200)
    BetterClick(700, 352)
    Sleep(1200)
    BetterClick(StoryStages[7][1], StoryStages[7][2])
    Sleep(1200)
    BetterClick(276, 465)
    Sleep(1200)
    BetterClick(480, 413)
    Sleep(1200)
    GemFarmRun()
}

GemFarmRun(){
    global wheeldownCount := 20
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
        [1, 4],
        [2, 5],
        [3, 6]
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
    WinActivate(RobloxWindow)
    BetterClick(100,100)
    Sleep(1200)
    FindLobby()
    ToolTip("")
    Sleep(1200)
    BetterClick(77, 395)
    Sleep(1200)
    BetterClick(Modes[4][1], Modes[4][2])
    Sleep(1200)
    mapPos := ExpeditionMaps[MyGui["ExpeditionMap"].Text]
    BetterClick(mapPos[1], mapPos[2])
    BetterClick(768, 424)
    BetterClick(768, 424)
    BetterClick(768, 424)
    Sleep(1200)
    BetterClick(731, 561)
    Sleep(1200)
    BetterClick(481, 392)
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
    BetterClick(422, 523)
    Sleep(300)
    BetterClick(348, 359)
    steps := [
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
            BetterClick(422, 523)
            Sleep(300)
            BetterClick(348, 359)
            Sleep(300)
            if FindLobby() {
                ExpeditionGameplay()
                return
            }
            Sleep(100)
        }
    }
}
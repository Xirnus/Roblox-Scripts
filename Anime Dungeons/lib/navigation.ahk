#Requires AutoHotkey v2.0

#Include mainfunctions.ahk
#Include gui.ahk
#Include placeUnits.ahk

;Lobby:="|<Lobby>*109$33.zzzzzzXzzzzs9zzzzC4MXzwE00Dzt931zs90MTzX4HVzzzzzzzzzzzzzzzzzw"
ingame:="|<IngameCheck>*142$16.RwxrzLFcR2VpfEKgXOm"
Lobby:="|<Lobby>*117$22.XzzwAzznV48W013YYA0m0kXYHW"
VoteStartBtn:="|<VoteStart>*135$19.TUCNTxd60S63SX1jYknU"

;Story Maps
SchoolGrounds:="|<SchoolGrounds>*139$25.Xvzz7UAtcipfLLOpcABbB"
FlowerForest:="|<FlowerForest>*141$26.2zzzrghgkOp65Sh9jLgmQq"
FlowerForest2:="|<FlowerForest2>*121$26.0zzzr8hcUEY0dQ99CL8mMa"
RoseKingdom:="|<RoseKingdom>*135$36.PTzvzyLEV3A17KdOphHKVOphPKx3BhU"
FairyKingForest:="|<FairyKingForest>*121$18.3xzSB26BOQBMSBNzznU" 
ChallengeKingsTomb1:="|<>*169$35.000Di0000TyA001zzs003zzk007zzU00Dzz000Dzk000Ty0001zs0007zU000Ty0000zw1003ztw007zzk00Dzzc00TzyE0DzzsU1zzzV07zzz20Tzzy01zzzwLbzzzkTTyTz0TzUTs0zy0S01"
ChallengeKingsTomb2:="|<KingsTomb>*122$19.z03UzzR60ahPJKhecqoTzzk"
StoryKingsTomb:="|<StoryKingsTomb>*149$21.1zyyn0lpfOqhPKqPOA"

;Raid Maps
Spirit1:="|<Spirit1>*77$19.D1zYbr4Q1a6Nu3CxAVCzzzk"
Spirit2:="|<SpiritAct2>*120$20.nzQ8sXuYxwVDSH8n2"
Spirit3:="|<Spirit3>*78$22.y1nz9xcMc2tVaN46RiH8HVzzvu"

;btns
Results:="|<GameResults>*135$28.w00y0M06w0zzvTPAKcU8FOW0VZfQGQEgVgFWG8"
PlayConfirm:="|<BackBtn>*133$20.XzwkTzArKH9V43G7440E1V4c"
SelectStage:="|<SelectStage>*115$29.T3k0tW4U1u7tzyQwH68QEY8Ey18HnV2EVbX4lXa"
StartButton:="|<StartBtn>*118$25.Ts0QMy0D8NzwosE0/4027t93bVY1nst0ws"

;Expeditions
ExpeditionsView1:="|<ExpeditionsView1>*118$27.PyTzqznzzzsDzzw0Txz01zrk07yw00zrU03yw00TrU03yy00Tzy0TzzzzzzzzzzzzzzzzzzzzzzzzzzzhjzzxzzzzvU"
ExpeditionsView2:="|<ExpView2>*113$35.ry0Dzzzk0Dzzz00Dzbw00DzDk00Dzz0007yy000Txw000Tvk000zrU001zz0003zw0003zw000Dzz003zzzk0zzrzzzzzjzzzzzTzzzzyzzzzzzzzzzzzzzzzz/zzzzwzzzzztrzzzzbzzzzyR"
ExpContinue:="|<ExpContinue>*117$37.y03o00FU3m000TzDzzvsV039Vs0U1YUwV92GE00YV88FWH0a68"
ExpContinue2:="|<ExpdContinue2>*138$36.y03w00X07Y001zyzzzTaAIPNT24I/ETOqpfE12qJcHXaqJgMU"
ExpContinueRoseKingdom:="|<>*141$25.TDSLDzzzrzzzvTzzxTzzzzkzzzU3zzU0zzU0TzU07zk03zs01zs01zw00zy00zzU0Tzk0Tzw0Tzz0TzzlzzrzzzxzzzxSzzw77zx9VztE"
ExpContinueRoseKingdom2:="|<>*143$31.DzzzzbzzzznzzzznbzzzwnzzzyPz0DzTy01zzy00Tzy007vy001zy000yz000TzU00DzU00Dzk007zs003zs001zy001zz000zzU00Tzk00Tvw00Dxy00TzzU0zzjs0zzry0zzpzzzzxzzzzyjzzzzjzzzzFzrzzk"

; Results
Victory:="|<VictoryResult>*117$45.wTMD0004qP18000WXztzTvqQn2260mF6EE0E6H9mTAmQ28+HtaGklXG342G46GMQkmNUQSyzzn8000000H4"
Defeat:="|<DefeatStage>*146$39.zzyTzzsDzXzzn0zwzzyNXX1XUUCM88A41m1a1AnAHwntaM71b1Ul1wAwA7A"
NextStage:="|<NextStage>*125$19.r03ik1nTzViP0600W2AN32Ak98"
RepeatStage:="|<RepeatStage>*133$32.00000Dk000m6000SUzzzwtAElW6248E1VVM4Yt9EZ1Cv4AMNzzDzzzznzzy"
ViewParty:="|<ViewParty>*135$21.CHztnzzaq2oa00lk8CC51vqBQ"
CloseBtn:="|<CloseBtn>*149$22.lTzy4zznn6MD810wYY8G03lAFW"
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
    [615, 400]  ;3 EVO ITEMS
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
    StageSetUp()
    Loop 3{
        stages := [
            ["Expeditions", ExpeditionsView1],
            ["Expeditions", ExpContinueRoseKingdom],
            ["Expeditions", ExpContinue]

        ]
        Sleep(2000)
        VoteStart()
        for stage in stages {
            name := stage[1]
            pattern := stage[2]
            if (FindText(&X, &Y, 0, 0, 800, 599, 0, 0, pattern)) {
                ToolTip(name . " Found")
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
}

;EXPEDITION END

;Challenge START

ChallengeGameplay() {
    global ChallengeStages
    if LobbySetUp() {
        BetterClick(Modes[3][1], Modes[3][2])
        Sleep(Integer(MyGui["SleepMs"].Value))
        loop 10 {
            for stage in ChallengeStages {
                BetterClick(stage[1], stage[2])
                Sleep(Integer(MyGui["SleepMs"].Value))
                While true {
                    if FindText(&X, &Y, 0, 0, 800, 599, 0, 0, SelectStage) {
                        ToolTip("Stage Confirm Found")
                        Sleep(Integer(MyGui["SleepMs"].Value))
                        EnterGameMode()
                        ChalStoryGameplay()
                        break
                    } else {
                        ToolTip("Stage Confirm Not Found")
                        Sleep(Integer(MyGui["SleepMs"].Value))
                        Send("{x down}")
                        Sleep(200)
                        Send("{x up}")
                    }
                }
            }
        }
    }
}  

;CHALLENGE END

ChalStoryGameplay() {
    StageSetUp()
    
    stages := [
        ["School Grounds", SchoolGrounds],
        ["Flower Forest", FlowerForest],
        ["Flower Forest", FlowerForest],
        ["Rose Kingdom", RoseKingdom],
        ["Fairy King Forest", FairyKingForest],
        ["King's Tomb", ChallengeKingsTomb1],
        ["King's Tomb", ChallengeKingsTomb2],
        ["King's Tomb", StoryKingsTomb]
    ]

    ; Outer loop for the 3 attempts
    loop 3 {
        attempt := A_Index  ; Save the attempt number (1, 2, or 3)

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

                while true {
                    isFinished := PlaceUnitsFromIni(name)
                    if (isFinished)
                        return  ; Finished the stage successfully, exit ChallengeRun entirely
                }
            } else {
                ; Uses the saved attempt counter so it stays 1, 2, or 3 across all stage checks
                ToolTip(name . " Not Found (Attempt " . attempt . "/3)")
                Sleep(500)
            }
        }
    }
}
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
    if LobbySetUp() {
        BetterClick(Modes[1][1], Modes[1][2])
        Sleep(Integer(MyGui["SleepMs"].Value))
        SelectStoryMap()
        Sleep(Integer(MyGui["SleepMs"].Value))
        stagePos := StoryStages[MyGui["StoryMapStage"].Text]
        BetterClick(stagePos[1], stagePos[2])
        Sleep(Integer(MyGui["SleepMs"].Value))
        BetterClick(254, 257)
        Sleep(Integer(MyGui["SleepMs"].Value))
        EnterGameMode()
        ChalStoryGameplay()
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

    if (needsScroll) {
        BetterClick(130,183)
        Sleep(Integer(MyGui["SleepMs"].Value))
        
        
        Send "{WheelDown 5}"
        Sleep(Integer(MyGui["SleepMs"].Value))
    }

    ; Click the map
    BetterClick(posX, posY)
}

RaidGameplay(){
    if LobbySetUp() {
        BetterClick(Modes[2][1], Modes[2][2])
        Sleep(Integer(MyGui["SleepMs"].Value))
        SelectRaidMap()
        Sleep(Integer(MyGui["SleepMs"].Value))
        stagePos := RaidStages[MyGui["RaidMapStage"].Text]
        BetterClick(stagePos[1], stagePos[2])
        Sleep(Integer(MyGui["SleepMs"].Value))
        EnterGameMode()
        Sleep(Integer(MyGui["SleepMs"].Value))
        RaidRun()
    }
}

RaidRun(){
    StageSetUp()
    Loop 3{
        stages := [
            ["Spirit1", Spirit1],
            ["Spirit2", Spirit2],
            ["Spirit3", Spirit3]
        ]
        for stage in stages {
            name := stage[1]
            pattern := stage[2]
            if (FindText(&X, &Y, 0, 0, 900, 599, 0, 0, pattern)) {
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
}

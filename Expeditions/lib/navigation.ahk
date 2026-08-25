#Requires AutoHotkey v2.0

#Include mainfunctions.ahk
#Include gui.ahk
#Include placeUnits.ahk
#Include patterns.ahk

global MyGui

ExecuteMovement(movementArray){
    for movement in movementArray {
        key := movement.key
        duration := movement.duration
        Send("{" . key . " down}")
        Sleep(duration)
        Send("{" . key . " up}")
    }
}

RunGameMode(StageList) {
    StageSetUp()
    Loop 3 {
        Sleep(2000)
        ; If stage is found and completed, exit function
        if FindAndExecuteStage(stageList){
            VoteStart()
            return true
        }
    }
    return false
}

FindAndExecuteStage(stageList) {
    sleepMs := Integer(MyGui["SleepMs"].Value)

    ; Loop through each stage entry in the specific stage list
    for stage in stageList {
        mapName := stage[1]      
        pattern := stage[2]      
        movementArray := stage[3]  

        if FindText(&X, &Y, 0, 0, 800, 599, 0, 0, pattern) {
            ToolTip(mapName . " Found")
            Sleep(sleepMs)

            ; Execute any character movements defined for this map
            ExecuteMovement(movementArray)

            ToolTip("")

            ; Run unit placement until game state changes
            return PlaceUnitsFromIni(mapName)
        } else {
            ToolTip(mapName . " Not Found")
            Sleep(sleepMs)
        }
    }
    return false
}

/*
global GameplayModes := [
    ["Story", LobbySetUp, BetterClick(Modes[1][1], Modes[1][2]), SelectMap(StoryMaps, MyGui["StoryMap"].Text), BetterClick(StoryStagesPlacements[MyGui["StoryMapStage"].Text][1], StoryStagesPlacements[MyGui["StoryMapStage"].Text][2]), BetterClick(254, 257), EnterGameMode(), RunGameMode(StoryStages)],
    ["Raid", LobbySetUp, BetterClick(Modes[2][1], Modes[2][2])],
    ["Challenge", LobbySetUp, BetterClick(Modes[3][1], Modes[3][2])],
    ["Event", EventGameplay]
]

EnterGameplay(Mode){
    sleepMs := Integer(MyGui["SleepMs"].Value)

    for steps in Mode {

    }
}
*/

SelectMap(mapData, selectedMapName){
    mapInfo := mapData[selectedMapName]
    posX := mapInfo[1]
    posY := mapInfo[2]
    needsScroll := mapInfo[3]

    ; Scroll if it's on the second page
    if (needsScroll) {
        ; Move mouse over the map selection container area first
        BetterClick(130,183)
        Sleep(Integer(MyGui["SleepMs"].Value))
        
        ; Scroll down/right (adjust WheelDown or Drag depending on game UI)
        Send "{WheelDown 10}"
        Sleep(Integer(MyGui["SleepMs"].Value))
    }

    ; Click the map
    BetterClick(posX, posY)
}

StoryGameplay(){
    if LobbySetUp() {
        BetterClick(Modes[1][1], Modes[1][2])
        Sleep(Integer(MyGui["SleepMs"].Value))
        SelectMap(StoryMaps, MyGui["StoryMap"].Text)
        Sleep(Integer(MyGui["SleepMs"].Value))
        stagePos := StoryStagesPlacements[MyGui["StoryMapStage"].Text]
        BetterClick(stagePos[1], stagePos[2])
        Sleep(Integer(MyGui["SleepMs"].Value))
        BetterClick(254, 257)
        Sleep(Integer(MyGui["SleepMs"].Value))
        EnterGameMode()
        RunGameMode(StoryStages)
    }
}

;EXPEDITION 
ExpeditionGameplay() {
    global ExpeditionMaps
    ClickPlay()
    BetterClick(Modes[4][1], Modes[4][2])
    Sleep(Integer(MyGui["SleepMs"].Value))
    mapPos := ExpeditionMaps[MyGui["ExpeditionMap"].Text]
    BetterClick(mapPos[1], mapPos[2])
    Loop 2{
        BetterClick(307, 438)
        Sleep(1000)
    }
    Sleep(Integer(MyGui["SleepMs"].Value))
    BetterClick(256, 578)
    Sleep(Integer(MyGui["SleepMs"].Value))
    BetterClick(474, 365)
    RunGameMode(ExpeditionStages)
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
                while true {
                    if FindText(&X, &Y, 0, 0, 800, 599, 0, 0, SelectStage) {
                        ToolTip("Stage Confirm Found")
                        Sleep(Integer(MyGui["SleepMs"].Value))
                        EnterGameMode()
                        RunGameMode(StoryStages)
                        break
                    } else {
                        ToolTip("Stage Confirm Not Found")
                        Sleep(2000)
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


; RAID START

RaidGameplay(){
    if LobbySetUp() {
        BetterClick(Modes[2][1], Modes[2][2])
        Sleep(Integer(MyGui["SleepMs"].Value))
        SelectMap(RaidMaps, MyGui["RaidMap"].Text)
        Sleep(Integer(MyGui["SleepMs"].Value))
        stagePos := RaidStagesPlacements[MyGui["RaidMapStage"].Text]
        BetterClick(stagePos[1], stagePos[2])
        Sleep(Integer(MyGui["SleepMs"].Value))
        EnterGameMode()
        Sleep(Integer(MyGui["SleepMs"].Value))
        RunGameMode(RaidStages)
    }
}
EventGameplay() {
    Loop 5{
        if FindLobby() {
            BetterClick(53, 403)
            Sleep(Integer(MyGui["SleepMs"].Value))
            BetterClick(102, 132)
            Sleep(Integer(MyGui["SleepMs"].Value))
            BetterClick(500, 560)
            Sleep(Integer(MyGui["SleepMs"].Value))
            stagePos := EventStagesPlacements[MyGui["EventMapStage"].Text]
            BetterClick(stagePos[1], stagePos[2])
            Sleep(Integer(MyGui["SleepMs"].Value))
            EnterGameMode()
            Sleep(Integer(MyGui["SleepMs"].Value))
            RunGameMode(EventStages)
        } if (A_Index = 5) {
            ToolTip("Lobby Not Found, Stopping Script")
            Sleep(5000)
            ToolTip("")
            ExitApp
        }
        Sleep(3000)
        ToolTip("Lobby Not Found, Retrying... (" A_Index "/5)")
    }
}
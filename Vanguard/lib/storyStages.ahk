#Include functions.ahk


storyStages := Map()
storyStages["Namek"] := [155, 220]
storyStages["Sand"] := [155, 274]
storyStages["Double"] := [155, 328]
storyStages["Shibuya"] := [155, 382]
storyStages["Underground"] := [155, 436]
; Has to scroll down to see these
storyStages["Spirit"] := [155, 382]
storyStages["Martial"] := [155, 436]

actStages := Map()
actStages["1"] := [310, 274]
actStages["2"] := [310, 328]
actStages["3"] := [310, 382]
actStages["4"] := [310, 436]
; has to scroll down to see these
actStages["5"] := [310, 328]
actStages["6"] := [310, 382]
actStages["Infinite"] := [310, 436]



clickStageAndAct(stageName, actName) {
    global storyStages, actStages

    ; Handle scrolling for stages
    if (stageName = "Spirit" || stageName = "Martial") {
        Send("{WheelDown}")
        Sleep(300)
    }

    if !storyStages.Has(stageName) {
        MsgBox("Stage not found: " stageName)
        return
    }

    stageCoords := storyStages[stageName]
    BetterClick(stageCoords[1], stageCoords[2])
    Sleep(500)

    ; Handle scrolling for acts
    if (actName = "5" || actName = "6" || actName = "Infinite") {
        BetterClick(310, 274)
        Send("{WheelDown}")
        Sleep(300)
    }

    if !actStages.Has(actName) {
        MsgBox("Act not found: " actName)
        return
    }

    actCoords := actStages[actName]
    BetterClick(actCoords[1], actCoords[2])
}

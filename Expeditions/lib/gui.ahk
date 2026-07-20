#Requires AutoHotkey v2.0

#Include navigation.ahk


if !IsSet(MyGui) {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.Title := "Omsim Macro"
    MyGui.SetFont("s10", "Segoe UI")

    ; --- LEFT COLUMN ---
    MyGui.Add("Text", "x15 y15 w150 Center", "Select Game Mode:")
    modeDDL := MyGui.Add("DropDownList", "x15 y+5 w150 vMode Choose1", ["Gem Farm", "Story", "Raid", "Challenge", "Expedition"])
    
    ; Event Listener: Fires whenever 'vMode' changes selection
    modeDDL.OnEvent("Change", UpdateGuiVisibility)

    ; Sleep Input (Positioned right below Game Mode selection)
    MyGui.Add("Text", "x15 y+25 w75", "Sleep (ms):")
    MyGui.Add("Edit", "x+2 yp-3 w73 vSleepMs", "1000")
    
    ; Helper text
    MyGui.SetFont("s8 cGray")
    MyGui.Add("Text", "x15 y+5 w150", "1sec = 1000")
    MyGui.SetFont("s10 cDefault")

    ; --- RIGHT COLUMN (Positioned at x185 y15) ---
    ; Expedition Controls
    txtExp   := MyGui.Add("Text", "x185 y15 w150 Center", "Select Expedition Map:")
    ddlExp   := MyGui.Add("DropDownList", "x185 y+5 w150 vExpeditionMap Choose1", ["School Grounds", "Flower Forest", "Rose Kingdom"])

    ; Story Controls
    txtStory := MyGui.Add("Text", "x185 y15 w150 Center", "Select Story Map:")
    ddlStory := MyGui.Add("DropDownList", "x185 y+5 w150 vStoryMap Choose1", ["School Grounds", "Flower Forest", "Rose Kingdom", "Fairy King Forest", "King's Tomb"])

    txtStage := MyGui.Add("Text", "x185 y+12 w150 Center", "Select Story Stage:")
    ddlStage := MyGui.Add("DropDownList", "x185 y+5 w150 vStoryMapStage Choose1", ["Stage 1", "Stage 2", "Stage 3", "Stage 4", "Stage 5", "Infinite", "Mastery"])

    ; Raid Controls
    txtRaid := MyGui.Add("Text", "x185 y15 w150 Center", "Select Raid Map:")
    ddlRaid := MyGui.Add("DropDownList", "x185 y+5 w150 vRaidMap Choose1", ["Spirit City"])

    txtStage2 := MyGui.Add("Text", "x185 y+12 w150 Center", "Select Raid Stage:")
    ddlStage2 := MyGui.Add("DropDownList", "x185 y+5 w150 vRaidMapStage Choose1", ["Stage 1", "Stage 2", "Stage 3"])

    ; Challenge Controls
    txtChall  := MyGui.Add("Text", "x185 y15 w150 Center", "Challenge Only:")
    txtChall2 := MyGui.Add("Text", "x185 y+2 w150 Center", "(Auto Start OFF)")

    ; --- BOTTOM SECTION ---
    MyGui.Add("Text", "x15 y195 w320 vWinText Center", "F9: Start | ESC: Stop")

    ; Initial hide/show call on startup
    UpdateGuiVisibility()
}

; Function to dynamically toggle visibility based on selected Mode
UpdateGuiVisibility(*) {
    selectedMode := MyGui["Mode"].Text

    ; Hide everything on the right side first
    txtExp.Visible    := false
    ddlExp.Visible    := false
    txtStory.Visible  := false
    ddlStory.Visible  := false
    txtStage.Visible  := false
    ddlStage.Visible  := false
    txtChall.Visible  := false
    txtChall2.Visible := false
    txtRaid.Visible   := false
    ddlRaid.Visible   := false
    txtStage2.Visible := false
    ddlStage2.Visible := false
    ; Show specific controls based on mode
    switch selectedMode {
        case "Expedition":
            txtExp.Visible := true
            ddlExp.Visible := true
            
        case "Story":
            txtStory.Visible := true
            ddlStory.Visible := true
            txtStage.Visible := true
            ddlStage.Visible := true

        case "Challenge":
            txtChall.Visible  := true
            txtChall2.Visible := true
        
        case "Raid":
            txtRaid.Visible := true
            ddlRaid.Visible := true
            txtStage2.Visible := true
            ddlStage2.Visible := true
    }
}

MoveGui(){
    global MyGui, RobloxWindow

    if WinExist(RobloxWindow) {
        WinGetPos(&x, &y, &w, &h, RobloxWindow)
        MyGui.Show("x" (x + w - 10) " y" y " w350 h235")
    } else {
        MyGui.Show("w350 h235")
    }
}

StartGameplay(){
    selectedMode := MyGui["Mode"].Text

    Switch selectedMode {
        Case "Gem Farm":
            ;while (true) {
                GemFarmGameplay()
                Sleep(500)
            ;}
        Case "Story":
            while (true) {
                StoryGameplay()
                Sleep(5000)
            }
        Case "Raid":
            while (true) {
                RaidGameplay()
                Sleep(5000)
            }
        Case "Challenge":
            while (true) {
                ChallengeGameplay()
                Sleep(5000)
            }
        Case "Expedition":
            ;while (true) {
                ExpeditionGameplay()
                Sleep(5000)
            ;}
    }
}
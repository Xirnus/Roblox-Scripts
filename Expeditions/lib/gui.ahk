#Requires AutoHotkey v2.0

#Include navigation.ahk

; --- DIRECTORIES ---
IniFile     := A_ScriptDir . "\settings.ini"
ImageFolder := A_ScriptDir . "\img"

if !DirExist(ImageFolder)
    DirCreate(ImageFolder)

; Global storage for Unit Placement references
guiControls := Map()
unitPlacementGui := ""

; ==============================================================================
; MAIN GUI (PARENT)
; ==============================================================================
if !IsSet(MyGui) {
    MyGui := Gui("+AlwaysOnTop")
    MyGui.Title := "Omsim Macro"
    MyGui.SetFont("s10", "Segoe UI")

    ; --- LEFT COLUMN ---
    MyGui.Add("Text", "x15 y15 w150 Center", "Select Game Mode:")
    modeDDL := MyGui.Add("DropDownList", "x15 y+5 w150 vMode Choose1", ["Story", "Raid", "Challenge", "Expedition", "Event Stages"])
    
    ; Event Listener: Fires whenever 'vMode' changes selection
    modeDDL.OnEvent("Change", UpdateGuiVisibility)

    ; Sleep Input (Positioned right below Game Mode selection)
    MyGui.Add("Text", "x15 y+20 w75", "Sleep (ms):")
    MyGui.Add("Edit", "x+2 yp-3 w73 vSleepMs", "1000")
    
    ; Helper text
    MyGui.SetFont("s8 cGray")
    MyGui.Add("Text", "x15 y+2 w150", "1sec = 1000")
    MyGui.SetFont("s10 cDefault")

    ; --- UNIT PLACEMENT BUTTON ---
    btnUnitPlacement := MyGui.Add("Button", "x15 y145 w150 h32", "Unit Placement")
    btnUnitPlacement.OnEvent("Click", (*) => OpenUnitPlacementGUI())

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

    txtEventStage := MyGui.Add("Text", "x185 y15 w150 Center", "Select Event Stage:")
    ddlEventStage := MyGui.Add("DropDownList", "x185 y+5 w150 vEventMapStage Choose1", ["Stage 1", "Stage 2", "Stage 3"])

    ; Challenge Controls
    txtChall  := MyGui.Add("Text", "x185 y15 w150 Center", "Challenge Only:")
    txtChall2 := MyGui.Add("Text", "x185 y+2 w150 Center", "(Auto Start OFF)")

    btnWebhook := MyGui.Add("Button", "x185 y145 w150 h32", "Configure Webhook")
    btnWebhook.OnEvent("Click", (*) => webhookConfig())

    ; --- BOTTOM SECTION ---
    MyGui.Add("Text", "x15 y200 w320 vWinText Center", "F9: Start / Pause / Resume | F8: Reload | ESC: Stop")

    ; Initial hide/show call on startup
    UpdateGuiVisibility()
}

webhookConfig(){
    global WebhookGui, MyGui, IniFile
    
    ; Safely check if WebhookGui exists AND its window is open
    if (IsSet(WebhookGui) && WebhookGui && WinExist("ahk_id " . WebhookGui.Hwnd)) {
        WebhookGui.Show()
        return
    }

    WebhookGui := Gui("+Owner" . MyGui.Hwnd . " +AlwaysOnTop", "Webhook Configuration")

    ; Title
    WebhookGui.SetFont("s16 bold", "Segoe UI")
    WebhookGui.AddText("x20 y15 w480 Center", "Webhook Settings")

    ; Read saved URL
    savedWebhook := IniRead(IniFile, "Webhook", "URL", "")
    cleanDisplayUrl := RegExReplace(savedWebhook, '[\[\]"]')

    ; Input Label
    WebhookGui.SetFont("s10 norm", "Segoe UI")
    WebhookGui.AddText("x20 y65 w480", "Discord Webhook URL:")

    ; -Wrap prevents text wrapping without showing a ugly scrollbar bar
    edtWebhook := WebhookGui.AddEdit("x20 y88 w480 h28 -Wrap vWebhookUrl", cleanDisplayUrl)

    ; Save Button
    btnSave := WebhookGui.AddButton("x200 y135 w120 h32 Default", "Save")
    btnSave.OnEvent("Click", (*) => SaveWebhook(edtWebhook.Value))

    WebhookGui.Show("w520 h185")
}

SaveWebhook(urlValue) {
    global IniFile, WebhookGui, myWebhookURL
    
    ; Remove any existing quotes/brackets typed by the user
    cleanUrl := RegExReplace(Trim(urlValue), '[\[\]"]')
    
    ; In AHK v2, two double quotes ("") inside a string literal produce a literal double quote
    formattedUrl := '"' . cleanUrl . '"'
    
    ; 1. Write formatted URL to settings.ini
    IniWrite(formattedUrl, IniFile, "Webhook", "URL")
    
    ; 2. Update active global variable immediately
    myWebhookURL := formattedUrl
    
    MsgBox("Webhook URL saved", "Saved", "4096 Iconi")
    
    if IsSet(WebhookGui) && WebhookGui
        WebhookGui.Destroy()
}
; ==============================================================================
; UNIT PLACEMENT GUI (CHILD WINDOW)
; ==============================================================================
OpenUnitPlacementGUI() {
    global unitPlacementGui, guiControls

    ; Bring existing window to front if already open
    if (unitPlacementGui && WinExist("ahk_id " . unitPlacementGui.Hwnd)) {
        unitPlacementGui.Show()
        return
    }

    unitPlacementGui := Gui("+Owner" MyGui.Hwnd " +AlwaysOnTop", "Unit placements")

    ; Title
    unitPlacementGui.SetFont("s20 bold", "Segoe UI")
    unitPlacementGui.AddText("x350 y15 w300 Center", "Unit placements")

    ; Save Button
    unitPlacementGui.SetFont("s10 norm", "Segoe UI")
    btnSave := unitPlacementGui.AddButton("x840 y15 w120 h32", "Save")
    btnSave.OnEvent("Click", (*) => SaveAllData())

    ; --- LEFT SECTION: 4 SLOT BOXES ---
    numSlots   := 4
    slotWidth  := 180
    slotHeight := 280
    startX     := 20
    startY     := 65
    gap        := 15

    Loop numSlots {
        currentX := startX + (A_Index - 1) * (slotWidth + gap)
        slotKey  := "Slot" A_Index
        
        unitPlacementGui.SetFont("s12 bold", "Segoe UI")
        unitPlacementGui.AddGroupBox("x" currentX " y" startY " w" slotWidth " h" slotHeight, "Slot " A_Index)
        
        contentX := currentX + 12
        fieldW   := slotWidth - 24
        
        ; 1. Unit Name
        unitPlacementGui.SetFont("s9 bold", "Segoe UI")
        unitPlacementGui.AddText("x" contentX " y" startY + 30, "Unit " A_Index " name:")
        unitPlacementGui.SetFont("s9 norm", "Segoe UI")
        savedName := IniRead(IniFile, slotKey, "Name", "")
        guiControls[slotKey . "_Name"] := unitPlacementGui.AddEdit("x" contentX " y" startY + 50 " w" fieldW, savedName)
        
        ; 2. Placements
        unitPlacementGui.SetFont("s9 bold", "Segoe UI")
        unitPlacementGui.AddText("x" contentX " y" startY + 85, "Placements:")
        unitPlacementGui.SetFont("s9 norm", "Segoe UI")
        savedPlace := IniRead(IniFile, slotKey, "Placements", "1")
        ddlPlace := unitPlacementGui.AddDDL("x" contentX " y" startY + 105 " w" fieldW, ["1", "2", "3"])
        ddlPlace.Text := savedPlace
        guiControls[slotKey . "_Placements"] := ddlPlace
        
        ; 3. Coordinate Button
        unitPlacementGui.SetFont("s9 norm", "Segoe UI")
        btnCoord := unitPlacementGui.AddButton("x" contentX " y" startY + 220 " w" fieldW " h30", "Coordinate")
        btnCoord.OnEvent("Click", OpenCoordPopup.Bind("Slot " A_Index, slotKey))
    }

    ; --- RIGHT SECTION: SIDE PANEL ---
    rightX := startX + 4 * (slotWidth + gap) + 10

    ; Senku Box & Button
    unitPlacementGui.SetFont("s11 bold", "Segoe UI")
    unitPlacementGui.AddGroupBox("x" rightX " y" startY + 160 " w220 h60", "Senku")
    unitPlacementGui.SetFont("s9 norm", "Segoe UI")
    btnSenku := unitPlacementGui.AddButton("x" (rightX + 15) " y" startY + 180 " w190 h30", "Coordinate")
    btnSenku.OnEvent("Click", OpenCoordPopup.Bind("Senku", "Senku"))

    ; Ramen Box & Button
    unitPlacementGui.SetFont("s11 bold", "Segoe UI")
    unitPlacementGui.AddGroupBox("x" rightX " y" startY + 230 " w220 h60", "Ramen")
    unitPlacementGui.SetFont("s9 norm", "Segoe UI")
    btnRamen := unitPlacementGui.AddButton("x" (rightX + 15) " y" startY + 250 " w190 h30", "Coordinate")
    btnRamen.OnEvent("Click", OpenCoordPopup.Bind("Ramen", "Ramen"))

    unitPlacementGui.Show("w1040 h370")
}


; ==============================================================================
; SAVE FUNCTIONALITY
; ==============================================================================
SaveAllData() {
    Loop 4 {
        key := "Slot" A_Index
        IniWrite(guiControls[key . "_Name"].Value, IniFile, key, "Name")
        IniWrite(guiControls[key . "_Placements"].Text, IniFile, key, "Placements")
    }
    
    MsgBox("All settings saved to settings.ini!", "Saved", "4096")
}


; ==============================================================================
; COORDINATE POPUP WINDOW FUNCTION
; ==============================================================================
OpenCoordPopup(slotTitle, iniSection, *) {
    popup := Gui("+Owner" unitPlacementGui.Hwnd " +AlwaysOnTop", "Coordinate")
    
    popup.SetFont("s20 bold", "Segoe UI")
    popup.AddText("x20 y20 w400", slotTitle " Coordinate")
    
    popup.SetFont("s10 norm", "Segoe UI")
    savedMap := IniRead(IniFile, iniSection, "Map", "School Grounds")
    
    mapDDL := popup.AddDDL("x600 y65 w180", ["School Grounds", "Flower Forest", "Rose Kingdom", "Fairy King Forest", "King's Tomb", "Spirit1", "Spirit2", "Spirit3", "Expeditions", "Villain1", "Villain2", "Villain3"])

    try {
        mapDDL.Text := savedMap
    } catch {
        mapDDL.Choose(1)
    }
    
    editsMap := Map()
    
    popupSave := popup.AddButton("x600 y20 w180 h35", "Save")
    popupSave.OnEvent("Click", (*) => SaveCoords(popup, iniSection, mapDDL, editsMap))
    
    unitWidth := 240, unitHeight := 130, pStartX := 20, pStartY := 110, pGap := 15
    
    mapDDL.OnEvent("Change", (*) => LoadCoordsForMap(iniSection, mapDDL.Text, editsMap))

    Loop 3 {
        currX := pStartX + (A_Index - 1) * (unitWidth + pGap)
        popup.SetFont("s12 bold", "Segoe UI")
        popup.AddGroupBox("x" currX " y" pStartY " w" unitWidth " h" unitHeight, "Unit" A_Index)
        boxInnerX := currX + 15
        
        savedX := IniRead(IniFile, iniSection, mapDDL.Text . "_Unit" A_Index "_X", "0")
        savedY := IniRead(IniFile, iniSection, mapDDL.Text . "_Unit" A_Index "_Y", "0")
        
        popup.SetFont("s11 bold", "Segoe UI")
        popup.AddText("x" boxInnerX " y" pStartY + 30 " w90 Center", "X")
        popup.SetFont("s10 norm", "Segoe UI")
        editX := popup.AddEdit("x" boxInnerX " y" pStartY + 52 " w90 Center", savedX)
        
        popup.SetFont("s11 bold", "Segoe UI")
        popup.AddText("x" (boxInnerX + 110) " y" pStartY + 30 " w90 Center", "Y")
        popup.SetFont("s10 norm", "Segoe UI")
        editY := popup.AddEdit("x" (boxInnerX + 110) " y" pStartY + 52 " w90 Center", savedY)
        
        editsMap["Unit" A_Index "_X"] := editX
        editsMap["Unit" A_Index "_Y"] := editY
        
        popup.SetFont("s10 norm", "Segoe UI")
        btnSel := popup.AddButton("x" boxInnerX " y" pStartY + 88 " w200 h30", "Select Coord")
        btnSel.OnEvent("Click", OpenImagePicker.Bind(popup, mapDDL, editX, editY, editsMap, iniSection))
    }
    
    popup.Show("w805 h260")
}

LoadCoordsForMap(section, mapName, editsMap) {
    Loop 3 {
        xVal := IniRead(IniFile, section, mapName . "_Unit" A_Index "_X", "0")
        yVal := IniRead(IniFile, section, mapName . "_Unit" A_Index "_Y", "0")
        editsMap["Unit" A_Index "_X"].Value := xVal
        editsMap["Unit" A_Index "_Y"].Value := yVal
    }
}

SaveCoords(popupObj, section, mapDDL, editsMap) {
    selectedMap := mapDDL.Text
    IniWrite(selectedMap, IniFile, section, "Map")
    Loop 3 {
        IniWrite(editsMap["Unit" A_Index "_X"].Value, IniFile, section, selectedMap . "_Unit" A_Index "_X")
        IniWrite(editsMap["Unit" A_Index "_Y"].Value, IniFile, section, selectedMap . "_Unit" A_Index "_Y")
    }
    MsgBox(section . " coordinates saved for " . selectedMap . "!", "Saved", "4096")
}


; ==============================================================================
; IMAGE PICKER WINDOW
; ==============================================================================
OpenImagePicker(parentPopup, ddlCtrl, targetEditX, targetEditY, activeEditsMap, activeSection, *) {
    selectedMap := ddlCtrl.Text
    
    imagePath := ImageFolder . "\" . selectedMap . ".png"
    if !FileExist(imagePath)
        imagePath := ImageFolder . "\" . selectedMap . ".jpg"
    
    if !FileExist(imagePath) {
        result := MsgBox("Image not found: " . selectedMap . " (.png or .jpg)`n`nExpected Folder:`n" . ImageFolder . "`n`nWould you like to open the image folder?", "Missing Image", "4096 YesNo Icon!")
        if (result == "Yes")
            Run(ImageFolder)
        return
    }

    imgGui := Gui("+Owner" parentPopup.Hwnd " +AlwaysOnTop -Caption", "Pick Coordinate")
    
    try {
        picCtrl := imgGui.AddPicture("x0 y0 w800 h600", imagePath)
    } catch Error as err {
        imgGui.Destroy()
        MsgBox("Failed to load image control!`n`nFile: " . imagePath . "`n`nDetails: " . err.Message, "Image Load Error", "4096 Icon!")
        return
    }

    sectionsToScan := ["Slot1", "Slot2", "Slot3", "Slot4", "Senku", "Ramen"]
    colorList      := ["Red", "00FF00", "00FFFF", "Yellow", "FF00FF", "FFA500"]
    
    for secIdx, secName in sectionsToScan {
        mColor := colorList[secIdx]
        prefix := (secName == "Senku") ? "Sen" : (secName == "Ramen") ? "Ram" : ("S" . SubStr(secName, 5))
        
        Loop 3 {
            uX := 0
            uY := 0
            
            if (secName == activeSection) {
                try {
                    uX := Integer(activeEditsMap["Unit" A_Index "_X"].Value)
                    uY := Integer(activeEditsMap["Unit" A_Index "_Y"].Value)
                }
            }
            
            if (uX <= 0 || uY <= 0) {
                try {
                    uX := Integer(IniRead(IniFile, secName, selectedMap . "_Unit" A_Index "_X", "0"))
                    uY := Integer(IniRead(IniFile, secName, selectedMap . "_Unit" A_Index "_Y", "0"))
                }
            }
            
            if (uX > 0 && uY > 0) {
                DrawMarker(imgGui, uX, uY, prefix . "-U" A_Index, mColor)
            }
        }
    }

    picCtrl.OnEvent("Click", (ctrl, *) => OnMapClick(imgGui, targetEditX, targetEditY))
    imgGui.Show("w800 h600")
}

DrawMarker(guiObj, x, y, label, colorHex) {
    guiObj.SetFont("s11 bold c" . colorHex, "Segoe UI")
    guiObj.AddText("x" (x - 10) " y" (y - 12) " w24 h24 BackgroundTrans Center", "⊕")
    
    guiObj.SetFont("s8 bold cWhite", "Segoe UI")
    guiObj.AddText("x" (x + 8) " y" (y - 12) " w45 h15 BackgroundTrans", label)
}

OnMapClick(imgGuiObj, targetEditX, targetEditY) {
    CoordMode("Mouse", "Client")
    MouseGetPos(&mouseX, &mouseY)
    
    targetEditX.Value := mouseX
    targetEditY.Value := mouseY
    
    imgGuiObj.Destroy()
    
    ToolTip("Captured Coords: X=" mouseX " | Y=" mouseY)
    SetTimer () => ToolTip(), -1500
}


; ==============================================================================
; NAVIGATION / HELPER FUNCTIONS
; ==============================================================================
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
    txtEventStage.Visible := false
    ddlEventStage.Visible := false

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
            txtRaid.Visible   := true
            ddlRaid.Visible   := true
            txtStage2.Visible := true
            ddlStage2.Visible := true

        case "Event Stages":
            txtEventStage.Visible := true
            ddlEventStage.Visible := true
    }
}

MoveGui(){
    global MyGui, RobloxWindow

    if WinExist(RobloxWindow) {
        WinGetPos(&x, &y, &w, &h, RobloxWindow)
        MyGui.Show("x" (x + w - 10) " y" y " w350 h275")
    } else {
        MyGui.Show("w350 h275")
    }
}

StartGameplay(){
    selectedMode := MyGui["Mode"].Text

    Switch selectedMode {
        Case "Story":
            StoryGameplay()
        Case "Raid":
            RaidGameplay()
        Case "Challenge":
            ChallengeGameplay()
        Case "Expedition":
            ExpeditionGameplay()
        Case "Event Stages":
            EventGameplay()
    }
}
#Requires AutoHotkey v2.0

; --- DIRECTORIES ---
IniFile     := A_ScriptDir . "\settings.ini"
ImageFolder := A_ScriptDir . "\img"

if !DirExist(ImageFolder)
    DirCreate(ImageFolder)


; --- CREATE MAIN GUI ---
myGui := Gui("+AlwaysOnTop", "Unit placements")

; Title
myGui.SetFont("s20 bold", "Segoe UI")
myGui.AddText("x350 y15 w300 Center", "Unit placements")

; Top Right Save Button
myGui.SetFont("s10 norm", "Segoe UI")
btnSave := myGui.AddButton("x840 y15 w120 h32", "Save")
btnSave.OnEvent("Click", (*) => SaveAllData())


; --- STORE CONTROL REFERENCES ---
guiControls := Map()

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
    
    myGui.SetFont("s12 bold", "Segoe UI")
    myGui.AddGroupBox("x" currentX " y" startY " w" slotWidth " h" slotHeight, "Slot " A_Index)
    
    contentX := currentX + 12
    fieldW   := slotWidth - 24
    
    ; 1. Unit Name
    myGui.SetFont("s9 bold", "Segoe UI")
    myGui.AddText("x" contentX " y" startY + 30, "Unit " A_Index " name:")
    myGui.SetFont("s9 norm", "Segoe UI")
    savedName := IniRead(IniFile, slotKey, "Name", "")
    guiControls[slotKey . "_Name"] := myGui.AddEdit("x" contentX " y" startY + 50 " w" fieldW, savedName)
    
    ; 2. Placements
    myGui.SetFont("s9 bold", "Segoe UI")
    myGui.AddText("x" contentX " y" startY + 85, "Placements:")
    myGui.SetFont("s9 norm", "Segoe UI")
    savedPlace := IniRead(IniFile, slotKey, "Placements", "1")
    ddlPlace := myGui.AddDDL("x" contentX " y" startY + 105 " w" fieldW, ["1", "2", "3"])
    ddlPlace.Text := savedPlace
    guiControls[slotKey . "_Placements"] := ddlPlace
    
    ; 3. Coordinate Button
    myGui.SetFont("s9 norm", "Segoe UI")
    btnCoord := myGui.AddButton("x" contentX " y" startY + 220 " w" fieldW " h30", "Coordinate")
    btnCoord.OnEvent("Click", OpenCoordPopup.Bind("Slot " A_Index, slotKey))
}


; --- RIGHT SECTION: SIDE PANEL ---
rightX := startX + 4 * (slotWidth + gap) + 10

; Senku Box & Button
myGui.SetFont("s11 bold", "Segoe UI")
myGui.AddGroupBox("x" rightX " y" startY + 160 " w220 h60", "Senku")
myGui.SetFont("s9 norm", "Segoe UI")
btnSenku := myGui.AddButton("x" (rightX + 15) " y" startY + 180 " w190 h30", "Coordinate")
btnSenku.OnEvent("Click", OpenCoordPopup.Bind("Senku", "Senku"))

; Ramen Box & Button
myGui.SetFont("s11 bold", "Segoe UI")
myGui.AddGroupBox("x" rightX " y" startY + 230 " w220 h60", "Ramen")
myGui.SetFont("s9 norm", "Segoe UI")
btnRamen := myGui.AddButton("x" (rightX + 15) " y" startY + 250 " w190 h30", "Coordinate")
btnRamen.OnEvent("Click", OpenCoordPopup.Bind("Ramen", "Ramen"))

myGui.Show("w1040 h370")
myGui.OnEvent("Close", (*) => ExitApp())


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
    popup := Gui("+Owner" myGui.Hwnd " +AlwaysOnTop", "Coordinate")
    
    popup.SetFont("s20 bold", "Segoe UI")
    popup.AddText("x20 y20 w400", slotTitle " Coordinate")
    
    popup.SetFont("s10 norm", "Segoe UI")
    savedMap := IniRead(IniFile, iniSection, "Map", "School Grounds")
    
    mapDDL := popup.AddDDL("x600 y65 w180", ["School Grounds", "Flower Forest", "Rose Kingdom", "Fairy King Forest", "King's Tomb"])

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
    popupObj.Destroy()
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
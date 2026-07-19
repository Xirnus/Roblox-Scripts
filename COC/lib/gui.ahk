#Requires AutoHotkey v2.0

main := Gui("+AlwaysOnTop", "My First GUI")
main.AddText("x10 y10", "F9 to show roblox")


; Create dropdown with default selection
ddl := main.Add("DropDownList", "vStageChoice w150", ["Namek", "Sand", "Double", "Shibuya", "Underground", "Spirit", "Martial"])

; Create dropdown with default selection
adl := main.Add("DropDownList", "vActChoice w100", ["Act 1", "Act 2", "Act 3", "Act 4", "Act 5", "Act 6", "Infinite"])

showGUI() {
    main.Show("w400 h400")
}

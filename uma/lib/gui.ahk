#Requires AutoHotkey v2.0

main := Gui("+AlwaysOnTop", "Uma GUI")
main.AddText("x10 y10", "F9 to show game")


showGUI() {
    main.Show("w400 h400")
}

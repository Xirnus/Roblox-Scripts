#Requires AutoHotkey v2.0

#Include patterns.ahk
#Include mainfunctions.ahk


goToEvent(){
    ToolTip("Waiting for lobby...")
    while !checkImage(lobby){
        Sleep(500)
    }
    if (checkImage(lobby)){
        BetterClick(767, 475)
        Sleep(300)
        BetterClick(492, 333)
        Sleep(300)
        Send("{a down}")
        Sleep(3300)
        Send("{a up}")
        Sleep(500)
        Send("{w down}")
        Sleep(4300)
        Send("{w up}")
        ToolTip("")
    }
}

findMatch(){
    BetterClick(467, 323)
    Sleep(300)
    try {
        text := OCR(237, 290, 341, 49)
        text := RegExReplace(String(text), "[^0-9]")

        ToolTip("Detected text:`n`n" text, 100, 100)
        BetterClick(399, 341)
        Sleep(300)
        TypeNumberCaptcha(text)
        Sleep(300)
        BetterClick(316, 389)
    } catch Error as err {
        ToolTip("OCR error:`n" err.Message, 100, 100)
    }
}
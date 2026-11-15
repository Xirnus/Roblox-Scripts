#Requires AutoHotkey v2.0

#Include patterns.ahk
#Include mainfunctions.ahk


goToEvent(){
    ToolTip("Waiting for lobby...")
    while !checkImage(lobby){
        ToolTip("Lobby Not found", 100, 100)
        Sleep(500)
    }
    while true{
        Sleep(1000)
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
        if (checkImage(matchFind, 238, 245, 316, 292)){
            ToolTip("Matchmaking found", 100, 100)
            break
        }
    }
}

findMatch(){
    while true{
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

        if (checkImage(lobby)){
            return true ; lobby is still found
        }
        return false ; left lobby
    }
}
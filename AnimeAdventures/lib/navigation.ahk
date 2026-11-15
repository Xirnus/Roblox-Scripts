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

goToStory(){
    ToolTip("Waiting for lobby...")
    while !checkImage(lobby){
        ToolTip("Lobby Not found", 100, 100)
        Sleep(500)
    }
    while true{
        Sleep(5000)
        BetterClick(767, 475)
        Sleep(300)
        BetterClick(492, 333)
        Sleep(300)
        BetterClick(412, 340)
        Sleep(300)
        Send("{d down}")
        Sleep(2000)
        Send("{d up}")
        Sleep(500)
        Send("{w down}")
        Sleep(3000)
        Send("{w up}")
        ToolTip("")
        BetterClick(785, 326)
        Sleep(300)
        Send "{WheelDown 20}"
        Sleep(300)
        BetterClick(700, 420)
        Sleep(300)
        BetterClick(285, 237)
        Sleep(300)
        BetterClick(400, 440)
        Sleep(300)
        BetterClick(335, 325)
        Sleep(300)
        BetterClick(400, 470)
        Sleep(5000)
        break
    }
}

goToPortal(){
    BetterClick(40, 300)
    Sleep(300)
    BetterClick(530, 230)
    Sleep(300)
    BetterClick(513, 183)
    Sleep(300)
    Send("Shib")
    BetterClick(217, 288)
    Sleep(300)
    BetterClick(325, 377)
    Sleep(300)
    BetterClick(250, 355)
    Sleep(300)
    BetterClick(408, 470)
    Sleep(300)
}

nextPortal(){
    BetterClick(323, 399)
    Loop 5{
        BetterClick(100,100)
    }
    Sleep(300)
    Send("f")
    Sleep(300)
    BetterClick(486, 121)
    Sleep(300)
    BetterClick(470, 186)
    Send("Shib")
    BetterClick(217, 288)
    Sleep(300)
    BetterClick(325, 409)
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

        Sleep(20000)

        if (checkImage(lobby)){
            return true ; lobby is still found
        }
        return false ; left lobby
    }
}

runFinished(){
    Sleep(300)
    BetterClick(320, 400)
	Sleep(300)
    Loop 5{
        BetterClick(100, 100)
    Sleep(300)
    }
    Sleep(300)
    BetterClick(310, 122)
}

returnToLobby(){
    Sleep(300)
    Send("f")
    Sleep(300)
    BetterClick(30, 575)
    Sleep(300)
    BetterClick(405, 211)
    Sleep(300)
    Send "{WheelDown 2}"
    Sleep(300)
    BetterClick(530, 279)
}
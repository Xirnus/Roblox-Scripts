#Include FindText.ahk
#Include placeUnits.ahk


global WinCount := 0
global LoseCount := 0

global gameDC:="|<dced>*153$122.zzzzzzzzzzzzzzzzzzzzzzwzzzzzzzzzzzzzzzzzC1yDzzzzzzzzzzzznzzznU7nzzzzzzzzzzzzwzzzwtkzzzzzzzzzzzzzzDzzzCTDzzzzzzzzzzzzznzzznblnsTVwDm7m7wDsE7Vy4twQs3UA1w0w0w1s01UD0CTbCBsqCD6D6CCSBnlnXXbtnXwTXnnnnnbn7wwyMwtwQwDDtwQwwws0nzD06TCT7DknyT7DDDC0Aznk1bnbnnzATXnnnnnbz7wwzswtkwtn3sswwwwsxkz77iCC0TC0s30TDDDD0S0kM3k3UTnkT1wDnnnnwDkS7Vy4zzzzzzzzzzzzzzzzzzzzy"

gameDCED(){
    if (ok := FindText(&X, &Y, 0, 0, 816, 638, 0, 0, gameDC)) {
        BetterClick(496, 416) ; Reconnect Button
        return true
    }
    return false
}

; Common functions
BetterClick(x, y) {
    MouseMove(x, y)
    MouseMove(1, 0, , "R")
    Sleep(100)
    MouseClick("Left", -1, 0, , , , "R")
    Sleep(50)
}

ClickMethod(button, x, y, clickDelay := 0) {
    MouseMove(x, y)
    MouseMove(1, 0, , "R")
    MouseClick("Left", -1, 0, , , , "R")
}

LookDown() {
    BetterClick(411, 330)
    loop 40 {
        SendInput("{WheelUp}")
        Sleep 50
    }
    Sleep 1000
    MouseGetPos(&x, &y)
    SendInput(Format("{Click {} {} Left}", x, y + 200))
    Sleep 1000
    loop 40 {
        SendInput("{WheelDown}")
        Sleep 50
    }
}

VoteStart() {
    BetterClick(367, 545)
    Sleep 400
    Send("{Tab}") 
}

lobby(){
    if (ok:=FindText(&X, &Y, 0, 0, 816, 638, 0, 0, lobbycheck))
    {
        Send("{Tab}") 
        sleep 300
        BetterClick(640, 185)
        sleep 300
        BetterClick(70, 478)
        sleep 300
        BetterClick(320, 211)
        sleep 300
        BetterClick(409, 444)
    }
}

Ingame(){
    while !(FindText(&X, &Y, 0, 0, 816, 638, 0, 0, FindUnitManager))
    {
        sleep 500
    }
}

CheckLobbyReset() {
    if (ok := FindText(&X, &Y, 0, 0, 816, 638, 0, 0, lobbycheck)) {
        return true  ; Detected lobby — means game reset or ended
    }
}



Results(mode := 2) {
	global WinCount, LoseCount


    ; Wait until the result window is found
    while (!FindText(&X, &Y, 8, 31, 809, 627, 0, 0, gameResult)) {
        BetterClick(100, 100)
        Sleep 400
        if (CheckLobbyReset()) {
            return false  ; Early exit — signal to outer loop
        }
    }

    if FindText(&X, &Y, 8, 31, 809, 627, 0, 0, win) {
         WinCount += 1
    } else{
        LoseCount += 1
    }
    UpdateWinLossText()
    Sleep 4000

    if (mode = 1) {
        BetterClick(439, 427)  ; Retry WITH next
    } else {
        BetterClick(389, 427)  ; Retry WITHOUT next
    }
    return true
}



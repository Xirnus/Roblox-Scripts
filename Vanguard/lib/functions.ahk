#Include FindText.ahk
#Include storyStages.ahk

t1:=A_TickCount, Text:=X:=Y:=""

lobbyFind:="|<lobbyFind>*118$37.z03zMzzw1zwTz306Tjz0i7Dzz6zzbzz7sA233Xg210ZlwM80Ewu840QS0Uk88DksQ667zzzzzzU"
areas:="|<areas>*125$38.zzzzzzzzzzzzzxzzzzzyDzzzzzXzzzzzkM8A27wa230by0X028TU8kMX7lkC301wyLks8TzzzzzzU"
playButton:="|<playTeleport>*113$44.zzzzzzzy1tzywyTUCTz6DXs1bzVllyA9zsA8TbWTw3UDtkbz0Q7y0NzX71zUCTs1szs7bw0CDyTsz7XXzby03wMztzU4z6Dzzzzzzzy"
closeButton:="|<closeButton>*127$14.zzzzz7Xkkw0DU7w3zVzkDs1y0T33UkMz7zzU"
leaveButton:="|<leaveButton>*111$45.zzzzzzzzzzzzzzztzzzzzzzDzzzzzztzrzzzvzDsC0CA7ty0U1n0TDX0l4FXtw16A60zDnw1Utzs21UCD0z0MC1nw7zzzzzzzzzzzzzzzU"
createButton:="|<createMatch>*100$71.000000000010003U0Q7070DU00DU1gP0T0N000F02BW0W0XDxzXzYC7z7z7gC23Vc8A4721E8421E0E844160A8nU00ME8206Mk74EAlXlYO8lXOBUFX4XA21VUIT43316A63XUgXA773ATzxzzT7zvzzyD7klsA3DVXXA000000000004"
startButton:="|<startButton>*100$46.3U000000klk000Q61cU0028E2W0008V6KCDzzXYTU/4k82EC0s10090830420X0ssMFyCTVWVV48VC6C64EX80cA0F22E2Uk1488UF2kAEEVy3lzy0wU"

spectateButton:="|<spectateButton>*100$19.zzzzzzzzzzzzzwtzs0Ds03zUDzsDzzzzzzzzRzvTPzzzzzzzzzzzzz"


upgrade0:="|<Upgrade0>*78$69.zzzzzzzzzzzzzzzzzzzzzzzrbzzzzyTy6AAQzzzzzXzlUlXbzzzzwRyAXAQUM08423l6NXY3010UEC8nCQW10l0U1n6Nn4E86840SMXC1UM0s423nUtsQ7UjUkMSS7DzXvDzzzznztzyT1zzzzz7wDzrwzzzzzsznzzzzzzzzzzzzzzzzzzzzzzzU"

lobbyFound:= false
lobbysequence := [areas, playButton, closeButton]


X := Y := 0

BetterClick(x, y) { ; credits to yuh for this, lowk a life saver
    MouseMove(x, y)
    MouseMove(1, 0, , "R")
    Sleep(100)
    MouseClick("Left", -1, 0, , , , "R")
    Sleep(50)
}

storyAct(){
    if (ok := FindText(&X, &Y, 8, 31, 809, 627, 0, 0, createButton)) { 
        BetterClick(X, Y)
        Sleep(100)

    }
}

lobby() {
    global X, Y, lobbyFound
    t1 := A_TickCount
    lobbyFound := false
    while !(ok := FindText(&X, &Y, 8, 31, 805, 630, 0, 0, lobbyFind)) {
        if (A_TickCount - t1 > 10000) {
            MsgBox("Failed to find lobby button")
            return false
        }
        Sleep(100)
    }
    lobbyFound := true
    return true
}

story(){
    global X, Y, lobbyFound
    if (lobbyFound) {
            for i, button in lobbysequence {
                t1 := A_TickCount
                while !(ok := FindText(&X, &Y, 8, 31, 809, 627, 0, 0, button)) {
                    if (A_TickCount - t1 > 10000) {
                        MsgBox("Failed to find button: " . button)
                        break
                    }
                    Sleep(100)
                }
                if ok {
                    if (i = 2) {
                        offsetX := 100
                        BetterClick(X + offsetX, Y)
                    } else{
                        BetterClick(X, Y)
                    }
                Sleep(500)
                }
            }

            if (story) {
            count := 5
            i := 1
            while (i <= count) {
                Send("{s down}") ; Press and hold the "s" key
                Sleep(1000)      ; Hold it for 1 second
                Send("{s up}")   ; Release the "s" key
                Sleep(100) ; optional delay
                i++
            }
            count := 5
            i := 1
            while (i <= count) {
                Send("{d down}") ; Press and hold the "s" key
                Sleep(1000)      ; Hold it for 1 second
                Send("{d up}")   ; Release the "s" key
                Sleep(100) ; optional delay
                i++
            }
            Sleep(1000)
            if (ok := FindText(&X, &Y, 8, 31, 809, 627, 0, 0, createButton)) {
                BetterClick(X, Y)
                Sleep(500)
                clickStageAndAct(ddl.Text, adl.Text)
                Sleep(500)
            }
            if (ok := FindText(&X, &Y, 8, 31, 809, 627, 0, 0, startButton)) {
                BetterClick(X, Y)
            }
        }
    }
}

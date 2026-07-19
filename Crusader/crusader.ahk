#Requires AutoHotkey v2.0

#Include lib\FindText.ahk
#Include lib\gui.ahk
#Include lib\mainFunctions.ahk

CoordMode("Mouse", "Screen")
RobloxWindow := "ahk_exe RobloxPlayerBeta.exe"
Esc::ExitApp  ; Exit script with Escape key

ShowGUI()

F9:: {
    if WinExist(RobloxWindow) {
        WinActivate(RobloxWindow)
        Sleep(50)
        WinMove(0, 0, 800, 600, RobloxWindow)
        while (true) {
            Macro()
            sleep(15000)
        }
    }
}

VoteStart:="|<>*106$25.zzzzzzzzzzzzzzXzzzlzzzkTzs00Ds007y003z001zUC0zkTkTkTs7UDy0k7z0M3zUD1zkTkTkTs7kDw007y003z001zU00zzkTzzwTzk"
UnitPlaced:="|<>*114$14.Dzbzz01k0LlwwS340l04E140F04E140l07kU"
UpgManager:="|<UpgManager>*125$71.nyTzzzzzzzzzXszzzzzzzzzz7lvinyvvjbqy730Q3k70Q3VsAAMlX6AMna7mGNlX4QFlUATa4XXC8sXW0NvAN76QFl24TnqNX0Mtk70Q36cz70lnkD4w6BTzzzzzzxlzzyw3byttzk7TzV0000001kw40+0000001zk03o0000001y00080000000U2pTE00000000000E"
Victory:="|<Victory>*121$165.000000000000000000000000000000000000000000000000000000000000000000000000000000000007zU3zzs0zwDzzz0Ty0Dzy3zk7z00zy0zzzUTzzzzzwDzy3zzyzz1zw0C0sC0UAD03s001bk1sM03z0MQ1U0k31UA1XU07000Bk03X003s1X0Q060QA1UAs00M001w00CM007UCs300M1XUA1i001000D000P000Q0y0k030AM3UDU008001k003s003k7UC00Q1r0Q1s003000A000D000C0Q1U01U6k7UD0Dkzw1zU7s0s3s1s10Q00C0y0w1s3zjzUDw1zU70TUDU03000k3U7UC0MDUQ1X0AC0s3A1g00k0060Q1w1k70s3UAM3Uk70TUBk0C000M3UBUC0k00Q1X0M60s3s1a01U003083g1k6003UAM30k7000AM0Q000Q00NUC0s70Q1X0Q60s0033U30001U07A1k31w3UAM1Vk7000sA0k000C00lUC0TxkQ1XUDw0s00C1U60000k06A1s1z73UAA0z07003UA0k000601VUD010QQ1VU1U1s00A1U60000M0AA1w001nUA6000T0Q0kA0k000303VUBk00CQ1Us003M3k71U60000Q0MA1b003XUA3U00v0S0MA0k0001U71UAQ00sQ1UC00SM3s1VU60000A0kA1Vs0S3UA0w0D30PUCA0k0000zy1zw7zzUDzU3zzkTzDzlzy00007zUDz0Dzk1zs07zs3zkzw7zU000000000010000000U00000000000000000000000000000000000004"
Defeat:="|<Defeat>*53$87.00000000000000000000000000000000000000000000000000000000007zzU1zzzjzzzzztzzzUTzzzzzzzzzA00y3001s00C001U00wM00D001k00A001n001s00C001U007M00D001k00A000P001s00C001U003s00D001k00A1y0D0Tzs3zy0ztUDs1s3zz0Tzk7zA1XU7003s3zy001UAA0s00T0Dzk00A1VU7003s00S001UAA0s00T003k00A1VU7003s00S001UAA0s1zv003k7zA1z0D0TzM00S0ztUDk1s3zz0Tzk7zA000T0Tzs3zq0ztU003M0070M0k00A000v000s306001U00CM0070M0k00A007X000s306001U07kM0070M0k00Dzzw3zzzzz07zzszzs0Dzzxzk0Tzz00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004"


Macro(){
    LogToConsole("Starting Macro - Checking if in game...")
    Sleep(1000)
    inGameCheck()
    LogToConsole("Setting game position...")
    Sleep(1000)
    inGamePosition()
    LogToConsole("Starting unit placement...")
    Sleep(1000)
    CombinedPlacement()
    LogToConsole("Starting unit upgrades...")
    Sleep(1000)
    UnitUpg()
    LogToConsole("Waiting for end game...")
    Sleep(1000)
    EndGameCheck()
}

MapPlacement(startX := 70, startY := 500, stepX := 60, stepY := 70, cols := 10, rows := 7, unitNumber := "4") {
    static placedPositions := Map() ; store placed positions as "x,y" => true

    x := startX
    y := startY
    Loop rows {
        curX := x
        Loop cols {
            posKey := curX "," y
            ; Check visually for UnitPlaced before clicking
            if (FindText(&X, &Y, curX-5, y-5, curX+5, y+5, 0, 0, UnitPlaced)) {
                placedPositions[posKey] := true
                curX += stepX
                continue
            }
            if placedPositions.Has(posKey) {
                curX += stepX
                continue
            }
            ; Send unit number before clicking
            Send(unitNumber)
            Sleep(100)
            BetterClick(curX, y)
            ; After clicking, use UnitSelect to check if unit was placed
            Sleep(700) ; give time for unit to appear
            if (FindText(&X, &Y, 0, 0, 816, 638, 0, 0, UnitPlaced)) {
                placedPositions[posKey] := true
                Sleep(100)
                BetterClick(100,100) ; Click away to reset selection
                return ; End the function after placing one unit
            } else {
                LogToConsole("Unit " . unitNumber . " NOT placed at " . curX . "," . y)
                Sleep(100)
            }
            curX += stepX
            Sleep(50) ; adjust as needed
        }
        y -= stepY
    }
}

MapPlacement_Clear() {
    static placedPositions := Map()
    placedPositions.Clear()
}


CombinedPlacement() {
    LogToConsole("Placing unit type 4 (1st)")
    Sleep(500)
    MapPlacement(70, 500, 60, 70, 12, 7, "6")
    Sleep(200)
    LogToConsole("Placing unit type 4 (2nd)")
    Sleep(500)
    MapPlacement(70, 500, 60, 70, 12, 7, "6")
    LogToConsole("Placing unit type 4 (3rd)")
    Sleep(500)
    MapPlacement(70, 500, 60, 70, 12, 7, "6")
    LogToConsole("Placing unit type 3")
    Sleep(500)
    MapPlacement(70, 500, 60, 70, 12, 7, "5")
    LogToConsole("Placing unit type 3")
    Sleep(500)
    MapPlacement(70, 500, 60, 70, 12, 7, "3")
    MapPlacement_Clear() ;clear map
}

upgNotCliked:="|<upgNotCliked>*50$15.z7zU3k0QD3Xs8zl7z0zs3yA7lUwC03k1zszU"

; Win/Loss counter variables
WinCount := 0
LossCount := 0

UnitUpg() {
    if (ok := FindText(&X, &Y, 0, 0, 800, 600, 0, 0, UpgManager)) {
        Send("c")
        Sleep(300)
        LogToConsole("Upgrading unit...")
        startX := 635
        startY := 173
        stepX := 126
        stepY := 88
        cols := 2
        rows := 5  ; Set how many rows you want

        Loop rows {
            y := startY + (A_Index - 1) * stepY  ; Changed to + and (A_Index - 1)
            Loop cols {
                x := startX + (A_Index - 1) * stepX
                BetterClick(x, y)
                Sleep(200)
            }
        }
        LogToConsole("Upgrade sequence done.")
        Sleep(500)
    } else {
        LogToConsole("UpgManager not found.")
        Sleep(1000)
    }
}
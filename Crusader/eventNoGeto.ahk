#Requires AutoHotkey v2.0

#Include lib\FindText.ahk
#Include lib\mainFunctions.ahk
#Include lib\gui.ahk
#Include lib\webhook.ahk

CoordMode("Mouse", "Screen")
RobloxWindow := "ahk_exe RobloxPlayerBeta.exe"
Esc::ExitApp  ; Exit script with Escape key
ShowGUI()

F9:: {
    if WinExist(RobloxWindow) {
        WinActivate(RobloxWindow)
        Sleep(50)
        WinMove(0, 0, 800, 600, RobloxWindow)
        LogToConsole("Macro Started")
        while (true) {
            gameplay()
            sleep(15000)
        }
    }
}

VoteStart:="|<>*98$31.Tjk00MyDUSCSDwzn6DDwxX61s6M64MXA7DAT77061VXU3UMntzyAlg1UAMr0kC7tzzy1kDny8"
UnitPlaced:="|<>*114$14.Dzbzz01k0LlwwS340l04E140F04E140l07kU"
UpgManager:="|<UpgManager>*125$71.nyTzzzzzzzzzXszzzzzzzzzz7lvinyvvjbqy730Q3k70Q3VsAAMlX6AMna7mGNlX4QFlUATa4XXC8sXW0NvAN76QFl24TnqNX0Mtk70Q36cz70lnkD4w6BTzzzzzzxlzzyw3byttzk7TzV0000001kw40+0000001zk03o0000001y00080000000U2pTE00000000000E"
Victory:="|<Victory>*121$165.000000000000000000000000000000000000000000000000000000000000000000000000000000000007zU3zzs0zwDzzz0Ty0Dzy3zk7z00zy0zzzUTzzzzzwDzy3zzyzz1zw0C0sC0UAD03s001bk1sM03z0MQ1U0k31UA1XU07000Bk03X003s1X0Q060QA1UAs00M001w00CM007UCs300M1XUA1i001000D000P000Q0y0k030AM3UDU008001k003s003k7UC00Q1r0Q1s003000A000D000C0Q1U01U6k7UD0Dkzw1zU7s0s3s1s10Q00C0y0w1s3zjzUDw1zU70TUDU03000k3U7UC0MDUQ1X0AC0s3A1g00k0060Q1w1k70s3UAM3Uk70TUBk0C000M3UBUC0k00Q1X0M60s3s1a01U003083g1k6003UAM30k7000AM0Q000Q00NUC0s70Q1X0Q60s0033U30001U07A1k31w3UAM1Vk7000sA0k000C00lUC0TxkQ1XUDw0s00C1U60000k06A1s1z73UAA0z07003UA0k000601VUD010QQ1VU1U1s00A1U60000M0AA1w001nUA6000T0Q0kA0k000303VUBk00CQ1Us003M3k71U60000Q0MA1b003XUA3U00v0S0MA0k0001U71UAQ00sQ1UC00SM3s1VU60000A0kA1Vs0S3UA0w0D30PUCA0k0000zy1zw7zzUDzU3zzkTzDzlzy00007zUDz0Dzk1zs07zs3zkzw7zU000000000010000000U00000000000000000000000000000000000004"
Defeat:="|<Defeat>*53$87.00000000000000000000000000000000000000000000000000000000007zzU1zzzjzzzzztzzzUTzzzzzzzzzA00y3001s00C001U00wM00D001k00A001n001s00C001U007M00D001k00A000P001s00C001U003s00D001k00A1y0D0Tzs3zy0ztUDs1s3zz0Tzk7zA1XU7003s3zy001UAA0s00T0Dzk00A1VU7003s00S001UAA0s00T003k00A1VU7003s00S001UAA0s1zv003k7zA1z0D0TzM00S0ztUDk1s3zz0Tzk7zA000T0Tzs3zq0ztU003M0070M0k00A000v000s306001U00CM0070M0k00A007X000s306001U07kM0070M0k00Dzzw3zzzzz07zzszzs0Dzzxzk0Tzz00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004"
CorrectPosition:="|<>*20$51.000000000000000000000000000000002000000000400000003U0000001w0000001yU000000zy000000Tzk00000Tzy00003zzzk000zzzzy001zzzzzs007zzzzz000zzzzzs007zzzzz000zzzzzw003zzzzzU00Tzzzzw003zzzzzU00Dzzzzw001zzzzzk007zzzzy000zzzzw"
CorrectPosition2:="|<>*20$71.zzzs00000001zzzs00000003zzzk00000007zzzU0000000DzzzU0000000Tzzz00000000zzzy00000001zzzw00000003zzzw00000007zzzs0000000Dzzzk0000000TzzzU0000000zzzzU0000003zzzz0000000Tzzzy0000007zzzzy000003zzzzzw00007zzzzzzs006Dzzzzzzzk00Dzzzzzzzzk00DzzzzzzzzU00Tzzzzzzzz000zzzzzzzzy001zzzzzzzzy001zzzzzzzzw003zzzz"



ResetButton:="|<>*106$91.zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz0Dtzzzzzztzzznz07szzzzzXszzzlzwTwTzzzzlwTzzszzD2C63ks0S1sC4Tzb0600k8070M621zn62A0F4SDUA210ztU1038mD7lYN7UzwlwXs4NbXwX8WMDyQ28470nsy1UMAXzD3667ktwT1sC6PzzzzzDzzzzzzzzzzzzzzbzzzzzzzzzzzzzzrzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzk"

;Gates
;Gates
D_Rank_Gate:="|<D>*105$9.zy7UQFbAtaA3UzzU"
C_Rank_Gate:="|<C>*104$9.zzXkC/bwzXy1sTzU"
B_Rank_Gate:="|<B>*117$8.zwC1UN6FaM61zs"
A_Rank_Gate:="|<A>*110$10.zzrzDsTVw3kC4Ntzy"
S_Rank_Gate:="|<S>*112$8.zwD3UwT1wM73zs"
National_Rank_Gate:="|<National>*125$44.zzzzzzzzzzzzzzzjzzTzzvlbwrzzww9z7vzzD2E0MEM3k044000wkN9AAADA0EM301vY666m2Tzzzzzzy"

global myWebhookURL := "https://discord.com/api/webhooks/1327049889707724921/HzxIn-kGezqNFrgKItswk2uKkOolwGJ4SO2vL5glJFObPP3E8d2_6GRRsNX5lhpw6NeT"
global maxTries := 20
global tries := 0

global farmxy := [
    [136, 414],
    [140, 364],
    [144, 293],
]

global aixy := [
    [215, 285]
]

global cidsxy := [
    [352, 188],
    [402, 188],
    [367, 223]
]

global getoxy := [
    [402, 223]
]

global gokuxy := [
    [426, 354],
    [463, 387],
    [327, 431],
    [365, 382],
    [370, 420]
]


; Win/Loss counter variables
WinCount := 0
LossCount := 0

FarmUnitUpg() {
    if (ok := FindText(&X, &Y, 0, 0, 800, 600, 0, 0, UpgManager)) {
        Send("c")
        Sleep(300)
        ;LogToConsole("Upgrading unit...")
        startX := 635
        startY := 173
        stepX := 126
        stepY := 88
        cols := 2
        rows := 2  ; Set how many rows you want

        Loop rows {
            y := startY + (A_Index - 1) * stepY  ; Changed to + and (A_Index - 1)
            Loop cols {
                x := startX + (A_Index - 1) * stepX
                BetterClick(x, y)
                Sleep(200)
            }
        }
        ;LogToConsole("Upgrade sequence done.")
        Sleep(500)
    } else {
        ;LogToConsole("UpgManager not found.")
        Sleep(1000)
    }
}

CidUnitUpg() {
        Sleep(300)
        ;LogToConsole("Upgrading unit...")
        startX := 637
        startY := 342
        stepX := 126
        stepY := 88
        cols := 2
        rows := 2  ; Set how many rows you want

        Loop rows {
            y := startY + (A_Index - 1) * stepY  ; Changed to + and (A_Index - 1)
            Loop cols {
                x := startX + (A_Index - 1) * stepX
                BetterClick(x, y)
                Sleep(200)
            }
        }

        ;BetterClick(636, 429) ; Extra upgrade for Cid
        Sleep(200)
        ;LogToConsole("Upgrade sequence done.")
        Sleep(500)
    }

unitPlacement(){
    FarmUnits := ["6", "6", "6"] ; Place 5 three times, then 6 once
    PlaceUnits(FarmUnits, farmxy, "Farm")
    FarmUnits := ["5"]
    PlaceUnits(FarmUnits, aixy, "AI")
    FarmUnitUpg()
    Sleep(50000)
    CidUnits := ["1", "1", "1"] ; Place Cid three times
    PlaceUnits(CidUnits, cidsxy, "Cid")
    GetoUnit := ["3"]
    PlaceUnits(GetoUnit, getoxy, "Geto")
    ;HillUnits := ["2", "2", "2", "2", "2"] ; Place Hill five times
    ;PlaceUnits(HillUnits, gokuxy, "Hill", maxTries)
    CidUnitUpg()
    return true
}

eventSetup() {
    ; Check for correct position first
    if (!FindText(&X, &Y, 250, 446, 446, 559, 5, 0, CorrectPosition)) {
        LogToConsole("Not in correct position, positioning...")
        ; Now move if in correct position
        Send("{d down}")
        Sleep(1000)
        Send("{d up}")
        Sleep(500)
        Send("{s down}")
        Sleep(4300)
        Send("{s up}")
        Sleep(2000)
        return false
    } else if (FindText(&X, &Y, 267, 439, 516, 536, 5, 0, CorrectPosition2)) {
        LogToConsole("In correct position (Position 2)")
        Sleep(500)
        return true
    }
    return true
}

; Loop for event setup with reset attempts
eventSetupLoop() {
    global maxTries, tries
    tries := 0
    while (++tries <= maxTries) {
        if (eventSetup()) {
            LogToConsole("eventSetup succeeded!")
            return true
        } else {
            LogToConsole("eventSetup failed, resetting... Attempt " tries)
            resetPosition()
            Sleep(1000)
        }
    }
    LogToConsole("eventSetup failed after " maxTries " attempts.")
    return false
}

LoopGateRank(retries := 3, delay := 500) {
    Loop retries {
        result := PickHighestGate()
        if result != "" {
            return result
        }
        LogToConsole("No gate found, retrying... (" A_Index "/" retries ")")
        Sleep(delay)
    }
    LogToConsole("No gate found after " retries " attempts!")
    return ""
}

PickHighestGate() {
    x := 176, y := 261, w := 656, h := 275
    
    ; Check gates in order of priority (highest rank first)
    if FindText(&gx, &gy, x, y, w, h, 0, 0, National_Rank_Gate) {
        LogToConsole("National Gate found at (" gx "," gy ")")
        BetterClick(gx + 42, gy + 215)
        return "National Gate"
    }
    if FindText(&gx, &gy, x, y, w, h, 0, 0, S_Rank_Gate) {
        LogToConsole("S Gate found at (" gx "," gy ")")
        BetterClick(gx + 42, gy + 215)
        return "S Gate"
    }
    if FindText(&gx, &gy, x, y, w, h, 0, 0, A_Rank_Gate) {
        LogToConsole("A Gate found at (" gx "," gy ")")
        BetterClick(gx + 42, gy + 215)
        return "A Gate"
    }
    if FindText(&gx, &gy, x, y, w, h, 0, 0, B_Rank_Gate) {
        LogToConsole("B Gate found at (" gx "," gy ")")
        BetterClick(gx + 42, gy + 215)
        return "B Gate"
    }
    if FindText(&gx, &gy, x, y, w, h, 0, 0, C_Rank_Gate) {
        LogToConsole("C Gate found at (" gx "," gy ")")
        BetterClick(gx + 42, gy + 215)
        return "C Gate"
    }
    if FindText(&gx, &gy, x, y, w, h, 0, 0, D_Rank_Gate) {
        LogToConsole("D Gate found at (" gx "," gy ")")
        BetterClick(gx + 42, gy + 215)
        return "D Gate"
    }
    
    LogToConsole("No gate found!")
    return ""
}

EndGameCheckEvent(){
    LogToConsole("Waiting for Victory or Defeat screen...")
    Sleep(1000)
    while true {
        if (FindText(&X, &Y, 0, 0, 800, 600, 0, 0, Victory)) {
            LogToConsole("Victory found! Proceeding to next gate...")
            Sleep(500)
            webhook()
            Sleep(500)
            UpdateWinCounter()
            Sleep(1000)
            BetterClick(271, 471) ;pick next gate
            Sleep(1000)
            Send("c")
            Sleep(500)
            LoopGateRank(5, 100)
            Sleep(1000)
            BetterClick(355, 350) ;findmatch
            LogToConsole("Macro cycle complete!")
            Sleep(1000)
            return
        }
        else if (FindText(&X, &Y, 0, 0, 800, 600, 0, 0, Defeat)) {
            LogToConsole("Defeat found! Proceeding to next gate...")
            Sleep(500)
            webhook()
            Sleep(500)
            UpdateLossCounter()
            Sleep(1000)
            BetterClick(271, 471) ;pick next gate
            Sleep(1000)
            Send("c")
            Sleep(500)
            LoopGateRank(5, 100)
            Sleep(1000)
            BetterClick(355, 350) ;findmatch
            Sleep(1000)
            return
        }
        Sleep(5000)
    }
}


; ================================= Not Used =============================
Lobby:="|<>*86$71.zzzzzzzzzzzxzzzzzzzzzzzzzzzzzzzzzzzs000000zzzzzk0000007zzzzU0000003zzzz00000001zzzy00000000zzzw00000000zzzs00000000Tzzk00000000TzzU00000000Tzz000000000Tzy0000000Tzzzg00001zzzzzzs007zzzzzzzzkTzzzzzzzzzzk"

lobbyCheck(){
    LogToConsole("Checking for Lobby screen...")
    Sleep(1000)
    timeout := 0
    while !(FindText(&X, &Y, 0, 0, 800, 600, 0, 0, Lobby))
    {
        ;LogToConsole("Lobby not found, waiting...")
        Sleep(1000)
        timeout++
        if (timeout > 120) { ; 120 second timeout
            LogToConsole("Timeout waiting for Lobby")
            Sleep(2000)
            return false
        }
    }
    ;LogToConsole("Lobby found!")
    Sleep(500)
    return true
}

moveToEvent(){
    if (LobbyCheck()){
        Loop 5{
            Send("{w down}")
            Sleep(3000)
            Send("{w up}")
            Sleep(500)
        }
    } else {
        LogToConsole("Not in Lobby, cannot move to event.")
        return false
    }
}

; ================================= Not Used =============================

gameplay(){
    global maxTries, tries

    clicks()

    if (!inGameCheck()) {
        LogToConsole("inGameCheck failed - stopping gameplay")
        Sleep(2000)
        return false
    }
    
    if (!inGamePosition()) {
        LogToConsole("inGamePosition failed - stopping gameplay")
        Sleep(2000)
        return false
    }
    
    if (!eventSetupLoop()) {
        LogToConsole("eventSetupLoop failed - stopping gameplay")
        Sleep(2000)
        return false
    }

    clicks()
    Sleep(500)
    VoteStartClick()

    if (!unitPlacement()) {
        LogToConsole("unitPlacement failed - stopping gameplay")
        Sleep(2000)
        return false
    }
    
    if (!EndGameCheckEvent()) {
        LogToConsole("EndGameCheckEvent failed - stopping gameplay")
        Sleep(2000)
        return false
    }
    
    LogToConsole("Gameplay completed successfully")
    Sleep(1000)
    return true
}
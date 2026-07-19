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
        global alreadyRan := false
        LogToConsole("Macro Started")
        while (true) {
            gameplay()
            sleep(10000)
        }
    }
}

VoteStart:="|<>*98$31.Tjk00MyDUSCSDwzn6DDwxX61s6M64MXA7DAT77061VXU3UMntzyAlg1UAMr0kC7tzzy1kDny8"
UnitPlaced:="|<>*93$20.1ts0M60Q0s76C1llUMwM7D61lXUQMs7UC1wDUTzs1zs0zy2"
UpgManager:="|<UpgManager>*125$71.nyTzzzzzzzzzXszzzzzzzzzz7lvinyvvjbqy730Q3k70Q3VsAAMlX6AMna7mGNlX4QFlUATa4XXC8sXW0NvAN76QFl24TnqNX0Mtk70Q36cz70lnkD4w6BTzzzzzzxlzzyw3byttzk7TzV0000001kw40+0000001zk03o0000001y00080000000U2pTE00000000000E"
Victory:="|<Victory>*121$165.000000000000000000000000000000000000000000000000000000000000000000000000000000000007zU3zzs0zwDzzz0Ty0Dzy3zk7z00zy0zzzUTzzzzzwDzy3zzyzz1zw0C0sC0UAD03s001bk1sM03z0MQ1U0k31UA1XU07000Bk03X003s1X0Q060QA1UAs00M001w00CM007UCs300M1XUA1i001000D000P000Q0y0k030AM3UDU008001k003s003k7UC00Q1r0Q1s003000A000D000C0Q1U01U6k7UD0Dkzw1zU7s0s3s1s10Q00C0y0w1s3zjzUDw1zU70TUDU03000k3U7UC0MDUQ1X0AC0s3A1g00k0060Q1w1k70s3UAM3Uk70TUBk0C000M3UBUC0k00Q1X0M60s3s1a01U003083g1k6003UAM30k7000AM0Q000Q00NUC0s70Q1X0Q60s0033U30001U07A1k31w3UAM1Vk7000sA0k000C00lUC0TxkQ1XUDw0s00C1U60000k06A1s1z73UAA0z07003UA0k000601VUD010QQ1VU1U1s00A1U60000M0AA1w001nUA6000T0Q0kA0k000303VUBk00CQ1Us003M3k71U60000Q0MA1b003XUA3U00v0S0MA0k0001U71UAQ00sQ1UC00SM3s1VU60000A0kA1Vs0S3UA0w0D30PUCA0k0000zy1zw7zzUDzU3zzkTzDzlzy00007zUDz0Dzk1zs07zs3zkzw7zU000000000010000000U00000000000000000000000000000000000004"
Defeat:="|<Defeat>*53$87.00000000000000000000000000000000000000000000000000000000007zzU1zzzjzzzzztzzzUTzzzzzzzzzA00y3001s00C001U00wM00D001k00A001n001s00C001U007M00D001k00A000P001s00C001U003s00D001k00A1y0D0Tzs3zy0ztUDs1s3zz0Tzk7zA1XU7003s3zy001UAA0s00T0Dzk00A1VU7003s00S001UAA0s00T003k00A1VU7003s00S001UAA0s1zv003k7zA1z0D0TzM00S0ztUDk1s3zz0Tzk7zA000T0Tzs3zq0ztU003M0070M0k00A000v000s306001U00CM0070M0k00A007X000s306001U07kM0070M0k00Dzzw3zzzzz07zzszzs0Dzzxzk0Tzz00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004"
CorrectPosition:="|<>*175$71.zzzzs1zzzzzzzzzs003zzzzzzzy0000TzzzzzzU0000Dzzzzzw00000DzzzzzV00000Dzzzzs300000DzzzzUDU0000Dzzzw0zE0000DzzzU3yDy000Dzzy03s7zs00DzzU07kTzzk0Dzz00DUzzzz0Tzy00DUzzzzw1zs00T1zzzzzs0000y3zzzzzzU000y3zzzzzzz001w7zzzzzzz003sDzzzzzzy003sDzzzzzzw007kTzzzzzzs00DUzzzzzzzk00DUzzzzzzzU00T1zzzzzzz000y3zzzzzzz"


ResetButton:="|<>*106$91.zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz0Dtzzzzzztzzznz07szzzzzXszzzlzwTwTzzzzlwTzzszzD2C63ks0S1sC4Tzb0600k8070M621zn62A0F4SDUA210ztU1038mD7lYN7UzwlwXs4NbXwX8WMDyQ28470nsy1UMAXzD3667ktwT1sC6PzzzzzDzzzzzzzzzzzzzzbzzzzzzzzzzzzzzrzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzk"

global myWebhookURL := "https://discord.com/api/webhooks/1327049889707724921/HzxIn-kGezqNFrgKItswk2uKkOolwGJ4SO2vL5glJFObPP3E8d2_6GRRsNX5lhpw6NeT"
global maxTries := 20
global tries := 0

; Win/Loss counter variables
global WinCount := 0
global LossCount := 0

global farmxy := [
    [245, 451],
    [294, 454],
    [357, 462]
]

global aixy := [
    [415, 474]
]
global cidsxy := [
    [337, 191],
    [363, 225],
    [423, 186]
]

global getoxy := [
    [364, 270]
]

global igrisxy := [
    [480, 250],
    [468, 200],
    [440, 135]
]

global sjwxy := [
    [488, 314],
    [451, 267],
    [396, 255]
]

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
    Sleep(60000)
    CidUnits := ["1", "1", "1"] ; Place Cid three times
    PlaceUnits(CidUnits, cidsxy, "Cid")
    GetoUnit := ["3"]
    PlaceUnits(GetoUnit, getoxy, "Geto")
    IgrisUnit := ["4", "4", "4"]
    PlaceUnits(IgrisUnit, igrisxy, "Igris")
    SjwUnit := ["4", "4", "4"]
    ;PlaceUnits(SjwUnit, sjwxy, "Sjw")
    CidUnitUpg()
    return true
}



eventSetup() {
    ; Check for correct position first
    Sleep(500)
    if (!FindText(&X, &Y, 0, 0, 800, 600, 10, 0, CorrectPosition)) {
        LogToConsole("Not in correct position, positioning...")
        resetPosition()
        Sleep(2000)
        return false
    } else {
        LogToConsole("In correct position")
        return true
    }
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
            Sleep(1000)
        }
    }
    LogToConsole("eventSetup failed after " maxTries " attempts.")
    return false
}

gameplay(){
    global maxTries, tries, alreadyRan

    if (!alreadyRan) {

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
        alreadyRan := true
    }

    clicks()
    Sleep(500)
    VoteStartClick()

    if (!unitPlacement()) {
        LogToConsole("unitPlacement failed - stopping gameplay")
        Sleep(2000)
        return false
    }
    
    if (!EndGameCheck()) {
        LogToConsole("EndGameCheck failed - stopping gameplay")
        Sleep(2000)
        return false
    }
    
    LogToConsole("Gameplay completed successfully")
    Sleep(1000)
    return true
}
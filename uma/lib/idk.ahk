#Include FindText.ahk

ToTitleScreen:="|<>*163$69.003U0S0000D7zyy03k000Dyzzrk0S0003zrzyQC3k000Ty1s01kS0003U0D00C3k000Q01s3bwS1w03k0D0Qznkzk0TU1s3bySDz01z0D0QTXlkw07y1s3VkSS7U07sD0QC3nzw00D1s3VkSTzU01sD0QC3nU000D1s3VsSS0021sD0QDXlsM0Tz1s3UySDz03zkD0Q7nkzs0Tw0000401w00y4"
HamburgerMenu:="|<>*178$56.Dzzzzzzzy7zzzzzzzzvzzzzzzzzyzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzszzzzzzzzw0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007zzzzzzzznzzzzzzzzyzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzztzzzzzzzzy0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007zzzzzzzznzzzzzzzzyzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzvzzzzzzzzyDzzzzzzzz8"
DeleteUser:="|<DeleteUser>*185$74.A000000001007C1k000000s01XUQ000000C00ss70000003U0CC1k000000s033UQ000000C00ks77ly7k1zbwwC1nwzlw0ztzj3UQkCCQ0QC0tks7D3za063VyAC1lwztU1UtzX3kQ7g0M0MCMssQD0vU6073iCC7zXCwtU1zvrVkzkz7yM0DyTsQ3k7US000s1U3000000000002"
DeleteUserConfirmation:="|<>*204$64.zzzXy7zzzzzzzyDsTzzzzzzzszVzzzzzzzzXy7zzzzzzzyDsTzzzzyDzszVwTtzwUDzXy70w0w00TyDsM3U1k3lzszVXiD73DXzXy6DsyAQ0DyDsMD00lk0zszVkA037TzzVyDsFzwQzzy7kzlXzllxzw43j67r707zk0S0M0QS0Tzk3s3s1lyDzzzzxzszzU"
CloseButton:="|<>*164$58.001k0000003z7U000000zwS0000007zls000000y17U000007k0S000000S01s307063k07UzVz3yD00SDz7wTww01swSwHkvk07bUvkC3j00SQ3bkzyS01tkCDnzxs07b0sDi03s2SS3UCs0DztswylvkMTzbXznz7zUTyS3yDwDy0C00306072"
CloseButton2:="|<>*164$58.0TVs000000Dz7U000001zwS000000Dlls000001w07U000007U0S000000w01sDkDkTXk07Vzlz7zD00SDzDAQSw01tsSw3Uvk07b0tsDzz00SQ3bszzS01tkC7nk1w07b0s7i03wCSS7cCw27ztszwztzsDzbVzXz3zUDwQ1w7s7wU"
CloseButton3:="|<>*163$58.001s0000007z7U000001zwS000000Dzls000000y17U000007U0S000000S01s7kDkT3k07VzVz3zD00SDz7wTyw01ssSs3kvk07b0tkC3j00SQ3bszzS01tkCDnzxs07b0s7i03s6SS7UCw0DztszwttssDzbVznz7zUTwS3w7s7yU"
CloseButton4:="|<>*162$57.0TVk000000TyC0000007zlk000001yCC000000T01k000007k0C000000w01kDkTUzbU0C7z3yDyw01kzwsnlzU0CD3r0Q7w01lkCy3zzU0CC1nwTzy01lkC7nU3s0CC3kDQ0DlllsQVvk9zyC7zbyDz3zlkTszlzs7wC1w3s3yU"

ViewButton:="|<>*164$44.0060000C0tk0003USQ0000w76000071k00001kw00000SC73wQtnXVlzbCQtkQsRnbDQ7C7BtVr1nznTsTUQzwyy7s7C07j0y1nUlvkD0QTwSw1k73y778"
AgreeButton:="|<>*201$62.z3zzzzzzzzzUzzzzzzzzzs7zzzzzzzzy1zzzzzzzzz0Tzszzzzzzl3y0A1sDw7wMz030M0w0S6DU1k66C27XVswQD7lXskwSDX3k0M0A07Xlkw060300s0QD01U0U0D0D3lzszsTVU7kwTqDuDsMzwDUVUk3y60D3s0Q00zkU0kzUDk7zzs07zzzzzzzwDVzzzzzzzz7sTzzzzzzzkwDzzzzzzzy03zzzzzzzzk3zzzzzy"
ChangeRegion:="|<>*166$57.00E0000000TX00000007yM0000001sn0000000Q0M0000303U3wDXwDsys0TlyTnzDz0760n6MnXs0skyMn6TvU76Tn6RnzS0sn6MnyM1zr6Mn6T3V7ysnyMnwDsDW66n6TsS0000003700000000sM00000003z00000000Dk0U"
OKButton:="|<>*204$33.zXzzzzk3yDks07lwC00SD3Uz3lkQDwCA7XzVlVsTyC0T3zkk7sTy60T3zklVsTyCADVzVlkwDsCD3kS3lsT00yDVw0Dly7s7yDkU"
; if ok button 1 does not work
OKButton2:="|<>*205$33.y0zly7U1yDUs07lsC3kSD3Vz1lkwDwCAD3zll3sTy60z3zkk3sTy68T3zllVwTwCC7VzVlky7sSD3k03lwD00yDUy0Tly7yzzzzU"
AgeForm:="|<>*233$70.y0TUDk7s3w3zs3z1zUzkTsDzUSSDD7zXzkzC1kssQQCC70QsC3b1nktkQ1nUMCQ7C3r1s7C1kwsQs7Q7UQs7znznURkS1nUDy7zC1r1s7C0TMDgsDQ7UQs03U1nktkQ1nU0C0D73XVk7C1XklsSSDD0Qs7z3z0zkTs1nUTkDs1y0z07U"
SkipTutorialButton:="|<>*203$43.zzXznzzs3lzkzzs1szsTzs0wTwDzwDSDzzzyDz7zzzz7zXzzzDUzlkkk0s3sksM0C0wEwA73kC8y67ly30T33szVUDVVwTkl3kky7sMVsMT0EQMQA700CC66020D73303xzzzzVjzzzzzkzzzzzzsTzzzzzwDzzzzzy7zzzzzz3zU"
TrainerNameForm:="|<>*236$20.002001k00S00LrzCPzbkU3y81z20zUUTk8Dv27wkXyA8z32DUkbUA903200kk0ADzy2"

; Offset for trainer form
  ; FindText().Click(X+120, Y+3, "L")

RegisterButton:="|<>*128$71.zzzzzzzDzzzy0TzzzzwDzzzw0DzzzzsTzzzs0DzzzzkzzXzkwTzzzzzzz7zVsTzzznzzyDz3kzbzW7zXwTs7Xs1w0AC1UD007U1k0sM30Q00T7XXVklq0lk1wT77XVXz7XVXs04D731yC033k0AQC70wQ073Xzs0wDUssQC77zk3sTllssS77nXzkrXUkkwC06DzVU71k1wC0C0730T3kzzzXw07zzzzxzzzzlyDzzzzzzzzzXwTzzzzzzzzz7szzzzzzzzzy01zzzzzk"
SkipButton:="|<>*147$62.zzzzk0zzzzzzzz000zzzzzzy0001zzzzzy00007zzzzy00000Tzzzy000003zzzz000000DzzzU000001zzzk000000Dzzs0000001zzw0000000Dzy00000001zz00000000DzU00000003zs00000000Tw000000003y000000000zU000000007s000000001w000000000D0000000003U00U20Dk00s00A0k3w006003UA0z001000s3UDk00E00D0w3w004003sDUz000000z3wDk00000Dsz3w000003yTsz000000zrzDk00000Dzzzw000007zzzz000001zzzzk00000Tzzzw000007zzyz000001zrzDk00E00TtzXw006007wTkz001U01y7sDk00M00TVw3w00D007kS0z003k01s7UDk00w00Q1k7w00TU020M1z007s000000003z000000000zk00000000Ty000000007zk00000003zy00000001zzU0000000zzw0000000TzzU000000Dzzw0000007zzzk000003zzzy000001zzzzk00001zzzzz00000zzzzzw0000zzzzzzs001zzzzzzzk03zzzy"
SkipButton2:="|<>*181$27.k307z0Q1zw3kDzkS1zy3sDzsTVzzXyDzyTtzzvzjzzTxzzzzzzzzzzzzzzzzzzzzzzzzzTxzznzDzyTlzzXwDzsTVzy3sDzUS1zs3UDy0M1zU"
GiftButton:="|<>*170$61.000000Dzzk000000Dzzw000000Dzzz00000083zsk0000040zsM0000020DsA000003z7w707s00TzXw3U7y00Tz3wFk7zk0Ty1y8s7zzzzz0yAS3zzzzzwD6C1zzzzzz7770zzzzzzV01UTzzzzrlU0lzzzzzk0zstzzzzzs0zwMk01zU11zyAs00zk0zzzwQ00Ts0DzzwC00Dw03zzw7007y00zzw3U03z007zs0k01zU01zk0S00zk03k00E"
CollectAll:="|<>*202$68.zzzzzXXzzzzzk7zzksTzzzzk0zzwC7zzzzs0Dzz3Vzzzzw1XzzksTzzzy3zzzwC7zzzzVzzzz3Vzzzzkzzs7ksT0zU8Dzw0QC7U7k23zy033Vkks0Uzz3kksMyADwDzlyAC6017z3zwTX3VU0FzsTz7sksMTwTy3zkyAC6Dz3zkDCD33VVysSy03U1ksQ0C0Dk0w0wC7U3k3z0TkTXVw1z1s"
ScoutButton:="|<>*174$48.A01yTs0A03zs3zzw3XzzzzzsDtzzzzk0Ts000000w800000Qs000000Qw0DVsAAwS0TXyCBzDkzbyCBz7tkC7CAQ0xkC3CAQ0RUA3CAQ0RkC3CAQURkC7CAQzwxbjCQSzsTXyDwDTUDVw7w7U"
X := Y := 0
GameWindow := "ahk_exe UmamusumePrettyDerby.exe"


BetterClick(x, y) { ; credits to yuh for this, lowk a life saver
    MouseMove(x, y)
    MouseMove(1, 0, , "R")
    Sleep(100)
    MouseClick("Left", -1, 0, , , , "R")
    Sleep(50)
}

; Helper to find and click an image with attempt counter, returns true if found
FindAndClick(image, desc := "", wait := 1000, searchTimeout := 2000, maxAttempts := 10) {
    global X, Y
    attempts := 0

    while (attempts < maxAttempts) {
        attempts++

        start := A_TickCount
        while (A_TickCount - start < searchTimeout) {
            if FindText(&X, &Y, 0, 0, 1920, 1080, 0, 0, image) {
                ToolTip("Clicked: " . desc)
                SetTimer(() => ToolTip(), -1000)
                BetterClick(X, Y)
                Sleep(wait)
                return true
            }
            Sleep(1000)
        }

        ToolTip("Attempt " . attempts . "/" . maxAttempts . ": Not found: " . desc)
        SetTimer(() => ToolTip(), -3000)

        ; If max attempts reached, exit
        if (attempts >= maxAttempts) {
            MsgBox("Failed to find " . desc . " after " . maxAttempts . " attempts. Exiting.", "Error", "OK IconX")
            ExitApp
        }
        Sleep(1000) ; Wait before next attempt
    }

    return false
}

DeleteAccount() {
    global ToTitleScreen, HamburgerMenu, DeleteUser, DeleteUserConfirmation, CloseButton

    ; Step 1: Try TitleScreen, else HamburgerMenu
    if !FindAndClick(ToTitleScreen, "ToTitleScreen") {
        if !FindAndClick(HamburgerMenu, "HamburgerMenu") {
            MsgBox("Neither ToTitleScreen nor HamburgerMenu found after all attempts. Exiting.", "Error", "OK IconX")
            ExitApp
        }
    }

    BetterClick(0, 0) ; Click the hamburger menu to ensure it's open

    if !FindAndClick(HamburgerMenu, "HamburgerMenu")  {
        if !FindAndClick(ToTitleScreen, "ToTitleScreen") {
            MsgBox("Neither ToTitleScreen nor HamburgerMenu found after all attempts. Exiting.", "Error", "OK IconX")
            ExitApp
        }
    }
    ; Step 2: DeleteUser (if present)
    FindAndClick(DeleteUser, "DeleteUser")
    ; Step 3: DeleteUserConfirmation (may appear twice)
    FindAndClick(DeleteUserConfirmation, "DeleteUserConfirmation 1")
    FindAndClick(DeleteUserConfirmation, "DeleteUserConfirmation 2")
    ; Step 4: CloseButton (if present)
    FindAndClick(CloseButton, "CloseButton")
    Sleep(10000)

    return true
}

CreateAccount(){
    global GameWindow, HamburgerMenu, ViewButton, AgreeButton, ChangeRegion, OKButton, AgeForm, SkipTutorialButton, TrainerNameForm, RegisterButton

    if FindText(&X, &Y, 0, 0, 1920, 1080, 0, 0, HamburgerMenu) {
        ToolTip("Found HamburgerMenu")
        BetterClick(400, 400)
        SetTimer(() => ToolTip(), -3000)
    } 
    if FindAndClick(ViewButton, "ViewButton 1") {
        ; Click the first button (already done by FindAndClick)
        WinActivate(GameWindow)
        Sleep(1000)
        ; Click the second button using an offset (e.g., 100 pixels down)
        if FindText(&X, &Y, 0, 0, 1920, 1080, 0, 0, ViewButton) {
            offsetY := 117 
            BetterClick(X, Y + offsetY)
            Sleep(1000)
            WinActivate(GameWindow)
        }
    }
    FindAndClick(AgreeButton, "AgreeButton")
    FindAndClick(ChangeRegion, "ChangeRegion")
    FindAndClick(OKButton, "OKButton")
    Sleep(1000)
    ; 2nd ok button
    FindAndClick(OKButton2, "OKButton2")
    if FindAndClick(AgeForm, "AgeForm") {
        ; Fill in the age form
        Sleep(500)
        Send("200305") ; Example: Enter age
        Sleep(500)
        FindAndClick(OKButton2, "OKButton2")
    }
    Sleep(1000)
    FindAndClick(SkipTutorialButton, "SkipTutorialButton")
    
    if FindAndClick(TrainerNameForm, "TrainerNameForm") {
        ; Fill in the trainer name form
        Sleep(500)
        Send("Xsrn") ; Example: Enter trainer name
        Sleep(500)
        FindAndClick(RegisterButton, "RegisterButton")
        FindAndClick(OKButton2, "OKButton2")
    }
}

GetGifts() {
    global X, Y, GiftButton, SkipButton, SkipButton2, CloseButton, CollectAll
    while true {
        ; Try to find the GiftButton
        if !FindText(&X, &Y, 0, 0, 1920, 1080, 0, 0, GiftButton) {
            ; If not found, check for SkipButton
            if FindText(&X, &Y, 0, 0, 1920, 1080, 0, 0, SkipButton) {
                ToolTip("Found SkipButton, clicking...")
                BetterClick(X, Y)
                Sleep(100)
                SetTimer(() => ToolTip(), -1000)
            }
            if FindText(&X, &Y, 0, 0, 1920, 1080, 0, 0, SkipButton2) {
                ToolTip("Found SkipButton2, clicking...")
                BetterClick(X, Y)
                Sleep(100)
                SetTimer(() => ToolTip(), -1000)
            }
            ; Check for CloseButton
            if FindText(&X, &Y, 0, 0, 1920, 1080, 0, 0, CloseButton) {
                ToolTip("Found CloseButton, clicking...")
                BetterClick(X, Y)
                Sleep(300)
                SetTimer(() => ToolTip(), -1000)
            }
            if FindText(&X, &Y, 0, 0, 1920, 1080, 0, 0, CloseButton2) {
                ToolTip("Found CloseButton2, clicking...")
                BetterClick(X, Y)
                Sleep(300)
                SetTimer(() => ToolTip(), -1000)
            }
            ; Check for CloseButton
            else if FindText(&X, &Y, 0, 0, 1920, 1080, 0, 0, CloseButton3) {
                ToolTip("Found CloseButton3, clicking...")
                BetterClick(X, Y)
                Sleep(300)
                SetTimer(() => ToolTip(), -1000)
            }
            Sleep(300)
        } else {
            ToolTip("GiftButton found, breaking loop")
            Sleep(500)
            SetTimer(() => ToolTip(), -1000)
            break
        }
    }
    ; Debug: Show tooltip before trying to click GiftButton
    ToolTip("Attempting to click GiftButton after loop")
    Sleep(500)
    SetTimer(() => ToolTip(), -1000)
    ; GiftButton found, click it
    if FindAndClick(GiftButton, "GiftButton") {
        ToolTip("Clicked GiftButton")
        Sleep(500)
        SetTimer(() => ToolTip(), -1000)
    } else {
        ToolTip("Could not click GiftButton!")
        Sleep(1000)
        SetTimer(() => ToolTip(), -1000)
    }
    ; Try to collect all gifts
    if FindAndClick(CollectAll, "CollectAll") {
        ToolTip("Clicked CollectAll")
        Sleep(300)
        ; Check for CloseButton
        if FindText(&X, &Y, 0, 0, 1920, 1080, 0, 0, CloseButton) {
            ToolTip("Found CloseButton, clicking...")
            BetterClick(X, Y)
            Sleep(400)
            SetTimer(() => ToolTip(), -1000)
        }
        if FindText(&X, &Y, 0, 0, 1920, 1080, 0, 0, CloseButton2) {
            ToolTip("Found CloseButton2, clicking...")
            BetterClick(X, Y)
            Sleep(400)
            SetTimer(() => ToolTip(), -1000)
        }
        ; Check for CloseButton
        if FindText(&X, &Y, 0, 0, 1920, 1080, 0, 0, CloseButton3) {
            ToolTip("Found CloseButton3, clicking...")
            BetterClick(X, Y)
            Sleep(400)
            SetTimer(() => ToolTip(), -1000)
        }
        ; Check for CloseButton
        else if FindText(&X, &Y, 0, 0, 1920, 1080, 0, 0, CloseButton4) {
            ToolTip("Found CloseButton4, clicking...")
            BetterClick(X, Y)
            Sleep(400)
            SetTimer(() => ToolTip(), -1000)
        }
    }
}
#Include FindText.ahk

Trade2:="|<>*130$64.zzzznDzzzzzDzzzAzzzzkQzzzwzzzzy0nzzznzzyTlk221kAkC1zz8s860n0lDzsnby9nAlAzz7CT0bAn4H0swtsWQnAEDzDnba9nAlDztz2S0UAn4zz7w9s30nAE7w0zzzzzzyCTzzzzzzzzwlzzzzzzzzzkDzzU"
Trade1:="|<>*114$61.zzzznDzzzztzzztbzzzyAzzzwzzzzy6TzzyTzzny0221kAkC1zt710k6M69zwnby9nAlAzyNns4taMWM7AtsWQnAEDzaQwlCNa9zzn2S0UAn4zztVD0M6NW0zwzzzzzzyCTzzzzzzzz6DzzzzzzzzkDzw"


Esc::ExitApp  ; Exit script with Escape key
CoordMode("Mouse", "Screen")
F10::{
    while (true) {
        ; Check for the message and send it
        SendDiscordMessage()
    }
}

tradingchat:= Map(
"Trade2", "|<>*130$64.zzzznDzzzzzDzzzAzzzzkQzzzwzzzzy0nzzznzzyTlk221kAkC1zz8s860n0lDzsnby9nAlAzz7CT0bAn4H0swtsWQnAEDzDnba9nAlDztz2S0UAn4zz7w9s30nAE7w0zzzzzzyCTzzzzzzzzwlzzzzzzzzzkDzzU",
"Trade1", "|<>*114$61.zzzznDzzzztzzztbzzzyAzzzwzzzzy6TzzyTzzny0221kAkC1zt710k6M69zwnby9nAlAzyNns4taMWM7AtsWQnAEDzaQwlCNa9zzn2S0UAn4zztVD0M6NW0zwzzzzzzyCTzzzzzzzz6DzzzzzzzzkDzw"
)

SendDiscordMessage() {
    global tradingchat
    Text:="|<>*75$152.zzzzzzzzzzzzzzzzzzzzzzzy1zzzzzzzzzzzzzzzzzzzzzzzzty3Dzzzzzzvzwzzzzztyzznzzc5CHzzzzzzyzzDzzzzyTjzwzzs0HwzzzzzzzjzzzzzzzbvzzDzy04zC6tc8wC3Vwkz31kMCsS3zz0EVnAYOMaNAnDBjaFBaNgnAzzkAC4r94aNiHgvnTtonxbPCbDzw23t9mJ9aHYv0wky1AsNqk9nzz00yHQl6NatCrzDbjnAqRgyQzzk03YnAFaNaHAnnNtYnNaPAn9zy063a7CNaQC3Vwkz3AkMCMS2TzU1zzzzzzzzzzzzzzzzzzzzzzzw0zzzzzzzzzzzzzzzzzzzzzzzzly"
    if (ok:=FindText(&X, &Y, 1714, 999, 1907, 1031, 0, 0, Text)){
        ToolTip "Discord found. Sending message..."
        ; Loop through tradingchat coordinates and click each one
        for name, imageText in tradingchat {
            if FindText(&x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight, 0, 0, imageText) {
                BetterClick(x,y)
                Sleep(2000)  ; Wait for a moment
                BetterClick(999, 994)
                Send("^v")  ; Paste the message
                Sleep(100)  ; Wait for a moment
                Send("{Enter}")  ; Press Enter to send the message
                Sleep(1000)  ; Wait for a moment
            }
        } else {
            ToolTip "Discord not found or message not detected."
            Sleep(2000)
        }
    } else {
        ToolTip "Discord not found or message not detected."
        Sleep(2000)
    }
}

BetterClick(x, y) {
    MouseMove(x, y)
    MouseMove(1, 0, , "R")
    Sleep(100)
    MouseClick("Left", -1, 0, , , , "R")
    Sleep(50)
}

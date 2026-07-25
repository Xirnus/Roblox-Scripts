#Requires AutoHotkey v2.0
#Include Gdip_All.ahk

myWebhookURL := "https://discord.com/api/webhooks/1327049889707724921/HzxIn-kGezqNFrgKItswk2uKkOolwGJ4SO2vL5glJFObPP3E8d2_6GRRsNX5lhpw6NeT"

; Initialize GDI+ when script starts
pToken := Gdip_Startup()

TakeRobloxScreenshotByArea(filePath := "roblox_screenshot.png") {
    ; Get Roblox window position and size
    try {
        hwnd := WinGetID("ahk_exe RobloxPlayerBeta.exe")
        WinGetPos(&x, &y, &width, &height, hwnd)
    } catch {
        MsgBox("Roblox window not found!")
        return false
    }
    
    ; Take screenshot of that screen area
    pBitmap := Gdip_BitmapFromScreen(x . "|" . y . "|" . width . "|" . height)
    if !pBitmap {
        MsgBox("Failed to capture screenshot")
        return false
    }
    
    ; Save to file
    result := Gdip_SaveBitmapToFile(pBitmap, filePath)
    Gdip_DisposeImage(pBitmap)
    
    if (result = 0) {
        return filePath
    } else {
        MsgBox("Failed to save screenshot: Error " . result)
        return false
    }
}

; Function to send file to Discord webhook using curl
SendScreenshotWithCurl(webhookURL, message := "", screenshotPath := "screenshot.png") {
    ; Build curl command (assuming screenshot already exists)
    curlCmd := 'curl -X POST "' . webhookURL . '"'
    if (message != "")
        curlCmd .= ' -F "content=' . message . '"'
    curlCmd .= ' -F "file=@' . screenshotPath . '"'
    
    ; Send to Discord
    RunWait(curlCmd, , "Hide")
    
    ; Clean up
    if FileExist(screenshotPath)
        FileDelete(screenshotPath)
    
    return true
}

; Example usage with hotkeys
webhook(){
    global myWebhookURL
    if (TakeRobloxScreenshotByArea("roblox_screenshot.png")) {
        SendScreenshotWithCurl(myWebhookURL, "Stage Complete", "roblox_screenshot.png")
    }
}

; Cleanup GDI+ when script exits
OnExit((*) => Gdip_Shutdown(pToken))
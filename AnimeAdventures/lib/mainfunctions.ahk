#Include FindText.ahk

#Include patterns.ahk

global wheeldownCount := 15

; Common functions
BetterClick(x, y) {
    MouseMove(x, y)
    MouseMove(1, 0, , "R")
    Sleep(100)
    MouseClick("Left", -1, 0, , , , "R")
    Sleep(50)
}

checkImage(pattern) {
    if (FindText(&X, &Y, 0, 0, 809, 627, 10, 10, pattern)) {
        return true
    }
    return false
}

LookDown(){
    ; Get the width and height of the currently active window's client area
    WinGetClientPos(,, &clientWidth, &clientHeight, "A")
    
    ; Calculate the center coordinates dynamically
    centerX := clientWidth // 2
    centerY := clientHeight // 2

    BetterClick(centerX, centerY)
    loop 20 {
        SendInput("{WheelUp}")
        Sleep 50
    }
    Sleep 500
    SendInput(Format("{Click {} {} Left}", centerX, centerY + 200))
    Sleep 500
    loop wheeldownCount {
        SendInput("{WheelDown}")
        Sleep 50
    }
}

global TesseractPath := "C:\Program Files\Tesseract-OCR\tesseract.exe"

global GdipToken := Gdip_Startup()

if !GdipToken {
    MsgBox("Failed to initialize GDI+.")
    ExitApp
}

OCR(x, y, width, height, language := "eng") {
    global TesseractPath

    if !FileExist(TesseractPath)
        throw Error("Tesseract was not found: " TesseractPath)

    tempImage := A_Temp "\ocr_input.png"
    outputBase := A_Temp "\ocr_output"
    outputText := outputBase ".txt"

    ; Capture the screen region.
    pBitmap := Gdip_BitmapFromScreen(x "|" y "|" width "|" height)

    if !pBitmap
        throw Error("Could not capture the screen region.")

    Gdip_SaveBitmapToFile(pBitmap, tempImage)
    Gdip_DisposeImage(pBitmap)

    ; Remove old OCR output.
    if FileExist(outputText)
        FileDelete(outputText)

    command := '"' TesseractPath '" "' tempImage '" "' outputBase
        . '" -l ' language ' --psm 6'

    exitCode := RunWait(command, , "Hide")

    if exitCode != 0
        throw Error("Tesseract failed with exit code " exitCode)

    if !FileExist(outputText)
        throw Error("Tesseract did not produce an output file.")

    return Trim(FileRead(outputText, "UTF-8"))
}

TypeNumberCaptcha(text) {
    text := RegExReplace(String(text), "[^0-9]")

    for char in StrSplit(text) {
        SendEvent(char)
        Sleep(100)
    }
}
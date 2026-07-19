import pyautogui

def click_mouse(x, y):
    pyautogui.click(x, y)

def move_mouse(x, y):
    pyautogui.moveTo(x, y)

def get_mouse_position():
    return pyautogui.mouseInfo()

get_mouse_position()


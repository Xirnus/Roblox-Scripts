import sys
import numpy as np
from PIL import ImageGrab
import argparse
import json

def get_pixel_color(x, y):
    """Get the color of a single pixel at coordinates (x, y)"""
    try:
        # Capture a 1x1 pixel area
        screenshot = ImageGrab.grab(bbox=(x, y, x+1, y+1))
        pixel = screenshot.getpixel((0, 0))
        # Convert RGB to hex format (0xRRGGBB)
        color_hex = (pixel[0] << 16) | (pixel[1] << 8) | pixel[2]
        return color_hex
    except Exception as e:
        return -1

def is_white_at_y(y, left, right, threshold=0xF0F0F0):
    """Check if there's white pixels at Y coordinate within the given X range"""
    try:
        # Capture the horizontal line
        screenshot = ImageGrab.grab(bbox=(left, y, right+1, y+1))
        width = screenshot.width
        
        for x in range(width):
            pixel = screenshot.getpixel((x, 0))
            color_hex = (pixel[0] << 16) | (pixel[1] << 8) | pixel[2]
            
            # Check if pixel meets white threshold
            if (color_hex & threshold) == threshold:
                return True
        return False
    except Exception as e:
        return False

def is_minigame_active(left, top, right, bottom, target_y):
    """Check if minigame is active by looking for white bar in middle area"""
    try:
        # Calculate middle Y position
        middle_y = top + ((bottom - top) // 2)
        
        # Check 20 lines around the middle for white pixels
        for i in range(20):
            test_y = middle_y - 10 + i
            if top <= test_y <= bottom:
                if is_white_at_y(test_y, left, right):
                    return True
        return False
    except Exception as e:
        return False

def check_minigame_pixel(x, y, target_color):
    """Check if specific pixel matches target color for minigame detection"""
    try:
        current_color = get_pixel_color(x, y)
        return current_color == target_color
    except Exception as e:
        return False

def pixel_search_area(left, top, right, bottom, target_color, tolerance=0):
    """Search for target color in specified area with tolerance"""
    try:
        # Capture the area
        screenshot = ImageGrab.grab(bbox=(left, top, right+1, bottom+1))
        width, height = screenshot.size
        
        # Convert target color to RGB
        target_r = (target_color >> 16) & 0xFF
        target_g = (target_color >> 8) & 0xFF
        target_b = target_color & 0xFF
        
        for y in range(height):
            for x in range(width):
                pixel = screenshot.getpixel((x, y))
                
                # Check if pixel is within tolerance
                if tolerance > 0:
                    r_diff = abs(pixel[0] - target_r)
                    g_diff = abs(pixel[1] - target_g)
                    b_diff = abs(pixel[2] - target_b)
                    
                    if r_diff <= tolerance and g_diff <= tolerance and b_diff <= tolerance:
                        return {"found": True, "x": left + x, "y": top + y}
                else:
                    # Exact match
                    if pixel[0] == target_r and pixel[1] == target_g and pixel[2] == target_b:
                        return {"found": True, "x": left + x, "y": top + y}
        
        return {"found": False}
    except Exception as e:
        return {"found": False, "error": str(e)}

def main():
    parser = argparse.ArgumentParser(description='Pixel detection utilities')
    parser.add_argument('function', choices=['get_pixel', 'is_white_at_y', 'is_minigame_active', 
                                           'check_minigame_pixel', 'pixel_search'])
    parser.add_argument('--x', type=int, help='X coordinate')
    parser.add_argument('--y', type=int, help='Y coordinate')
    parser.add_argument('--left', type=int, help='Left boundary')
    parser.add_argument('--top', type=int, help='Top boundary')
    parser.add_argument('--right', type=int, help='Right boundary')
    parser.add_argument('--bottom', type=int, help='Bottom boundary')
    parser.add_argument('--target_color', type=str, help='Target color in hex (e.g., 0xEEFAFD)')
    parser.add_argument('--tolerance', type=int, default=0, help='Color tolerance')
    parser.add_argument('--threshold', type=str, default='0xF0F0F0', help='White threshold')
    parser.add_argument('--target_y', type=int, help='Target Y coordinate for minigame')
    
    args = parser.parse_args()
    
    result = {}
    
    try:
        if args.function == 'get_pixel':
            color = get_pixel_color(args.x, args.y)
            result = {"color": f"0x{color:06X}" if color != -1 else "ERROR"}
            
        elif args.function == 'is_white_at_y':
            threshold = int(args.threshold, 16) if args.threshold.startswith('0x') else int(args.threshold)
            is_white = is_white_at_y(args.y, args.left, args.right, threshold)
            result = {"is_white": is_white}
            
        elif args.function == 'is_minigame_active':
            is_active = is_minigame_active(args.left, args.top, args.right, args.bottom, args.target_y)
            result = {"is_active": is_active}
            
        elif args.function == 'check_minigame_pixel':
            target_color = int(args.target_color, 16) if args.target_color.startswith('0x') else int(args.target_color)
            matches = check_minigame_pixel(args.x, args.y, target_color)
            result = {"matches": matches}
            
        elif args.function == 'pixel_search':
            target_color = int(args.target_color, 16) if args.target_color.startswith('0x') else int(args.target_color)
            search_result = pixel_search_area(args.left, args.top, args.right, args.bottom, target_color, args.tolerance)
            result = search_result
            
    except Exception as e:
        result = {"error": str(e)}
    
    # Output result as JSON
    print(json.dumps(result))

if __name__ == "__main__":
    main()

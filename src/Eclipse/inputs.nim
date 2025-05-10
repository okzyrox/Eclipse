#-- Eclipse Engine -- 
# Author: ZyroX

## Inputs stuff

import sdl2

import ./[common]

type MouseButton* = enum
  Left,
  Middle,
  Right

type InputKey* = enum
  Key_A, Key_B, Key_C, Key_D, Key_E
  Key_F, Key_G, Key_H, Key_I, Key_J
  Key_K, Key_L, Key_M, Key_N, Key_O
  Key_P, Key_Q, Key_R, Key_S, Key_T
  Key_U, Key_V, Key_W, Key_X, Key_Y
  Key_Z

  Key_0, Key_1, Key_2, Key_3, Key_4
  Key_5, Key_6, Key_7, Key_8, Key_9

  Key_F1, Key_F2, Key_F3, Key_F4, Key_F5
  Key_F6, Key_F7, Key_F8, Key_F9, Key_F10

  Key_Up, Key_Down, Key_Left, Key_Right, Key_Enter
  Key_Space, Key_Backspace, Key_Tab, Key_Shift, Key_Control

  Key_Pause, Key_Escape, Key_Delete, Key_Insert, Key_Home

  Key_Unknown


type ReturnEvents* = enum
  None
  WindowQuit
  WindowEvent


proc toKey*(sc: ScanCode): InputKey =
  case sc
    of SDL_SCANCODE_A: Key_A
    of SDL_SCANCODE_B: Key_B
    of SDL_SCANCODE_C: Key_C
    of SDL_SCANCODE_D: Key_D
    of SDL_SCANCODE_E: Key_E
    of SDL_SCANCODE_F: Key_F
    of SDL_SCANCODE_G: Key_G
    of SDL_SCANCODE_H: Key_H
    of SDL_SCANCODE_I: Key_I
    of SDL_SCANCODE_J: Key_J
    of SDL_SCANCODE_K: Key_K
    of SDL_SCANCODE_L: Key_L
    of SDL_SCANCODE_M: Key_M
    of SDL_SCANCODE_N: Key_N
    of SDL_SCANCODE_O: Key_O
    of SDL_SCANCODE_P: Key_P
    of SDL_SCANCODE_Q: Key_Q
    of SDL_SCANCODE_R: Key_R
    of SDL_SCANCODE_S: Key_S
    of SDL_SCANCODE_T: Key_T
    of SDL_SCANCODE_U: Key_U
    of SDL_SCANCODE_V: Key_V
    of SDL_SCANCODE_W: Key_W
    of SDL_SCANCODE_X: Key_X
    of SDL_SCANCODE_Y: Key_Y
    of SDL_SCANCODE_Z: Key_Z
    of SDL_SCANCODE_0: Key_0
    of SDL_SCANCODE_1: Key_1
    of SDL_SCANCODE_2: Key_2
    of SDL_SCANCODE_3: Key_3
    of SDL_SCANCODE_4: Key_4
    of SDL_SCANCODE_5: Key_5
    of SDL_SCANCODE_6: Key_6
    of SDL_SCANCODE_7: Key_7
    of SDL_SCANCODE_8: Key_8
    of SDL_SCANCODE_9: Key_9
    of SDL_SCANCODE_F1: Key_F1
    of SDL_SCANCODE_F2: Key_F2
    of SDL_SCANCODE_F3: Key_F3
    of SDL_SCANCODE_F4: Key_F4
    of SDL_SCANCODE_F5: Key_F5
    of SDL_SCANCODE_F6: Key_F6
    of SDL_SCANCODE_F7: Key_F7
    of SDL_SCANCODE_F8: Key_F8
    of SDL_SCANCODE_F9: Key_F9
    of SDL_SCANCODE_F10: Key_F10
    of SDL_SCANCODE_UP: Key_Up
    of SDL_SCANCODE_DOWN: Key_Down
    of SDL_SCANCODE_LEFT: Key_Left
    of SDL_SCANCODE_RIGHT: Key_Right
    of SDL_SCANCODE_RETURN: Key_Enter
    of SDL_SCANCODE_SPACE: Key_Space
    of SDL_SCANCODE_BACKSPACE: Key_Backspace
    of SDL_SCANCODE_TAB: Key_Tab
    of SDL_SCANCODE_LSHIFT: Key_Shift
    of SDL_SCANCODE_LCTRL: Key_Control
    of SDL_SCANCODE_PAUSE: Key_Pause
    of SDL_SCANCODE_ESCAPE: Key_Escape
    of SDL_SCANCODE_DELETE: Key_Delete
    of SDL_SCANCODE_INSERT: Key_Insert
    of SDL_SCANCODE_HOME: Key_Home

    of SDL_SCANCODE_UNKNOWN: Key_Unknown
    else: Key_Unknown
  
proc toMouseButton*(mouseButton: uint8): MouseButton =
  case mouseButton
    of BUTTON_LEFT: Left
    of BUTTON_MIDDLE: Middle
    of BUTTON_RIGHT: Right
    else: Left

type InputManager* = object
  keys_pressed*: set[InputKey]
  keys_held*: set[InputKey]
  keys_just_released*: set[InputKey]

  mouse_pos*: Vec2
  mouse_in_window*: bool
  mouse_pressed*: set[MouseButton]
  mouse_held*: set[MouseButton]
  mouse_just_released*: set[MouseButton]

proc newInputManager*(): InputManager =
  InputManager(
    keys_pressed: {},
    keys_held: {},
    keys_just_released: {},
    mouse_pos: Vec2(x: 0, y: 0),
    mouse_in_window: false,
    mouse_pressed: {},
    mouse_held: {},
    mouse_just_released: {}
  )

proc updateInputs*(inputManager: var InputManager): ReturnEvents =
  inputManager.keys_pressed = {}
  # inputManager.keys_held = {}
  inputManager.keys_just_released = {}
  inputManager.mouse_pos = Vec2(x: 0, y: 0)
  inputManager.mouse_in_window = false
  inputManager.mouse_pressed = {}
  # inputManager.mouse_held = {}
  inputManager.mouse_just_released = {}

  var evt = sdl2.defaultEvent
  while pollEvent(evt):
    case evt.kind
      of QuitEvent:
        return WindowQuit
      of KeyDown:
        logEclipse "Key pressed: ", $evt.key.keysym.scancode.toKey()
        inputManager.keys_pressed.incl(evt.key.keysym.scancode.toKey())
        inputManager.keys_held.incl(evt.key.keysym.scancode.toKey())
        break
      of KeyUp:
        logEclipse "Key released: ", $evt.key.keysym.scancode.toKey()
        inputManager.keys_just_released.incl(evt.key.keysym.scancode.toKey())
        inputManager.keys_pressed.excl(evt.key.keysym.scancode.toKey())
        inputManager.keys_held.excl(evt.key.keysym.scancode.toKey())
        break
      
      of MouseButtonDown:
        inputManager.mouse_pressed.incl(evt.button.button.toMouseButton())
        inputManager.mouse_held.incl(evt.button.button.toMouseButton())
      of MouseButtonUp:
        inputManager.mouse_just_released.incl(evt.button.button.toMouseButton())
        inputManager.mouse_held.excl(evt.button.button.toMouseButton())
      
      else:
        discard
  
  return None


proc keyIsDown*(input_manager: InputManager, key: InputKey): bool =
  return key in input_manager.keys_pressed

proc keyIsHeld*(input_manager: InputManager, key: InputKey): bool =
  return key in input_manager.keys_held

proc keyIsReleased*(input_manager: InputManager, key: InputKey): bool =
  return key in input_manager.keys_just_released

# proc keyPressed*(input_manager: InputManager, key: InputKey): bool =
#   let down = keyIsDown(input_manager, key)
#   let held = keyIsHeld(input_manager, key)
#   return down and not held

proc mouseIsDown*(input_manager: InputManager, button: MouseButton): bool =
  return button in input_manager.mouse_pressed

proc mouseIsHeld*(input_manager: InputManager, button: MouseButton): bool =
  return button in input_manager.mouse_held

proc mouseIsReleased*(input_manager: InputManager, button: MouseButton): bool =
  return button in input_manager.mouse_just_released
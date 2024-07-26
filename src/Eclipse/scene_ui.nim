#-- Eclipse Engine -- 
# Author: ZyroX

## Scene UI
## 
## Scene UI holds a collection of UI elements
## Drawn only by the active scene

import sdl2
import sdl2/ttf

import common

type UIElementType* = enum
    uieText

type UIElement* = ref object of RootObj 
    id*: string
    elementType*: UIElementType

    position*: Vec2
    scale*: Vec2
    back_color*: DrawColor
    fore_color*: DrawColor

type TextUIElement* = ref object of UIElement
    font*: FontPtr
    text*: string

type ButtonUIElement* = ref object of UIElement
    text*: string
    pressed*: bool
    hovered*: bool

type SceneUI* = object
    id*: string
    elements*: seq[ref UIElement]

proc newUIElement*(id: string, elementType: UIElementType): UIElement =
    case elementType:
        of uieText: TextUIElement(id: id, elementType: elementType)
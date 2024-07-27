#-- Eclipse Engine -- 
# Author: ZyroX

## Scene UI
## 
## Scene UI holds a collection of UI elements
## Drawn only by the active scene

import sdl2
import sdl2/ttf

import common

type UIElement* = ref object of RootObj 
    id*: string

    visible*: bool

    position*: Vec2
    scale*: Vec2
    back_color*: DrawColor
    fore_color*: DrawColor

type TextUIElement* = ref object of UIElement
    font_id*: string # id of the font, which the renderer figures out the font property from it
    font*: FontPtr
    text*: string

type ButtonUIElement* = ref object of UIElement
    text*: string
    pressed*: bool
    hovered*: bool

type SceneUI* = object
    id*: string
    enabled*: bool
    visible*: bool
    elements*: seq[UIElement]

proc newTextUIElement*(id: string, position: Vec2 = Vec2(x: 0, y: 0), scale: Vec2 = Vec2(x: 1, y: 1), back_color: DrawColor = DrawColor(r: 0, g: 0, b: 0, a: 255), fore_color: DrawColor = DrawColor(r: 255, g: 255, b: 255, a: 255), font_id: string, text: string): TextUIElement =
    TextUIElement(
        id: id,
        position: position,
        scale: scale,
        back_color: back_color,
        fore_color: fore_color,
        font_id: font_id,
        text: text
    )
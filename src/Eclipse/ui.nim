#-- Eclipse Engine -- 
# Author: ZyroX

## Scene UI
## 
## Scene UI holds a collection of UI elements
## Drawn only by the active scene
## 

import std/[tables, sequtils]

import sdl2
import sdl2/ttf

import common

type UIType* = enum
    uitText, 
    uitButton

type UIElement* = ref object of RootObj 
    id*: string

    visible*: bool

    position*: Vec2
    scale*: Vec2
    back_color*: DrawColor
    fore_color*: DrawColor
    case ui_type*: UIType
    of uitText:
        t_font_id*: string
        t_font*: FontPtr
        t_text*: string
    of uitButton:
        b_text*: string
        b_pressed*: bool
        b_hovered*: bool
    else:
        discard

type SceneUI* = object
    id*: string
    enabled*: bool
    visible*: bool
    elements*: seq[UIElement]

## Making these because it's easier to use these than type `t_text", "b_text", etcv

proc setText*(element: UIElement, text: string) =
    case element.ui_type
    of uitText:
        element.t_text = text
    of uitButton:
        element.b_text = text
    else:
        echo "Error: Cannot set text on element of type: ", element.ui_type

proc setFont*(element: UIElement, fm: FontManager, font_id: string) =
    case element.ui_type
    of uitText:
        assert fm.fonts.hasKey(font_id), "Font with that id does not exist in font manager: " & font_id
        var font = fm.fonts[font_id]
        element.t_font_id = font_id
        element.t_font = font
    else:
        echo "Error: Cannot set text on element of type: ", element.ui_type

proc newUIElement*(id: string, ui_type: UIType, position: Vec2 = Vec2(x: 0, y: 0), scale: Vec2 = Vec2(x: 1, y: 1), back_color: DrawColor = DrawColor(r: 0, g: 0, b: 0, a: 255), fore_color: DrawColor = DrawColor(r: 255, g: 255, b: 255, a: 255)): UIElement =
    UIElement(
        id: id,
        visible: true,
        position: position,
        scale: scale,
        back_color: back_color,
        fore_color: fore_color,
        ui_type: ui_type
    )

proc newTextElement*(id: string, text: string, position: Vec2 = Vec2(x: 0, y: 0), scale: Vec2 = Vec2(x: 1, y: 1), back_color: DrawColor = DrawColor(r: 0, g: 0, b: 0, a: 255), fore_color: DrawColor = DrawColor(r: 255, g: 255, b: 255, a: 255)): UIElement =
    result = newUIElement(
        id, 
        uitText, 
        position = position, 
        scale = scale, 
        back_color = back_color, 
        fore_color = fore_color
    )
    result.t_text = text

proc newButtonElement*(id: string, button_text: string): UIElement =
    result = newUIElement(id, uitButton)
    result.b_text = button_text

proc newButtonElement*(id: string, button_text:string, position: Vec2 = Vec2(x: 0, y: 0), scale: Vec2 = Vec2(x: 1, y: 1), back_color: DrawColor = DrawColor(r: 0, g: 0, b: 0, a: 255), fore_color: DrawColor = DrawColor(r: 255, g: 255, b: 255, a: 255)): UIElement =
    result = newUIElement(
        id, 
        uitButton, 
        position = position, 
        scale = scale, 
        back_color = back_color, 
        fore_color = fore_color
    )
    result.b_text = button_text
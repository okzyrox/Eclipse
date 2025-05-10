#-- Eclipse Engine -- 
# Author: ZyroX

## GameObject > SpriteObject

import std/[random]

import sdl2
import sdl2/[image]

import ./[base] # base GameObject
import ../[common, utils]


type
  SpriteObject* = ref object of GameObject
    texture*: TexturePtr
    rect*: Rect
    color*: Color
    rotation*: float32
    flip*: RendererFlip
  
  SpriteObjectInstance* = ref object of GameObjectInstance
    spriteObject*: SpriteObject
    texture*: TexturePtr
    rect*: Rect
    color*: Color
    rotation*: float32
    flip*: RendererFlip
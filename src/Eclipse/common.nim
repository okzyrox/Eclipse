#-- Eclipse Engine -- 
# Author: ZyroX

## Common shared code
##

import std/[tables, os, logging]

import sdl2
import sdl2/ttf

# Eclipse
const EclipseDebugging* = defined(EclipseDebug)

# sdl 

type SDLException* = object of CatchableError

template sdlFailIf*(condition: typed, reason: string) =
  if condition: raise SDLException.newException(
    reason & ", SDL error " & $getError()
  )

# types stuff

type Vec2* = object
  x*: float
  y*: float

type Vec3* = object
  x*: float
  y*: float
  z*: float

type DrawColor* = object
  r*: uint8
  g*: uint8
  b*: uint8
  a*: uint8

type EclipseTexture* = object 
  texturePtr*: TexturePtr
  path*: string
  width*: int
  height*: int
  color*: DrawColor

# logger

proc logEclipse*(msg: varargs[string]): void =
  if EclipseDebugging:
    log(lvlDebug, msg)
  else:
    echo msg

# Fonts

type FontManager* = object
  fonts*: Table[string, FontPtr]

proc addFont*(fm: var FontManager, name: string, path: string,
    size: int = 16): bool =
  if not fileExists(path):
    echo "File does not exist: ", path
    return false
  if name in fm.fonts:
    echo "Font already exists in Game: ", name
    return false

  echo "Loading font: ", path
  var font = ttf.openFont(path.cstring, size.cint)

  if font.isNil:
    echo "Could not load font: ", path
    return false
  else:
    echo "Loaded font: ", path
    fm.fonts[name] = font
    return true

proc getFont*(fm: FontManager, name: string): FontPtr =
  fm.fonts[name]

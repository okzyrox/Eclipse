#-- Eclipse Engine -- 
# Author: ZyroX

## Common shared code
##

import std/[tables, os]

import sdl2
import sdl2/ttf

# Eclipse

const EclipseDebugging* = defined(EclipseDebug) or true


# sdl stuff

type SDLException* = object of CatchableError

template sdlFailIf*(condition: typed, reason: string) =
  if condition: raise SDLException.newException(
    reason & ", SDL error " & $getError()
  )
# object stuff

type Vec2* = object
  x*: float
  y*: float

type Vec3* = object
  x*: float
  y*: float
  z*: float

proc `+`*(a, b: Vec2): Vec2 = Vec2(x: a.x + b.x, y: a.y + b.y)
proc `-`*(a, b: Vec2): Vec2 = Vec2(x: a.x - b.x, y: a.y - b.y)
proc `*`*(a, b: Vec2): Vec2 = Vec2(x: a.x * b.x, y: a.y * b.y)
proc `/`*(a, b: Vec2): Vec2 = Vec2(x: a.x / b.x, y: a.y / b.y)

proc `+`*(a, b: Vec3): Vec3 = Vec3(x: a.x + b.x, y: a.y + b.y, z: a.z + b.z)
proc `-`*(a, b: Vec3): Vec3 = Vec3(x: a.x - b.x, y: a.y - b.y, z: a.z - b.z)
proc `*`*(a, b: Vec3): Vec3 = Vec3(x: a.x * b.x, y: a.y * b.y, z: a.z * b.z)
proc `/`*(a, b: Vec3): Vec3 = Vec3(x: a.x / b.x, y: a.y / b.y, z: a.z / b.z)

proc `==`*(a, b: Vec2): bool = (a.x == b.x) and (a.y == b.y)
proc `==`*(a, b: Vec3): bool = (a.x == b.x) and (a.y == b.y) and (a.z == b.z)

type DrawColor* = object
  r*: uint8
  g*: uint8
  b*: uint8
  a*: uint8

proc toSDL2Color*(dc: DrawColor): Color =
  (r: dc.r.uint8, g: dc.g.uint8, b: dc.b.uint8, a: dc.a.uint8)


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

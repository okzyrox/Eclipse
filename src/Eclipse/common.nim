#-- Eclipse Engine -- 
# Author: ZyroX

## Common shared code
##

import std/[tables, os, logging]

import sdl2

# Eclipse
const EclipseDebugging* = true or defined(EclipseDebug)

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

type SdlRendererFlip* = enum ## proper enums for these, cause there aren't any in the sdl2 bindings
  FlipNone = 0x00000000
  FlipHorizontal = 0x00000001
  FlipVertical = 0x00000002

# temp here due to util overlaps
# potentially will some more here too
proc vec2*(x, y: int): Vec2 =
  result = Vec2(x: x.float, y: y.float)
proc vec2*(x, y: float): Vec2 =
  result = Vec2(x: x, y: y)

proc vec3*(x, y, z: int): Vec3 =
  result = Vec3(x: x.float, y: y.float, z: z.float)
proc vec3*(x, y, z: float): Vec3 =
  result = Vec3(x: x, y: y, z: z)

# logger

proc logEclipse*(msg: varargs[string]): void =
  if EclipseDebugging:
    log(lvlDebug, msg)
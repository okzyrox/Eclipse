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
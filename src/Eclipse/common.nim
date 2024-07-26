#-- Eclipse Engine -- 
# Author: ZyroX

## Common shared code
## 

import sdl2

type SDLException* = object of CatchableError

template sdlFailIf*(condition: typed, reason: string) =
  if condition: raise SDLException.newException(
    reason & ", SDL error " & $getError()
  )


# object stuff

type Vec2* = object
    x*: float
    y*: float

proc `+`*(a, b: Vec2): Vec2 = Vec2(x: a.x + b.x, y: a.y + b.y)
proc `-`*(a, b: Vec2): Vec2 = Vec2(x: a.x - b.x, y: a.y - b.y)
proc `*`*(a, b: Vec2): Vec2 = Vec2(x: a.x * b.x, y: a.y * b.y)
proc `/`*(a, b: Vec2): Vec2 = Vec2(x: a.x / b.x, y: a.y / b.y)

type DrawColor* = object
    r*: uint8
    g*: uint8
    b*: uint8
    a*: uint8
  
proc toSDL2Color*(dc: DrawColor): Color = 
  (r: dc.r.uint8, g: dc.g.uint8, b: dc.b.uint8, a: dc.a.uint8)
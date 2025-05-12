#-- Eclipse Engine -- 
# Author: ZyroX

## Utils for Eclipse

import std/[options]

import sdl2
import sdl2/[image]

import ./[window, common]

proc drawcolor*(r: int, g: int, b: int, a: int): DrawColor =
  DrawColor(r: r.uint8, g: g.uint8, b: b.uint8, a: a.uint8)

proc drawcolor*(r: int, g: int, b: int): DrawColor =
  DrawColor(r: r.uint8, g: g.uint8, b: b.uint8, a: 255.uint8)

proc drawcolor*(r: uint8, g: uint8, b: uint8, a: uint8): DrawColor =
  DrawColor(r: r, g: g, b: b, a: a)

proc loadTexture*(ew: EclipseWindow, path: string): EclipseTexture =
  if ew.renderer.isSome:
    var wr = ew.renderer.get()
    var texture = loadTexture(wr, path.cstring)
    if texture == nil:
      logEclipse "Failed to load texture"
      quit(1)
    let eclTexture = EclipseTexture(
      texturePtr: texture,
      width: 0,
      height: 0,
      path: path,
    )
    result = eclTexture
  else:
    logEclipse "Renderer is not initialized"
    quit(1)
  
proc `$`*(dc: DrawColor): string =
  result = "<DrawColor r=" & $dc.r.uint8 & ", g=" & $dc.g.uint8 & ", b=" & $dc.b.uint8 & ", a=" & $dc.a.uint8 & ">"
proc `$`*(v: Vec2): string =
  result = "<Vec2 x=" & $v.x & ", y=" & $v.y & ">"
proc `$`*(v: Vec3): string =
  result = "<Vec3 x=" & $v.x & ", y=" & $v.y & ", z=" & $v.z & ">"

proc `+`*(a, b: Vec2): Vec2 = Vec2(x: a.x + b.x, y: a.y + b.y)
proc `+`*(a: Vec2, b: float): Vec2 = Vec2(x: a.x + b, y: a.y + b)
proc `+`*(a: Vec2, b: int): Vec2 = Vec2(x: a.x + b.float, y: a.y + b.float)
proc `-`*(a, b: Vec2): Vec2 = Vec2(x: a.x - b.x, y: a.y - b.y)
proc `-`*(a: Vec2, b: float): Vec2 = Vec2(x: a.x - b, y: a.y - b)
proc `-`*(a: Vec2, b: int): Vec2 = Vec2(x: a.x - b.float, y: a.y - b.float)
proc `*`*(a, b: Vec2): Vec2 = Vec2(x: a.x * b.x, y: a.y * b.y)
proc `*`*(a: Vec2, b: float): Vec2 = Vec2(x: a.x * b, y: a.y * b)
proc `*`*(a: Vec2, b: int): Vec2 = Vec2(x: a.x * b.float, y: a.y * b.float)
proc `/`*(a, b: Vec2): Vec2 = Vec2(x: a.x / b.x, y: a.y / b.y)
proc `/`*(a: Vec2, b: float): Vec2 = Vec2(x: a.x / b, y: a.y / b)
proc `/`*(a: Vec2, b: int): Vec2 = Vec2(x: a.x / b.float, y: a.y / b.float)

proc `+`*(a, b: Vec3): Vec3 = Vec3(x: a.x + b.x, y: a.y + b.y, z: a.z + b.z)
proc `+`*(a: Vec3, b: float): Vec3 = Vec3(x: a.x + b, y: a.y + b, z: a.z + b)
proc `+`*(a: Vec3, b: int): Vec3 = Vec3(x: a.x + b.float, y: a.y + b.float, z: a.z + b.float)
proc `-`*(a, b: Vec3): Vec3 = Vec3(x: a.x - b.x, y: a.y - b.y, z: a.z - b.z)
proc `-`*(a: Vec3, b: float): Vec3 = Vec3(x: a.x - b, y: a.y - b, z: a.z - b)
proc `-`*(a: Vec3, b: int): Vec3 = Vec3(x: a.x - b.float, y: a.y - b.float, z: a.z - b.float)
proc `*`*(a, b: Vec3): Vec3 = Vec3(x: a.x * b.x, y: a.y * b.y, z: a.z * b.z)
proc `*`*(a: Vec3, b: float): Vec3 = Vec3(x: a.x * b, y: a.y * b, z: a.z * b)
proc `*`*(a: Vec3, b: int): Vec3 = Vec3(x: a.x * b.float, y: a.y * b.float, z: a.z * b.float)
proc `/`*(a, b: Vec3): Vec3 = Vec3(x: a.x / b.x, y: a.y / b.y, z: a.z / b.z)
proc `/`*(a: Vec3, b: float): Vec3 = Vec3(x: a.x / b, y: a.y / b, z: a.z / b)
proc `/`*(a: Vec3, b: int): Vec3 = Vec3(x: a.x / b.float, y: a.y / b.float, z: a.z / b.float)

proc `==`*(a, b: Vec2): bool = (a.x == b.x) and (a.y == b.y)
proc `==`*(a: Vec2, b: float): bool = (a.x == b) and (a.y == b)
proc `==`*(a: Vec2, b: int): bool = (a.x == b.float) and (a.y == b.float)
proc `==`*(a, b: Vec3): bool = (a.x == b.x) and (a.y == b.y) and (a.z == b.z)
proc `==`*(a: Vec3, b: float): bool = (a.x == b) and (a.y == b) and (a.z == b)
proc `==`*(a: Vec3, b: int): bool = (a.x == b.float) and (a.y == b.float) and (a.z == b.float)

proc toSDL2Color*(dc: DrawColor): Color =
  (r: dc.r.uint8, g: dc.g.uint8, b: dc.b.uint8, a: dc.a.uint8)
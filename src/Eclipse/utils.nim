#-- Eclipse Engine -- 
# Author: ZyroX

## Utils for Eclipse

import std/[options]

import sdl2
import sdl2/[image]

import ./[window, common]

proc drawcolor(r: int, g: int, b: int, a: int): DrawColor =
  DrawColor(r: r.uint8, g: g.uint8, b: b.uint8, a: a.uint8)

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
  else:
    logEclipse "Renderer is not initialized"
    quit(1)

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

proc toSDL2Color*(dc: DrawColor): Color =
  (r: dc.r.uint8, g: dc.g.uint8, b: dc.b.uint8, a: dc.a.uint8)
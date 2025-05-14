#-- Eclipse Engine -- 
# Author: ZyroX

## GameObject > SpriteObject

import std/[options]

import sdl2

import ./[base] # base GameObject
import ../[common, window, texture, events]


type
  SpriteObject* = ref object of GameObject
    texture*: EclipseTexture
    sourceRect*: Option[Rect] # Source rec for spritesheet textures
    destRect*: Rect # Destination rec
    rotation*: float32
    center*: Option[Vec2] # Rotation center
    flip*: RendererFlip

  SpriteObjectInstance* = ref object of GameObjectInstance
    spriteObject*: SpriteObject
    sourceRect*: Option[Rect]
    destRect*: Rect
    rotation*: float32
    center*: Option[Vec2]
    flip*: RendererFlip

    onDraw*: GameEvent

proc newSpriteObject*(name: string): SpriteObject =
  result = SpriteObject(
    name: name,
    components: @[],
    attributes: @[],
    sourceRect: none(Rect),
    destRect: rect(0, 0, 0, 0),
    rotation: 0,
    center: none(Vec2),
    flip: SDL_FLIP_NONE
  )

proc createObject*(spriteObj: SpriteObject): SpriteObjectInstance =
  result = SpriteObjectInstance(
    uid: newUID(),
    gameObject: spriteObj,
    components: spriteObj.components,
    attributes: spriteObj.attributes,
    enabled: true,
    position: Vec2(x: 0, y: 0),
    scale: Vec2(x: 1, y: 1),
    children: @[],
    parent: none(GameObjectInstance),
    
    spriteObject: spriteObj,
    sourceRect: spriteObj.sourceRect,
    destRect: spriteObj.destRect,
    rotation: spriteObj.rotation,
    center: spriteObj.center,
    flip: spriteObj.flip,
    # events
    onUpdate: newEvent(),
    onDraw: newEvent()
  )

proc setTexture*(sprite: var SpriteObject, texture: EclipseTexture) =
  sprite.texture = texture
  sprite.destRect.w = texture.width.cint
  sprite.destRect.h = texture.height.cint

proc setSourceRect*(sprite: var SpriteObject, x, y, w, h: int) =
  sprite.sourceRect = some(rect(x.cint, y.cint, w.cint, h.cint))

proc resetSourceRect*(sprite: var SpriteObject) =
  sprite.sourceRect = none(Rect)

proc setPosition*(sprite: var SpriteObject, x, y: int) =
  sprite.destRect.x = x.cint
  sprite.destRect.y = y.cint

proc setSize*(sprite: var SpriteObject, w, h: int) =
  sprite.destRect.w = w.cint
  sprite.destRect.h = h.cint

proc setRotation*(sprite: var SpriteObject, angle: float32) =
  sprite.rotation = angle

proc setRotationCenter*(sprite: var SpriteObject, x, y: int) =
  sprite.center = some(vec2(x, y))

proc resetRotationCenter*(sprite: var SpriteObject) =
  sprite.center = none(Vec2)

proc setFlip*(sprite: var SpriteObject, flip: RendererFlip) =
  sprite.flip = flip

proc draw*(ew: EclipseWindow, sprite: SpriteObject) =
  if ew.renderer.isNone:
    logEclipse "Cannot draw sprite: renderer is none"
    return

  let renderer = ew.renderer.get()
  
  # color mod
  discard sprite.texture.texturePtr.setTextureColorMod(
    sprite.texture.color.r, 
    sprite.texture.color.g, 
    sprite.texture.color.b
  )
  discard sprite.texture.texturePtr.setTextureAlphaMod(sprite.texture.color.a)
  
  let srcRect = if sprite.sourceRect.isSome: addr sprite.sourceRect.get() else: nil
  var centerPtr: ptr Point 
  if sprite.center.isSome: 
    # convert to point
    let centerVec = sprite.center.get() 
    let centerPnt = point(centerVec.x.cint, centerVec.y.cint)
    centerPtr = addr centerPnt
  else:
    centerPtr = nil
  
  # draw that texture
  discard renderer.copyEx(
    sprite.texture.texturePtr, 
    srcRect,
    addr sprite.destRect,
    sprite.rotation,
    centerPtr,
    sprite.flip
  )
  # discarded but might change to log an error 

proc draw*(ew: EclipseWindow, sprite: SpriteObjectInstance) =
  if not sprite.enabled:
    return
  
  if ew.renderer.isNone:
    logEclipse "Cannot draw sprite: renderer is none"
    return
    
  let renderer = ew.renderer.get()
  
  var destRect = sprite.destRect
  destRect.x = (sprite.position.x).cint
  destRect.y = (sprite.position.y).cint
  destRect.w = (sprite.destRect.w.float * sprite.scale.x).cint
  destRect.h = (sprite.destRect.h.float * sprite.scale.y).cint
  
  discard sprite.spriteObject.texture.texturePtr.setTextureColorMod(
    sprite.spriteObject.texture.color.r, 
    sprite.spriteObject.texture.color.g, 
    sprite.spriteObject.texture.color.b
  )
  discard sprite.spriteObject.texture.texturePtr.setTextureAlphaMod(
    sprite.spriteObject.texture.color.a
  )
  
  let srcRect = if sprite.sourceRect.isSome: addr sprite.sourceRect.get() else: nil
  var centerPtr: ptr Point 
  if sprite.center.isSome: 
    let centerVec = sprite.center.get() 
    let centerPnt = point(centerVec.x.cint, centerVec.y.cint)
    centerPtr = addr centerPnt
  else:
    centerPtr = nil
  
  discard renderer.copyEx(
    sprite.spriteObject.texture.texturePtr, 
    srcRect,
    addr destRect,
    sprite.rotation,
    centerPtr,
    sprite.flip
  )

  sprite.onDraw.fireAll()
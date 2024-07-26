#-- Eclipse Engine -- 
# Author: ZyroX

## Entity
## 
## Entity is usually a game object that has position, velocity, controls, and other properties
import sdl2

import common

type EntityMoveDir* = enum
    emdUp
    emdDown
    emdLeft
    emdRight

type Entity* = object
    id*: string
    color*: DrawColor
    position*: Vec2
    scale*: Vec2
    speed*: Vec2
    rotation*: float

proc newEntity*(id: string): Entity =
    result = Entity(id: id, color: DrawColor(r: 255, g: 255, b: 255, a: 255), position: Vec2(x: 0, y: 0), scale: Vec2(x: 1, y: 1), speed: Vec2(x: 0, y: 0), rotation: 0)


proc update*(entity: Entity) =
    # do later
    discard

proc draw*(renderer: RendererPtr, entity: Entity) =
    renderer.setDrawColor(entity.color.r, entity.color.g, entity.color.b, entity.color.a)
    var r = rect(
        cint(entity.position.x), cint(entity.position.y),
        cint(2 * entity.scale.x), cint(2 * entity.scale.y)
    )
    renderer.fillRect(r)

proc move*(entity: var Entity, dir: EntityMoveDir) = 
    case dir:
        of emdUp:
            entity.position = entity.position + Vec2(x: 0, y: -entity.speed.y)
        of emdDown:
            entity.position = entity.position + Vec2(x: 0, y: entity.speed.y)
        of emdLeft:
            entity.position = entity.position + Vec2(x: -entity.speed.x, y: 0)
        of emdRight:
            entity.position = entity.position + Vec2(x: entity.speed.x, y: 0)
#-- Eclipse Engine -- 
# Author: ZyroX

## Entity
## 
## Entity is usually a game object that has position, velocity, controls, and other properties
import sdl2

import common

type Entity* = object
    id: string
    position*: Vec2
    scale*: Vec2
    rotation*: float

proc newEntity*(id: string): Entity =
    result = Entity(id: id, position: Vec2(x: 0, y: 0), scale: Vec2(x: 1, y: 1), rotation: 0)


proc update*(entity: Entity) =
    # do later
    discard

proc draw*(renderer: RendererPtr, entity: Entity) =
    renderer.setDrawColor 255, 255, 255, 255 # white
    var r = rect(
        cint(entity.position.x), cint(entity.position.y),
        cint(2 * entity.scale.x), cint(2 * entity.scale.y)
    )
    renderer.fillRect(r)
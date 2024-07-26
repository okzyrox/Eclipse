#-- Eclipse Engine -- 
# Author: ZyroX

## Scene
## 
## Scene holds a collection of entities, objects, and other things that can be rendered
## 

import sdl2

import common, entity, scene_ui

type Scene* = object
    id*: string # scenes are stored by id

    ui*: SceneUI
    entities*: seq[Entity]
    #objects: seq[Object]

proc newScene*(id: string): Scene = 
    Scene(id: id, entities: @[])

proc `==`*(a, b: Scene): bool = a.id == b.id
proc `==`*(a: Scene, id: string): bool = a.id == id

proc add*(scene: var Scene, entity: Entity) = scene.entities.add(entity)

proc update*(scene: var Scene) = 
    for entity in scene.entities:
        entity.update()
    
proc draw*(renderer: RendererPtr, scene: var Scene) = 
    for entity in scene.entities:
        echo "Drawing entity: ", entity.id
        draw(renderer, entity)


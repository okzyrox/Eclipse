#-- Eclipse Engine -- 
# Author: ZyroX

## Scene
## 
## Scene holds a collection of entities, objects, and other things that can be rendered
## 

import sdl2

import common, entity, ui

type Scene* = object
    id*: string # scenes are stored by id

    ui*: SceneUI
    entities*: seq[Entity]
    #objects: seq[Object]

proc newScene*(id: string): Scene = 
    Scene(id: id, entities: @[])

proc `==`*(a, b: Scene): bool = a.id == b.id
proc `==`*(a: Scene, id: string): bool = a.id == id

proc `$`*(scene: Scene): string =
    "<Scene: " & "ID: " & scene.id & "> "

proc add*(scene: var Scene, entity: Entity) = 
    scene.entities.add(entity)

proc remove*(scene: var Scene, entity: Entity) =
    scene.entities.delete(scene.entities.find(entity))

proc update*(scene: var Scene) = 
    for entity in scene.entities:
        entity.update()
    
proc draw*(renderer: RendererPtr, scene: var Scene) = 
    for entity in scene.entities:
        echo "Drawing entity: ", entity.id
        draw(renderer, entity)

proc add*(scene: var Scene, uiElement: UIElement) = 
    scene.ui.elements.add(uiElement)

proc remove*(scene: var Scene, uiElement: UIElement) = 
    scene.ui.elements.delete(scene.ui.elements.find(uiElement))
#-- Eclipse Engine -- 
# Author: ZyroX

## Scene
##
## Scene holds a collection of objects and other things that can be rendered
##

import gameobject/[base]

type Scene* = object
  id*: string # stored by id

  objects*: seq[GameObjectInstance]

proc newScene*(id: string): Scene =
  Scene(id: id, objects: @[])

proc add*(scene: var Scene, entity: GameObjectInstance) =
  scene.objects.add(entity)
  entity.enabled = true

proc remove*(scene: var Scene, entity: GameObjectInstance) =
  scene.objects.delete(scene.objects.find(entity))
  entity.enabled = false

proc update*(scene: var Scene) =
  for i in 0 ..< scene.objects.len:
    var obj = scene.objects[i]
    if obj.enabled:
      obj.update()
      scene.objects[i] = obj # replicate 

#-- Eclipse Engine -- 
# Author: ZyroX

## Scene
##
## Scene holds a collection of objects and other things that can be rendered
##

import gameobject/[base, spriteobject]
import ./[window]

type Scene* = object
  id*: string # stored by id

  objects*: seq[GameObjectInstance]

proc newScene*(id: string): Scene =
  Scene(id: id, objects: @[])

proc add*(scene: var Scene, obj: GameObjectInstance) =
  scene.objects.add(obj)
  obj.enabled = true

proc remove*(scene: var Scene, obj: GameObjectInstance) =
  scene.objects.delete(scene.objects.find(obj))
  obj.enabled = false

proc update*(scene: var Scene) =
  for i in 0 ..< scene.objects.len:
    var obj = scene.objects[i]
    if obj.enabled:
      obj.update()
      scene.objects[i] = obj # replicate 

proc draw*(scene: Scene, ew: EclipseWindow) =
  for obj in scene.objects:
    if obj.enabled:
      if obj of SpriteObjectInstance:
        draw(ew, SpriteObjectInstance(obj))
      else:
        discard
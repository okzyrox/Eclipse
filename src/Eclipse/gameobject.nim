#-- Eclipse Engine -- 
# Author: ZyroX

## GameObject (and components)

import ./[common]

import std/[random, options]

const
  ObjectCap* = 100000 # todo: have a way of checking for the cap..

type
  GameObject* = ref object of RootObj
    name*: string
    components*: seq[Component]
  ComponentProc* = proc(obj: GameObjectInstance, cmp: Component)
  Component* = object
    enabled*: bool
    script*: ComponentProc
  
  GameObjectInstance* = ref object of RootObj
    uid*: string
    gameObject*: GameObject
    components*: seq[Component]
    enabled*: bool
    # attr
    position*: Vec2
    scale*: Vec2

    # sub objects
    children*: seq[GameObjectInstance]
    parent*: Option[GameObjectInstance] 

proc newUID*(): string =
  randomize()
  let uid = rand(0..ObjectCap)
  result = $uid

proc newObject*(name: string): GameObject =
  result = GameObject(name: name, components: @[])

proc add*(obj: var GameObject, cmp: var Component) =
  obj.components.add(cmp)
  cmp.enabled = true

proc createObject*(gameObject: GameObject, parent: Option[GameObjectInstance]): GameObjectInstance =
  result = GameObjectInstance(
    uid: newUID(),
    gameObject: gameObject, 
    components: gameObject.components, 
    enabled: true,
    position: Vec2(x: 0, y: 0), 
    scale: Vec2(x: 1, y: 1),
    children: @[],
    parent: none(GameObjectInstance)
  )
  if parent.isSome:
    result.parent = parent
    parent.get().children.add(result)
  else:
    result.parent = none(GameObjectInstance)
  for cmp in gameObject.components:
    result.components.add(cmp)

proc update*(obj: GameObjectInstance, cmp: Component) = 
  if cmp.enabled:
    cmp.script(obj, cmp)

proc update*(obj: GameObjectInstance) =
  for cmp in obj.components:
    if cmp.enabled:
      update(obj, cmp)

proc getChildren*(obj: GameObjectInstance): seq[GameObjectInstance] =
  result = obj.children

proc getDescendants*(obj: GameObjectInstance): seq[GameObjectInstance] =
  result = @[]
  for child in obj.children:
    result.add(child)
    result.add(getDescendants(child))
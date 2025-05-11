#-- Eclipse Engine -- 
# Author: ZyroX

## GameObject (and components)

import std/[random, options]

import ../[common, attribute, events]


const
  ObjectCap* = 100000 # todo: have a way of checking for the cap..

type
  GameObject* = ref object of RootObj
    name*: string
    components*: seq[Component]
    attributes*: seq[ObjectAttribute]
  ComponentProc* = proc(obj: var GameObjectInstance, cmp: Component)
  Component* = object
    enabled*: bool
    script*: ComponentProc
  
  GameObjectInstance* = ref object of RootObj
    uid*: string
    gameObject*: GameObject
    components*: seq[Component]
    attributes*: seq[ObjectAttribute]
    enabled*: bool
    # attr
    position*: Vec2
    scale*: Vec2

    # sub objects
    children*: seq[GameObjectInstance]
    parent*: Option[GameObjectInstance] 

    # events

    onCreate*: GameEvent = GameEvent()
    onDestroy*: GameEvent = GameEvent()
    onUpdate*: GameEvent = GameEvent()

proc `$`*(obj: GameObject): string =
  result = "<GameObject " & obj.name & " (" & $obj.components.len & " components)>"

proc `$`*(obj: GameObjectInstance): string =
  result = "<GameObjectInstance " & obj.uid & " (" & $obj.components.len & " components)>"

proc `$`*(obj: Component): string =
  result = "<Component " & "(enabled=" & $obj.enabled & ")>"

proc newUID*(): string =
  randomize()
  let uid = rand(0..ObjectCap)
  result = $uid

proc newObject*(name: string): GameObject =
  result = GameObject(name: name, components: @[])

proc add*(obj: var GameObject, cmp: var Component) =
  obj.components.add(cmp)
  cmp.enabled = true

proc add*(obj: var GameObject, cmpProc: ComponentProc) =
  var cmp = Component(
    enabled: true,
    script: cmpProc
  )
  obj.components.add(cmp)

proc createObject*(gameObject: GameObject, parent: Option[GameObjectInstance]): GameObjectInstance =
  result = GameObjectInstance(
    uid: newUID(),
    gameObject: gameObject, 
    components: gameObject.components, 
    attributes: gameObject.attributes,
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

proc createObject*(gameObject: GameObject): GameObjectInstance =
  result = createObject(gameObject, none(GameObjectInstance))

proc update*(obj: var GameObjectInstance, cmp: Component) = 
  if cmp.enabled:
    cmp.script(obj, cmp)

proc update*(obj: var GameObjectInstance) =
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

proc addAttribute*[T: AttributeGenericTypes](obj: var GameObject, name: string, value: T) =
  var attr = newAttribute(name, value)
  obj.attributes.add(attr)

proc addAttribute*[T: AttributeGenericTypes](obj: var GameObjectInstance, name: string, value: T) =
  var attr = newAttribute(name, value)
  obj.attributes.add(attr)

proc getAttribute*(obj: GameObject, name: string): Option[ObjectAttribute] =
  for attr in obj.attributes:
    if attr.name == name:
      return some(attr)
  return none(ObjectAttribute)
  
proc getAttribute*(obj: GameObjectInstance, name: string): Option[ObjectAttribute] =
  for attr in obj.attributes:
    if attr.name == name:
      return some(attr)
  return none(ObjectAttribute)

proc setAttribute*[T: AttributeGenericTypes](obj: var GameObject, name: string, value: T): bool =
  for i in 0 ..< obj.attributes.len:
    if obj.attributes[i].name == name:
      obj.attributes[i].setAttributeValue(value)
      return true
  logEclipse "Attribute not found: ", name
  return false

proc setAttribute*[T: AttributeGenericTypes](obj: var GameObjectInstance, name: string, value: T): bool =
  for i in 0 ..< obj.attributes.len:
    if obj.attributes[i].name == name:
      obj.attributes[i].setAttributeValue(value)
      return true
  logEclipse "Attribute not found: ", name
  return false

proc removeAttribute*(obj: var GameObject, name: string): bool =
  for i in 0 ..< obj.attributes.len:
    if obj.attributes[i].name == name:
      obj.attributes.delete(i)
      return true
  logEclipse "Attribute not found: ", name
  return false

proc removeAttribute*(obj: var GameObjectInstance, name: string): bool =
  for i in 0 ..< obj.attributes.len:
    if obj.attributes[i].name == name:
      obj.attributes.delete(i)
      return true
  logEclipse "Attribute not found: ", name
  return false
#-- Eclipse Engine -- 
# Author: ZyroX

## GameObject (and components)

import std/[random, options, typetraits]

import ../[common, attribute, events]


const
  ObjectCap* = 100000 # todo: have a way of checking for the cap..

type
  GameObject* = ref object of RootObj
    name*: string
    components*: seq[Component]
    attributes*: seq[ObjectAttribute]

  ComponentTarget* = enum
    ctGameObject,
    ctSpriteObject 
  
  ComponentTemplateKind* = enum
    ctkStart
    ctkUpdate

  GenericComponentProc* = proc(obj: var RootRef, cmp: Component)
  
  Component* = object
    enabled*: bool
    startScript*: GenericComponentProc
    updateScript*: GenericComponentProc
    target*: ComponentTarget
  
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

    onUpdate*: GameEvent

proc newUID*(): string =
  randomize()
  let uid = rand(0..ObjectCap)
  result = $uid

proc newObject*(name: string): GameObject =
  result = GameObject(name: name, components: @[])

proc newGameObjectComponent*(startCmpProc, updateCmpProc: GenericComponentProc): Component =
  result = Component(
    enabled: true,
    startScript: startCmpProc,
    updateScript: updateCmpProc,
    target: ctGameObject
  )

proc newComponent*(startCmpProc, updateCmpProc: GenericComponentProc, target: ComponentTarget): Component =
  result = Component(
    enabled: true,
    startScript: startCmpProc,
    updateScript: updateCmpProc,
    target: target
  )

template makeComponent*[T](targetType: typedesc[T], name: string, kind: ComponentTemplateKind = ctkUpdate, body: untyped): Component =
  
  proc componentProc(objRef: var RootRef, cmp: Component) =
    var obj {.inject.} = T(objRef)  # auto cast
    body
  
  if kind == ctkStart:
    Component(
      enabled: true,
      startScript: componentProc,
      updateScript: nil,
      target: when T is GameObjectInstance: ctGameObject else: ctSpriteObject
    )
  else:
    Component(
      enabled: true,
      startScript: nil,
      updateScript: componentProc,
      target: when T is GameObjectInstance: ctGameObject else: ctSpriteObject
    )

proc addComponent*[T: GameObject](obj: var T, cmp: var Component) =
  obj.components.add(cmp)
  cmp.enabled = true

# for backward compatibility

proc addComponent*[T: GameObject](obj: var T, startCmpProc, updateCmpProc: GenericComponentProc) =
  var cmp = Component(
    enabled: true,
    startScript: startCmpProc,
    updateScript: updateCmpProc,
    target: ctGameObject
  )
  obj.addComponent(cmp)

proc addComponent*(obj: var GameObject, startCmpProc, updateCmpProc: GenericComponentProc) =
  var cmp = Component(
    enabled: true,
    startScript: startCmpProc,
    updateScript: updateCmpProc,
    target: ctGameObject
  )
  obj.addComponent(cmp)

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
    parent: none(GameObjectInstance),
    # events
    onUpdate: newEvent()
  )
  if parent.isSome:
    result.parent = parent
    parent.get().children.add(result)
  else:
    result.parent = none(GameObjectInstance)

proc createObject*(gameObject: GameObject): GameObjectInstance =
  result = createObject(gameObject, none(GameObjectInstance))
  for cmp in gameObject.components:
    if cmp.enabled and cmp.startScript != nil:
      var objRef: RootRef = result
      cmp.startScript(objRef, cmp)

proc update*(obj: var GameObjectInstance, cmp: Component) = 
  if cmp.enabled and cmp.updateScript != nil:
    var objRef: RootRef = obj
    cmp.updateScript(objRef, cmp)

proc update*(obj: var GameObjectInstance) =
  for cmp in obj.components:
    if cmp.enabled and cmp.updateScript != nil:
      update(obj, cmp)
  
  obj.onUpdate.fireAll()

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

proc getAttributeValue*[T: AttributeGenericTypes](obj: GameObject, name: string, kind: typedesc[T]): T =
  for i in 0 ..< obj.attributes.len:
    if obj.attributes[i].name == name:
      return obj.attributes[i].getAttributeValue(T)
  logEclipse "Attribute not found: ", name
  return default(T)

proc getAttributeValue*[T: AttributeGenericTypes](obj: GameObjectInstance, name: string, kind: typedesc[T]): T =
  for i in 0 ..< obj.attributes.len:
    if obj.attributes[i].name == name:
      return obj.attributes[i].getAttributeValue(T)
  logEclipse "Attribute not found: ", name
  return default(T)

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
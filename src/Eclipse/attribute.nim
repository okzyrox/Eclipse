#-- Eclipse Engine --
# Author: ZyroX

## Attributes (for gameobjects)

import ./[common]

type
  ObjectAttributeType* = enum
    oatString,
    oatInt,
    oatFloat,
    oatBool,
    oatVec2,
    oatVec3
    oatDrawColor

  ObjectAttribute* = object
    name*: string
    case kind*: ObjectAttributeType
      of oatString:
        stringValue*: string
      of oatInt:
        intValue*: int
      of oatFloat:
        floatValue*: float
      of oatBool:
        boolValue*: bool
      of oatVec2:
        vec2Value*: Vec2
      of oatVec3:
        vec3Value*: Vec3
      of oatDrawColor:
        drawColorValue*: DrawColor

# so i dont have to type it over and over and over and over
type AttributeGenericTypes* = string | int | float | bool | Vec2 | Vec3 | DrawColor

proc newAttribute*[T: AttributeGenericTypes](name: string, value: T): ObjectAttribute =
  var kind: ObjectAttributeType

  when T is string:
    kind = oatString
  elif T is int:
    kind = oatInt
  elif T is float:
    kind = oatFloat
  elif T is bool:
    kind = oatBool
  elif T is Vec2:
    kind = oatVec2
  elif T is Vec3:
    kind = oatVec3
  elif T is DrawColor:
    kind = oatDrawColor
  else:
    {.error: "Unsupported type for ObjectAttribute".}

  result = ObjectAttribute(name: name, kind: kind)

  when T is string:
    result.stringValue = value
  elif T is int:
    result.intValue = value
  elif T is float:
    result.floatValue = value
  elif T is bool:
    result.boolValue = value
  elif T is Vec2:
    result.vec2Value = value
  elif T is Vec3:
    result.vec3Value = value
  elif T is DrawColor:
    result.drawColorValue = value


proc getAttributeValue*(attr: ObjectAttribute, _: typedesc[string]): string =
  if attr.kind != oatString:
    raise newException(ValueError, "Expected string")
  result = attr.stringValue

proc getAttributeValue*(attr: ObjectAttribute, _: typedesc[int]): int =
  if attr.kind != oatInt:
    raise newException(ValueError, "Expected int")
  result = attr.intValue

proc getAttributeValue*(attr: ObjectAttribute, _: typedesc[float]): float =
  if attr.kind != oatFloat:
    raise newException(ValueError, "Expected float")
  result = attr.floatValue

proc getAttributeValue*(attr: ObjectAttribute, _: typedesc[bool]): bool =
  if attr.kind != oatBool:
    raise newException(ValueError, "Expected bool")
  result = attr.boolValue

proc getAttributeValue*(attr: ObjectAttribute, _: typedesc[Vec2]): Vec2 =
  if attr.kind != oatVec2:
    raise newException(ValueError, "Expected Vec2")
  result = attr.vec2Value

proc getAttributeValue*(attr: ObjectAttribute, _: typedesc[Vec3]): Vec3 =
  if attr.kind != oatVec3:
    raise newException(ValueError, "Expected Vec3")
  result = attr.vec3Value

proc getAttributeValue*(attr: ObjectAttribute, _: typedesc[DrawColor]): DrawColor =
  if attr.kind != oatDrawColor:
    raise newException(ValueError, "Expected DrawColor")
  result = attr.drawColorValue

proc setAttributeValue*(attr: var ObjectAttribute, val: string) =
  if attr.kind != oatString:
    raise newException(ValueError, "Expected string")
  attr.stringValue = val

proc setAttributeValue*(attr: var ObjectAttribute, val: int) =
  if attr.kind != oatInt:
    raise newException(ValueError, "Expected int")
  attr.intValue = val

proc setAttributeValue*(attr: var ObjectAttribute, val: float) =
  if attr.kind != oatFloat:
    raise newException(ValueError, "Expected float")
  attr.floatValue = val

proc setAttributeValue*(attr: var ObjectAttribute, val: bool) =
  if attr.kind != oatBool:
    raise newException(ValueError, "Expected bool")
  attr.boolValue = val

proc setAttributeValue*(attr: var ObjectAttribute, val: Vec2) =
  if attr.kind != oatVec2:
    raise newException(ValueError, "Expected Vec2")
  attr.vec2Value = val

proc setAttributeValue*(attr: var ObjectAttribute, val: Vec3) =
  if attr.kind != oatVec3:
    raise newException(ValueError, "Expected Vec3")
  attr.vec3Value = val

proc setAttributeValue*(attr: var ObjectAttribute, val: DrawColor) =
  if attr.kind != oatDrawColor:
    raise newException(ValueError, "Expected DrawColor")
  attr.drawColorValue = val

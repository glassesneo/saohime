import
  pkg/[ecslib, oolib]

class pub Point:
  discard

class pub Line:
  var x, y: float

class pub Rectangle:
  var width, height: float

class pub Circle:
  var radius: float

type
  ShapePlugin* = ref object
    name: string

proc new*(_: type ShapePlugin): ShapePlugin =
  return ShapePlugin(name: "ShapePlugin")

proc build*(plugin: ShapePlugin, world: World) =
  discard

export new


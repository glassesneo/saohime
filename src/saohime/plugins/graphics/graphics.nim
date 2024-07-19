import
  std/[colors],
  pkg/[ecslib, oolib],
  ../../core/[saohime_types]

class pub Point:
  discard

class pub Line:
  var x*, y*: float

class pub Rectangle:
  var width*, height*: float

class pub Circle:
  var radius*: float

type
  Material* = ref object
    fill*, stroke*: SaohimeColor = colWhite.toSaohimeColor()

  GraphicsPlugin* = ref object
    name*: string

proc new*(
    _: type Material,
    fill = SaohimeColor.new(colWhite, 0),
    stroke = SaohimeColor.new(colWhite, 0),
): Material =
  return Material(fill: fill, stroke: stroke)

proc new*(_: type GraphicsPlugin): GraphicsPlugin =
  return GraphicsPlugin(name: "GraphicsPlugin")

proc build*(plugin: GraphicsPlugin, world: World) =
  discard

export new


import
  std/[colors],
  pkg/[ecslib, oolib]

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
    color*: tuple[r, g, b, a: range[0..255]]
    filled*: bool

  GraphicsPlugin* = ref object
    name*: string

proc new*(
    _: type Material,
    r, g, b: range[0..255],
    a: range[0..255] = 255,
    filled = true
): Material =
  return Material(color: (r, g, b, a), filled: filled)

proc new*(
    _: type Material,
    color: Color = colWhite,
    a: range[0..255] = 255,
    filled = true
): Material =
  let (r, g, b) = color.extractRGB()
  return Material.new(r, g, b, a, filled)

proc new*(_: type GraphicsPlugin): GraphicsPlugin =
  return GraphicsPlugin(name: "GraphicsPlugin")

proc build*(plugin: GraphicsPlugin, world: World) =
  discard

export new


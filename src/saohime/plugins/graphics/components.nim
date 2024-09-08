{.push raises: [].}

import
  std/[colors],
  pkg/ecslib,
  pkg/[seiryu],
  ../../core/[saohime_types]

type
  Point* = ref object

  Line* = ref object
    vector*: Vector

  Rectangle* = ref object
    size*: Vector

  Circle* = ref object
    radius*: float

  Material* = ref object
    fill*, stroke*: SaohimeColor = colWhite.toSaohimeColor()

proc new*(T: type Point): T {.construct.}

proc new*(T: type Line, vector: Vector): T {.construct.}

proc new*(T: type Rectangle, size: Vector): T {.construct.}

proc new*(T: type Rectangle; width, height: float): T {.construct.} =
  return Rectangle.new(Vector.new(width, height))

proc new*(T: type Circle, radius: float): T {.construct.}

proc new*(
    T: type Material,
    fill = SaohimeColor.new(colWhite, 0),
    stroke = SaohimeColor.new(colWhite, 0),
): T {.construct.}

proc new*(T: type Material, color: SaohimeColor): T {.construct.} =
  result.fill = color
  result.stroke = color

proc `color=`*(material: Material, color: SaohimeColor) =
  material.fill = color
  material.stroke = color

export new


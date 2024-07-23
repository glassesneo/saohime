{.push raises: [].}

import
  std/[colors],
  pkg/[ecslib, oolib],
  ../../core/[saohime_types]

class pub Point:
  discard

class pub Line:
  var vector*: Vector
  proc `new`(x, y: float) =
    self.vector = Vector.new(x, y)

class pub Rectangle:
  var size*: Vector
  proc `new`(width, height: float) =
    self.size = Vector.new(width, height)

class pub Circle:
  var radius*: float

type
  Material* = ref object
    fill*, stroke*: SaohimeColor = colWhite.toSaohimeColor()

proc new*(
    _: type Material,
    fill = SaohimeColor.new(colWhite, 0),
    stroke = SaohimeColor.new(colWhite, 0),
): Material =
  return Material(fill: fill, stroke: stroke)

export new


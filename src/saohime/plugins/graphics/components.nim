{.push raises: [].}
import std/[colors]
import pkg/[ecslib, seiryu]
import ../../core/[saohime_types]

type
  Point* = ref object

  Line* = ref object
    vector*: Vector

  Rectangle* = ref object
    size*: Vector

  Circle* = ref object
    radius*: float

  Fill* = ref object
    color*: SaohimeColor

  Border* = ref object
    color*: SaohimeColor

proc new*(T: type Point): T {.construct.}

proc new*(T: type Line, vector: Vector): T {.construct.}

proc new*(T: type Rectangle, size: Vector): T {.construct.}

proc new*(T: type Rectangle, width, height: float): T {.construct.} =
  return Rectangle.new(Vector.new(width, height))

proc new*(T: type Circle, radius: float): T {.construct.}

proc new*(T: type Fill, color = colWhite.toSaohimeColor()): T {.construct.}

proc new*(T: type Border, color = colWhite.toSaohimeColor()): T {.construct.}

proc PointBundle*(
    entity: Entity, color: SaohimeColor
): Entity {.discardable, raises: [KeyError].} =
  return entity.withBundle((Point.new(), Fill.new(color = color)))

proc LineBundle*(
    entity: Entity, vector: Vector, color: SaohimeColor
): Entity {.discardable, raises: [KeyError].} =
  return entity.withBundle((Line.new(vector = vector), Fill.new(color = color)))

proc RectangleBundle*(
    entity: Entity, size: Vector, bg, border: SaohimeColor
): Entity {.discardable, raises: [KeyError].} =
  return entity.withBundle(
    (Rectangle.new(size = size), Fill.new(color = bg), Border.new(color = border))
  )

proc RectangleBundle*(
    entity: Entity, size: Vector, bg: SaohimeColor
): Entity {.discardable, raises: [KeyError].} =
  return entity.withBundle((Rectangle.new(size = size), Fill.new(color = bg)))

proc RectangleBundle*(
    entity: Entity, size: Vector, border: SaohimeColor
): Entity {.discardable, raises: [KeyError].} =
  return entity.withBundle((Rectangle.new(size = size), Border.new(color = border)))

proc CircleBundle*(
    entity: Entity, radius: float, bg, border: SaohimeColor
): Entity {.discardable, raises: [KeyError].} =
  return entity.withBundle(
    (Circle.new(radius = radius), Fill.new(color = bg), Border.new(color = border))
  )

proc CircleBundle*(
    entity: Entity, radius: float, bg: SaohimeColor
): Entity {.discardable, raises: [KeyError].} =
  return entity.withBundle((Circle.new(radius = radius), Fill.new(color = bg)))

proc CircleBundle*(
    entity: Entity, radius: float, border: SaohimeColor
): Entity {.discardable, raises: [KeyError].} =
  return entity.withBundle((Circle.new(radius = radius), Border.new(color = border)))

export new

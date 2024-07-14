import
  std/[math],
  pkg/[ecslib, oolib]

type
  Vector* = ref object
    x*, y*: float

  Transform* = ref object
    position*: Vector
    rotation*: float
    scale*: Vector

proc new*(_: type Vector; x, y: float): Vector =
  return Vector(x: x, y: y)

proc `+`*(a, b: Vector): Vector =
  return Vector.new(a.x + b.x, a.y + b.y)

proc `-`*(vector: Vector): Vector =
  return Vector.new(-vector.x, -vector.y)

proc `-`*(a, b: Vector): Vector =
  return Vector.new(a.x - b.x, a.y - b.y)

proc `*`*(vector: Vector; scalar: float): Vector =
  return Vector.new(vector.x * scalar, vector.y * scalar)

proc `/`*(vector: Vector; scalar: float): Vector =
  return Vector.new(vector.x / scalar, vector.y / scalar)

proc len*(vector: Vector): float =
  return abs(vector.x^2 + vector.y^2)

proc normalized*(vector: Vector): Vector =
  return vector / vector.len()

proc `$`*(vector: Vector): string =
  return "(" & $vector.x & ", " & $vector.y & ")"

proc new*(
    _: type Transform;
    position = Vector.new(0, 0);
    rotation: float = 0f;
    scale = Vector.new(0, 0)
): Transform =
  return Transform(
    position: position,
    rotation: rotation,
    scale: scale
  )

proc translate*(
    transform: Transform;
    x: float = 0f;
    y: float = 0f
) =
  transform.position.x += x
  transform.position.y += y

proc rotate*(transform: Transform; radian: float) =
  transform.rotation += radian

proc scale*(
    transform: Transform;
    x: float = 0f;
    y: float = 0f
) =
  transform.scale.x += x
  transform.scale.y += y

class pub TransformPlugin:
  var name* {.initial.} = "TransformPlugin"
  proc build*(world: World) =
    discard

export new
export TransformPlugin


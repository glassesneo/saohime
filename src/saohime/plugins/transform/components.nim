{.push raises: [].}
import pkg/[ecslib, seiryu]
import ../../core/[saohime_types]

type Transform* = ref object
  position*: Vector
  rotation*: float
  scale*: Vector

proc new*(
  T: type Transform, position: Vector, rotation: float = 0f, scale = Vector.new(1, 1)
): T {.construct.}

proc new*(
    T: type Transform,
    x: float = 0f,
    y: float = 0f,
    rotation: float = 0f,
    scale = Vector.new(1, 1),
): T {.construct.} =
  result.position = Vector.new(x, y)
  result.rotation = rotation
  result.scale = scale

proc translate*(transform: Transform, x: float = 0f, y: float = 0f) =
  transform.position.x += x
  transform.position.y += y

proc rotate*(transform: Transform, radian: float) =
  transform.rotation += radian

proc renderedPosition*(transform: Transform): Vector =
  return Vector.new(
    transform.position.x / transform.scale.x, transform.position.y / transform.scale.y
  )

export new

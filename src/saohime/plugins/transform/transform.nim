import
  pkg/[ecslib, oolib],
  ../../core/[saohime_types]

type
  Transform* = ref object
    position*: Vector
    rotation*: float
    scale*: Vector

proc new*(
    _: type Transform;
    position: Vector;
    rotation: float = 0f;
    scale = Vector.new(1, 1)
): Transform =
  return Transform(
    position: position,
    rotation: rotation,
    scale: scale
  )

proc new*(
    _: type Transform;
    x: float = 0f;
    y: float = 0f;
    rotation: float = 0f;
    scale = Vector.new(1, 1)
): Transform =
  return Transform(
    position: Vector.new(x, y),
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

proc renderedPosition*(transform: Transform): Vector =
  return Vector.new(
    transform.position.x / transform.scale.x,
    transform.position.y / transform.scale.y
  )

class pub TransformPlugin:
  var name* {.initial.} = "TransformPlugin"
  proc build*(world: World) =
    discard

export new
export TransformPlugin


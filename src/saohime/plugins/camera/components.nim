{.push raises: [].}

import pkg/[ecslib, seiryu]
import ../../core/saohime_types
import ../transform/transform

type Camera* = ref object
  size*: Vector
  isActive*: bool

proc new*(T: type Camera, size: Vector, isActive: bool): T {.construct.}

proc centralSize*(camera: Camera): Vector =
  return camera.size / 2

proc CameraBundle*(
    entity: Entity, x: float = 0, y: float = 0, size: IntVector, isActive = false
): Entity {.discardable, raises: [KeyError].} =
  return entity.withBundle(
    (Transform.new(x = x, y = y), Camera.new(size.toVector(), isActive))
  )

{.push raises: [].}
import
  ../../core/saohime_types

type
  Camera* = ref object
    position*, size*, zoom*: Vector

proc new*(_: type Camera): Camera =
  return Camera(
    position: ZeroVector,
    size: ZeroVector,
    zoom: Vector.new(1f, 1f)
  )

proc centralSize*(camera: Camera): Vector =
  return camera.size / 2

proc centralPosition*(camera: Camera): Vector =
  return camera.position + camera.centralSize


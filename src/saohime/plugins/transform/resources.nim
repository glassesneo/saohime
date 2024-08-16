{.push raises: [].}
import
  ../../core/[saohime_types]

type
  GlobalScale* = ref object
    scale*: Vector

proc new*(_: type GlobalScale, x, y: float): GlobalScale =
  return GlobalScale(scale: Vector.new(x, y))

export new


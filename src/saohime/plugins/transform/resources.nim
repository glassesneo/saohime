{.push raises: [].}
import
  pkg/[seiryu],
  ../../core/[saohime_types]

type
  GlobalScale* = ref object
    scale*: Vector

proc new*(T: type GlobalScale, x, y: float): T {.construct.} =
  result.scale = Vector.new(x, y)

export new


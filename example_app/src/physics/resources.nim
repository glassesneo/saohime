type
  Gravity* = ref object
    g*: float

proc new*(_: type Gravity, g = 9.8): Gravity =
  return Gravity(g: g)

export new


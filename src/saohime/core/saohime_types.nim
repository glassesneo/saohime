{.push raises: [].}

import
  std/[colors, math]

type
  SaohimeColor* = tuple
    r, g, b, a: range[0..255]

  Vector* = ref object
    x*, y*: float

proc new*(
    _: type SaohimeColor,
    r, g, b: range[0..255],
    a: range[0..255] = 255
): SaohimeColor =
  return (r: r, g: g, b: b, a: a)

proc new*(
    _: type SaohimeColor,
    color: Color = colWhite,
    a: range[0..255] = 255
): SaohimeColor =
  let (r, g, b) = color.extractRGB()
  return (r: r, g: g, b: b, a: a)

proc toSaohimeColor*(
    color: Color
): SaohimeColor =
  result = SaohimeColor.new(color)

proc new*(_: type Vector; x, y: float): Vector =
  return Vector(x: x, y: y)

proc `+`*(a, b: Vector): Vector =
  return Vector.new(a.x + b.x, a.y + b.y)

proc `+=`*(a, b: Vector) =
  a.x += b.x
  a.y += b.y

template `-`*(vector: Vector): untyped =
  Vector.new(-vector.x, -vector.y)

proc `-`*(a, b: Vector): Vector =
  return a + (-b)

proc `*`*(a, b: Vector): float =
  return a.x * b.x + a.y * b.y

proc `*`*(vector: Vector; scalar: float): Vector =
  return Vector.new(vector.x * scalar, vector.y * scalar)

proc `/`*(vector: Vector; scalar: float): Vector =
  return Vector.new(vector.x / scalar, vector.y / scalar)

proc len*(vector: Vector): float =
  return sqrt(vector.x^2 + vector.y^2)

proc normalized*(vector: Vector): Vector =
  return vector / vector.len()

proc setLen*(vector: Vector; len: float): Vector =
  return vector.normalized() * len

proc heading*(vector: Vector): float =
  return arctan(vector.y / vector.x)

proc `$`*(vector: Vector): string =
  return "(" & $vector.x & ", " & $vector.y & ")"

export new


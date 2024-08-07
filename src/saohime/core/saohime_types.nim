{.push raises: [].}

import
  std/[colors, math],
  ./contract

type
  SaohimeColor* = ref object
    r, g, b, a: range[0..255]

  Vector* = ref object
    x*, y*: float

proc new*(
    _: type SaohimeColor,
    r, g, b: range[0..255],
    a: range[0..255] = 255
): SaohimeColor =
  return SaohimeColor(r: r, g: g, b: b, a: a)

proc new*(
    _: type SaohimeColor,
    color: Color = colWhite,
    a: range[0..255] = 255
): SaohimeColor =
  let (r, g, b) = color.extractRGB()
  return SaohimeColor(r: r, g: g, b: b, a: a)

proc toSaohimeColor*(
    color: Color
): SaohimeColor =
  result = SaohimeColor.new(color)

proc extractRGBA*(color: SaohimeColor): tuple[r, g, b, a: range[0..255]] =
  return (color.r, color.g, color.b, color.a)

proc r*(color: SaohimeColor): range[0..255] =
  return color.r

proc `r=`*(color: SaohimeColor, value: int) =
  color.r =
    if value < 0: 0
    else: value

proc g*(color: SaohimeColor): range[0..255] =
  return color.g

proc `g=`*(color: SaohimeColor, value: int) =
  color.g =
    if value < 0: 0
    else: value

proc b*(color: SaohimeColor): range[0..255] =
  return color.b

proc `b=`*(color: SaohimeColor, value: int) =
  color.b =
    if value < 0: 0
    else: value

proc a*(color: SaohimeColor): range[0..255] =
  return color.a

proc `a=`*(color: SaohimeColor, value: int) =
  color.a =
    if value < 0: 0
    else: value

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

proc `-=`*(a, b: Vector) =
  a += -b

proc `*`*(a, b: Vector): float =
  return a.x * b.x + a.y * b.y

proc `*`*(vector: Vector; scalar: float): Vector =
  return Vector.new(vector.x * scalar, vector.y * scalar)

proc `*=`*(vector: Vector; scalar: float) =
  vector.x = vector.x * scalar
  vector.y = vector.y * scalar

proc `/`*(vector: Vector; scalar: float): Vector =
  pre(scalar != 0)

  return Vector.new(vector.x / scalar, vector.y / scalar)

proc `/=`*(vector: Vector; scalar: float) =
  vector.x = vector.x / scalar
  vector.y = vector.y / scalar

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

proc `<`*(a, b: Vector): bool =
  return a.x < b.x and a.y < b.y

proc `<=`*(a, b: Vector): bool =
  return a.x <= b.x and a.y <= b.y

proc newWithPolarCoord*(
    _: type Vector;
    rad: float = 0f,
    len: float = 1f
): Vector =
  let slope = tan(rad)
  result = Vector.new(1f, slope)
  result.setLen(len)

export new


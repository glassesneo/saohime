{.push raises: [].}

import
  std/colors,
  std/math,
  pkg/[seiryu, seiryu/dbc]

type
  SaohimeColor* = object
    r, g, b, a: range[0..255]

  Vector* = object
    x*, y*: float

proc new*(
    T: type SaohimeColor,
    r, g, b: range[0..255],
    a: range[0..255] = 255
): T {.construct.}

proc new*(
    T: type SaohimeColor,
    color: Color = colWhite,
    a: range[0..255] = 255
): T =
  let (r, g, b) = color.extractRGB()
  return SaohimeColor(r: r, g: g, b: b, a: a)

proc toSaohimeColor*(
    color: Color
): SaohimeColor =
  result = SaohimeColor.new(color)

proc extractRGBA*(color: SaohimeColor): tuple[r, g, b, a: range[0..255]] =
  return (color.r, color.g, color.b, color.a)

proc r*(color: SaohimeColor): range[0..255] {.getter.}

proc `r=`*(color: var SaohimeColor, value: int) =
  color.r =
    if value < 0: 0
    elif value > 255: 255
    else: value

proc g*(color: SaohimeColor): range[0..255] {.getter.}

proc `g=`*(color: var SaohimeColor, value: int) =
  color.g =
    if value < 0: 0
    elif value > 255: 255
    else: value

proc b*(color: SaohimeColor): range[0..255] {.getter.}

proc `b=`*(color: var SaohimeColor, value: int) =
  color.b =
    if value < 0: 0
    elif value > 255: 255
    else: value

proc a*(color: SaohimeColor): range[0..255] {.getter.}

proc `a=`*(color: var SaohimeColor, value: int) =
  color.a =
    if value < 0: 0
    elif value > 255: 255
    else: value

proc new*(_: type Vector; x: float = 0, y: float = 0): Vector {.construct.}

proc toVector*(vector: (int, int)): Vector =
  return Vector.new(vector[0].float, vector[1].float)

proc toVector*(x, y: int): Vector =
  return Vector.new(x.float, y.float)

proc `+`*(a, b: Vector): Vector =
  return Vector.new(a.x + b.x, a.y + b.y)

proc `+=`*(a: var Vector, b: Vector) =
  a.x += b.x
  a.y += b.y

template `-`*(vector: Vector): untyped =
  Vector.new(-vector.x, -vector.y)

proc `-`*(a, b: Vector): Vector =
  return a + (-b)

proc `-=`*(a: var Vector, b: Vector) =
  a += -b

proc `*`*(a, b: Vector): float =
  return a.x * b.x + a.y * b.y

proc `*`*(vector: Vector; scalar: float): Vector =
  return Vector.new(vector.x * scalar, vector.y * scalar)

proc `*=`*(vector: var Vector; scalar: float) =
  vector.x = vector.x * scalar
  vector.y = vector.y * scalar

proc `/`*(vector: Vector; scalar: float): Vector =
  precondition:
    scalar != 0

  return Vector.new(vector.x / scalar, vector.y / scalar)

proc `/=`*(vector: var Vector; scalar: float) =
  vector.x = vector.x / scalar
  vector.y = vector.y / scalar

proc len*(vector: Vector): float =
  return sqrt(vector.x^2 + vector.y^2)

proc normalized*(vector: Vector): Vector =
  return vector / vector.len()

proc setLen*(vector: Vector; len: float): Vector =
  return vector.normalized() * len

proc heading*(vector: Vector): float =
  return arctan2(vector.y, vector.x)

proc `$`*(vector: Vector): string =
  return "(" & $vector.x & ", " & $vector.y & ")"

proc `==`*(a, b: Vector): bool =
  return a.x == b.x and a.y == b.y

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

proc map*(vector: Vector; op: proc(a: float): float): Vector =
  return Vector.new(op(vector.x), op(vector.y))

proc apply*(vector: var Vector; op: proc(a: var float)) =
  op(vector.x)
  op(vector.y)

proc map*(a, b: Vector; op: proc(x, y: float): float): Vector =
  return Vector.new(op(a.x, b.x), op(a.y, b.y))

const ZeroVector* = Vector.new(0, 0)

export new


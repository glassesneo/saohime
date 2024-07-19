{.push raises: [].}

import
  std/[colors]

type
  SaohimeColor* = tuple
    r, g, b, a: range[0..255]

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

export new


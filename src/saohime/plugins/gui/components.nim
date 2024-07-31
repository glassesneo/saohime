import
  ../../core/[saohime_types]

type
  Button* = ref object
    enabled*: bool
    pressed*: bool
    size*: Vector
    text*: string
    normalColor*: SaohimeColor
    pressedColor*: SaohimeColor
    currentColor*: SaohimeColor

proc new*(
    _: type Button,
    enabled = true,
    text: string,
    size: Vector,
    normalColor, pressedColor: SaohimeColor
): Button =
  return Button(
    enabled: enabled,
    pressed: false,
    text: text,
    size: size,
    normalColor: normalColor,
    pressedColor: pressedColor,
    currentColor: normalColor
  )

export new


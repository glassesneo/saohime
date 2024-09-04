import
  pkg/[seiryu],
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
    T: type Button,
    enabled = true,
    text: string,
    size: Vector,
    normalColor, pressedColor: SaohimeColor
): T {.construct.}

export new


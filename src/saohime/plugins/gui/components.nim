import
  ../../core/[saohime_types]

type
  Button* = ref object
    size*: Vector
    text*: string

proc new*(
    _: type Button,
    text: string,
    size: Vector
): Button =
  return Button(text: text, size: size)

export new


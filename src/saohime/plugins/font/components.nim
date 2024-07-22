{.push raises: [].}

import
  std/[colors],
  pkg/[sdl2/ttf],
  ../../core/[exceptions, saohime_types, sdl2_helpers]

type
  Font* = ref object
    font: FontPtr
    size: int

proc new*(_: type Font, font: FontPtr, size: int): Font =
  return Font(font: font, size: size)

proc size*(font: Font): int =
  return font.size

proc textBlended*(
    font: Font,
    text: string,
    fg: SaohimeColor = colWhite.toSaohimeColor(),
): Surface {.raises: [SDL2SurfaceError].} =
  return Surface.new(font.font.renderTextBlended(text, fg))

proc utf8Blended*(
    font: Font,
    text: string,
    fg: SaohimeColor = colWhite.toSaohimeColor(),
): Surface {.raises: [SDL2SurfaceError].} =
  return Surface.new(font.font.renderUtf8Blended(text, fg))


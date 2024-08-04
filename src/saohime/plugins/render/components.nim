{.push raises: [].}

import
  std/[colors],
  pkg/[sdl2/ttf],
  ../../core/[exceptions, saohime_types, sdl2_helpers]
import pkg/sdl2 except Surface

type
  Texture* = ref object
    texture*: TexturePtr

  Font* = ref object
    font: FontPtr

proc new*(_: type Texture, texture: TexturePtr): Texture =
  return Texture(texture: texture)

proc getSize*(texture: Texture): Vector {.raises: [SDL2TextureError].} =
  return texture.texture.getSize()

proc new*(_: type Font, font: FontPtr): Font =
  return Font(font: font)

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


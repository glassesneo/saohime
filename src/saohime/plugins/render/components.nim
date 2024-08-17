{.push raises: [].}

import
  std/[colors, lenientops],
  pkg/[sdl2/ttf],
  ../../core/[exceptions, saohime_types, sdl2_helpers],
  ../times/times
import pkg/sdl2 except Surface

type
  Texture* = ref object
    texture*: TexturePtr

  Sprite* = ref object
    texture*: TexturePtr
    currentIndex*, maxIndex: Natural
    columnLen: Natural
    srcPosition*, spriteSize*: Vector

  SpriteSheet* = ref object
    texture: TexturePtr
    columnLen: Natural
    sheetSize, spriteSize: Vector

  Font* = ref object
    font: FontPtr

proc new*(_: type Texture, texture: TexturePtr): Texture =
  return Texture(texture: texture)

proc getSize*(texture: Texture): Vector {.raises: [SDL2TextureError].} =
  return texture.texture.getSize()

proc new*(
    _: type Sprite,
    texture: TexturePtr,
    maxIndex, columnLen: Natural,
    srcPosition, spriteSize: Vector
): Sprite =
  return Sprite(
    texture: texture,
    currentIndex: 0,
    maxIndex: maxIndex,
    columnLen: columnLen,
    srcPosition: srcPosition,
    spriteSize: spriteSize
  )

proc spriteCentralSize*(sprite: Sprite): Vector =
  return sprite.spriteSize / 2

proc rotateIndex*(sprite: Sprite) =
  if sprite.currentIndex == sprite.maxIndex:
    sprite.currentIndex = 0
  else:
    sprite.currentIndex += 1

proc rotateIndex*(sprite: Sprite, interval: Interval) =
  if not interval.trigger:
    return

  sprite.rotateIndex()

proc currentSrc*(sprite: Sprite): tuple[position, size: Vector] =
  let (indexX, indexY) = if sprite.currentIndex == 0:
    (0, 0)
  else:
    (
      sprite.currentIndex mod sprite.columnLen,
      sprite.currentIndex div sprite.columnLen
    )

  let position = Vector.new(
    sprite.spriteSize.x * indexX,
    sprite.spriteSize.y * indexY
  )

  result = (position: sprite.srcPosition + position, size: sprite.spriteSize)

proc new*(
    _: type SpriteSheet,
    texture: TexturePtr,
    columnLen, rowLen: Natural
): SpriteSheet {.raises: [SDL2TextureError].} =
  let textureSize = texture.getSize()
  let
    spriteSizeX = textureSize.x / columnLen
    spriteSizeY = textureSize.y / rowLen

  result = SpriteSheet(
    texture: texture,
    columnLen: columnLen,
    sheetSize: textureSize,
    spriteSize: Vector.new(spriteSizeX, spriteSizeY),
  )

proc `[]`*(sheet: SpriteSheet, row: Natural): Sprite =
  let
    srcPosition = Vector.new(y = sheet.spriteSize.y * row)
  return Sprite.new(
    texture = sheet.texture,
    maxIndex = sheet.columnLen - 1,
    columnLen = sheet.columnLen,
    srcPosition = srcPosition,
    spriteSize = sheet.spriteSize
  )

proc `[]`*(sheet: SpriteSheet, row, maxIndexLen: Natural): Sprite =
  let
    srcPosition = Vector.new(y = sheet.spriteSize.y * row)
  return Sprite.new(
    texture = sheet.texture,
    maxIndex = maxIndexLen - 1,
    columnLen = sheet.columnLen,
    srcPosition = srcPosition,
    spriteSize = sheet.spriteSize
  )

proc `[]`*(sheet: SpriteSheet, rowSlice: HSlice): Sprite =
  let
    srcPosition = Vector.new(y = sheet.spriteSize.y * rowSlice.a)
  return Sprite.new(
    texture = sheet.texture,
    maxIndex = sheet.columnLen * rowSlice.len - 1,
    columnLen = sheet.columnLen,
    srcPosition = srcPosition,
    spriteSize = sheet.spriteSize
  )

proc `[]`*(sheet: SpriteSheet, rowSlice: HSlice, maxIndexLen: Natural): Sprite =
  let
    srcPosition = Vector.new(y = sheet.spriteSize.y * rowSlice.a)
  return Sprite.new(
    texture = sheet.texture,
    maxIndex = maxIndexLen - 1,
    columnLen = sheet.columnLen,
    srcPosition = srcPosition,
    spriteSize = sheet.spriteSize
  )

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


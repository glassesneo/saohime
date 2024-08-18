{.push raises: [].}

import
  std/[colors, lenientops],
  pkg/[ecslib, sdl2/ttf],
  ../../core/[exceptions, saohime_types, sdl2_helpers],
  ../times/times
import pkg/sdl2 except Surface

type
  Surface* = ref object
    surface*: SurfacePtr

  Texture* = ref object
    texture*: TexturePtr

  Font* = ref object
    font: FontPtr

  Image* = ref object
    srcPosition*, srcSize*: Vector

  Sprite* = ref object
    currentIndex*, maxIndex: Natural
    columnLen: Natural
    srcPosition*, spriteSize*: Vector

  SpriteSheet* = ref object
    columnLen: Natural
    sheetSize, spriteSize: Vector

  Text* = ref object
    size*: Vector

proc new*(_: type Surface, surface: SurfacePtr): Surface =
  return Surface(surface: surface)

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

proc new*(_: type Image, srcPosition = ZeroVector, srcSize: Vector): Image =
  return Image(srcPosition: srcPosition, srcSize: srcSize)

proc new*(
    _: type Sprite,
    maxIndex, columnLen: Natural,
    srcPosition, spriteSize: Vector
): Sprite =
  return Sprite(
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

proc currentSrcPosition*(sprite: Sprite): Vector =
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

  result = sprite.srcPosition + position

proc new*(
    _: type SpriteSheet,
    textureSize: Vector,
    columnLen, rowLen: Natural
): SpriteSheet =
  let
    spriteSizeX = textureSize.x / columnLen
    spriteSizeY = textureSize.y / rowLen

  result = SpriteSheet(
    columnLen: columnLen,
    sheetSize: textureSize,
    spriteSize: Vector.new(spriteSizeX, spriteSizeY),
  )

proc `[]`*(sheet: SpriteSheet, row: Natural): Sprite =
  let
    srcPosition = Vector.new(y = sheet.spriteSize.y * row)
  return Sprite.new(
    maxIndex = sheet.columnLen - 1,
    columnLen = sheet.columnLen,
    srcPosition = srcPosition,
    spriteSize = sheet.spriteSize
  )

proc `[]`*(sheet: SpriteSheet, row, maxIndexLen: Natural): Sprite =
  let
    srcPosition = Vector.new(y = sheet.spriteSize.y * row)
  return Sprite.new(
    maxIndex = maxIndexLen - 1,
    columnLen = sheet.columnLen,
    srcPosition = srcPosition,
    spriteSize = sheet.spriteSize
  )

proc `[]`*(sheet: SpriteSheet, rowSlice: HSlice): Sprite =
  let
    srcPosition = Vector.new(y = sheet.spriteSize.y * rowSlice.a)
  return Sprite.new(
    maxIndex = sheet.columnLen * rowSlice.len - 1,
    columnLen = sheet.columnLen,
    srcPosition = srcPosition,
    spriteSize = sheet.spriteSize
  )

proc `[]`*(sheet: SpriteSheet, rowSlice: HSlice, maxIndexLen: Natural): Sprite =
  let
    srcPosition = Vector.new(y = sheet.spriteSize.y * rowSlice.a)
  return Sprite.new(
    maxIndex = maxIndexLen - 1,
    columnLen = sheet.columnLen,
    srcPosition = srcPosition,
    spriteSize = sheet.spriteSize
  )

proc new*(_: type Text, size: Vector): Text =
  return Text(size: size)

proc ImageBundle*(
  entity: Entity,
  texture: Texture,
  srcPosition = ZeroVector
): Entity {.raises: [KeyError, SDL2TextureError].} =
  return entity.withBundle((
    texture,
    Image.new(srcPosition, texture.getSize())
  ))

proc ImageBundle*(
  entity: Entity,
  texture: Texture,
  srcPosition = ZeroVector,
  srcSize: Vector
): Entity {.raises: [KeyError].} =
  return entity.withBundle((
    texture,
    Image.new(srcPosition, srcSize)
  ))

proc SpriteBundle*(
  entity: Entity,
  texture: Texture,
  sprite: Sprite
): Entity {.raises: [KeyError].} =
  return entity.withBundle((
    texture,
    sprite
  ))

proc TextBundle*(
  entity: Entity,
  texture: Texture
): Entity {.raises: [KeyError, SDL2TextureError].} =
  return entity.withBundle((
    texture,
    Text.new(texture.getSize())
  ))

proc TextBundle*(
  entity: Entity,
  texture: Texture,
  size: Vector
): Entity {.raises: [KeyError].} =
  return entity.withBundle((
    texture,
    Text.new(size)
  ))


{.push raises: [].}

import
  std/[colors, lenientops],
  pkg/ecslib,
  pkg/[sdl2/ttf],
  pkg/[seiryu],
  ../../core/[exceptions, saohime_types, sdl2_helpers],
  ../times/times
import pkg/sdl2 except Surface

type
  Surface* = ref object
    surface*: SurfacePtr

  Texture* = ref object
    texture*: TexturePtr

  Renderable* = ref object
    srcPosition*, srcSize*: Vector
    renderingOrder*: int

  Font* = ref object
    font: FontPtr

  Image* = ref object

  Sprite* = ref object
    currentIndex*, maxIndex: Natural
    columnLen: Natural
    srcPosition*, srcSize*: Vector

  SpriteSheet* = ref object
    columnLen: Natural
    sheetSize, spriteSize: Vector

  TileMap* = ref object
    currentPosition*: tuple[x, y: Natural]
    srcPosition*, srcSize*: Vector

  TileMapSheet* = ref object
    sheetSize*, tileSize*: Vector

  Text* = ref object

proc new*(T: type Surface, surface: SurfacePtr): T {.construct.}

proc new*(T: type Texture, texture: TexturePtr): T {.construct.}

proc getSize*(texture: Texture): Vector {.raises: [SDL2TextureError].} =
  return texture.texture.getSize()

proc new*(
    T: type Renderable,
    srcPosition = ZeroVector,
    srcSize = ZeroVector,
    renderingOrder = 0
): T {.construct.}

proc new*(T: type Font, font: FontPtr): T {.construct.}

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

proc new*(T: type Image): T {.construct.}

proc new*(
    T: type Sprite,
    maxIndex, columnLen: Natural,
    srcPosition, srcSize: Vector
): T {.construct.} =
  result.currentIndex = 0
  result.maxIndex = maxIndex
  result.columnLen = columnLen
  result.srcPosition = srcPosition
  result.srcSize = srcSize

proc spriteCentralSize*(sprite: Sprite): Vector =
  return sprite.srcSize / 2

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
    sprite.srcSize.x * indexX,
    sprite.srcSize.y * indexY
  )

  result = sprite.srcPosition + position

proc new*(
    T: type SpriteSheet,
    textureSize: Vector,
    columnLen, rowLen: Natural
): T {.construct.} =
  let
    spriteSizeX = textureSize.x / columnLen
    spriteSizeY = textureSize.y / rowLen

  result.columnLen = columnLen
  result.sheetSize = textureSize
  result.spriteSize = Vector.new(spriteSizeX, spriteSizeY)

proc `[]`*(sheet: SpriteSheet, column: Natural): Sprite =
  let
    srcPosition = Vector.new(y = sheet.spriteSize.y * column)
  return Sprite.new(
    maxIndex = sheet.columnLen - 1,
    columnLen = sheet.columnLen,
    srcPosition = srcPosition,
    srcSize = sheet.spriteSize
  )

proc `[]`*(sheet: SpriteSheet, column, maxIndexLen: Natural): Sprite =
  let
    srcPosition = Vector.new(y = sheet.spriteSize.y * column)
  return Sprite.new(
    maxIndex = maxIndexLen - 1,
    columnLen = sheet.columnLen,
    srcPosition = srcPosition,
    srcSize = sheet.spriteSize
  )

proc `[]`*(sheet: SpriteSheet, columnSlice: HSlice): Sprite =
  let
    srcPosition = Vector.new(y = sheet.spriteSize.y * columnSlice.a)
  return Sprite.new(
    maxIndex = sheet.columnLen * columnSlice.len - 1,
    columnLen = sheet.columnLen,
    srcPosition = srcPosition,
    srcSize = sheet.spriteSize
  )

proc `[]`*(sheet: SpriteSheet, columnSlice: HSlice,
    maxIndexLen: Natural): Sprite =
  let
    srcPosition = Vector.new(y = sheet.spriteSize.y * columnSlice.a)
  return Sprite.new(
    maxIndex = maxIndexLen - 1,
    columnLen = sheet.columnLen,
    srcPosition = srcPosition,
    srcSize = sheet.spriteSize
  )

proc new*(
    T: type TileMap,
    currentRow, currentColumn: Natural,
    srcPosition, srcSize: Vector
): T {.construct.} =
  result.currentPosition = (currentRow, currentColumn)
  result.srcPosition = srcPosition
  result.srcSize = srcSize

proc new*(
    T: type TileMapSheet,
    textureSize: Vector,
    columnLen, rowLen: Natural
): T {.construct.} =
  let
    tileSizeX = textureSize.x / columnLen
    tileSizeY = textureSize.y / rowLen

  result.sheetSize = textureSize
  result.tileSize = Vector.new(tileSizeX, tileSizeY)

proc at*(sheet: TileMapSheet; row, column: Natural): TileMap =
  let srcPosition = Vector.new(
    x = sheet.tileSize.x * row,
    y = sheet.tileSize.y * column
  )

  return TileMap.new(row, column, srcPosition, sheet.tileSize)

proc new*(T: type Text): T {.construct.}

proc ImageBundle*(
    entity: Entity,
    texture: Texture,
    srcPosition = ZeroVector,
    renderingOrder = 0
): Entity {.discardable, raises: [KeyError, SDL2TextureError].} =
  return entity.withBundle((
    texture,
    Renderable.new(srcPosition, texture.getSize(), renderingOrder),
    Image.new()
  ))

proc ImageBundle*(
    entity: Entity,
    texture: Texture,
    srcPosition = ZeroVector,
    srcSize: Vector,
    renderingOrder = 0
): Entity {.discardable, raises: [KeyError].} =
  return entity.withBundle((
    texture,
    Renderable.new(srcPosition, srcSize, renderingOrder),
    Image.new()
  ))

proc SpriteBundle*(
    entity: Entity,
    texture: Texture,
    sprite: Sprite,
    renderingOrder = 0
): Entity {.discardable, raises: [KeyError].} =
  return entity.withBundle((
    texture,
    Renderable.new(sprite.currentSrcPosition(), sprite.srcSize, renderingOrder),
    sprite
  ))

proc TileMapBundle*(
    entity: Entity,
    texture: Texture,
    tileMap: TileMap,
    renderingOrder = 0
): Entity {.discardable, raises: [KeyError].} =
  return entity.withBundle((
    texture,
    Renderable.new(tileMap.srcPosition, tileMap.srcSize, renderingOrder),
    tileMap
  ))

proc TextBundle*(
  entity: Entity,
  texture: Texture,
    renderingOrder = 0
): Entity {.discardable, raises: [KeyError, SDL2TextureError].} =
  return entity.withBundle((
    texture,
    Renderable.new(ZeroVector, texture.getSize(), renderingOrder),
    Text.new()
  ))

proc TextBundle*(
  entity: Entity,
  texture: Texture,
  srcSize: Vector,
    renderingOrder = 0
): Entity {.discardable, raises: [KeyError].} =
  return entity.withBundle((
    texture,
    Renderable.new(ZeroVector, srcSize, renderingOrder),
    Text.new()
  ))


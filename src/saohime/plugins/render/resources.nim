{.push raises: [].}
import std/[colors, importutils, lenientops, math, os]
import pkg/sdl2 except
  clear, createRenderer, createTextureFromSurface, setDrawBlendMode, Surface
import pkg/[ecslib, sdl2/ttf, seiryu]
import ../../core/[exceptions, saohime_types, sdl2_helpers]
import ../asset/asset
import ./components

const defaultSizeTable =
  {Small: 12, MediumSmall: 16, Medium: 20, MediumLarge: 24, Large: 32, ExtraLarge: 48}

type
  RendererArgs* = ref object
    index*: int
    flags*: cint

  Renderer* = ref object
    renderer: RendererPtr
    windowBg*: SaohimeColor

proc new*(T: type RendererArgs, index: int, flags: cint): T {.construct.}

proc new*(T: type Renderer, renderer: RendererPtr): T {.construct.} =
  result.renderer = renderer
  result.windowBg = colBlack.toSaohimeColor()

proc destroy*(renderer: Renderer) =
  renderer.renderer.destroy()

proc setTarget*(renderer: Renderer, texture: Texture) {.raises: [SDL2RendererError].} =
  renderer.renderer.setTarget(texture.texture)

proc setTargetToDefault*(renderer: Renderer) {.raises: [SDL2RendererError].} =
  renderer.renderer.setTargetToDefault()

template withTarget*(renderer: Renderer, texture: Texture, body: untyped) =
  block:
    defer:
      renderer.setTargetToDefault()
    renderer.setTarget(texture)
    body

proc setViewport*(
    renderer: Renderer, position1, position2: Vector
) {.raises: [SDL2DrawError].} =
  renderer.renderer.setViewport(position1, position2)

proc setDrawBlendMode*(
    renderer: Renderer, blendMode: BlendMode
) {.raises: [SDL2DrawError].} =
  renderer.renderer.setDrawBlendMode(blendMode)

proc setColor*(renderer: Renderer, color: SaohimeColor) {.raises: [SDL2DrawError].} =
  renderer.renderer.setDrawColor(color)

proc setColor*(
    renderer: Renderer, color: colors.Color, a: range[0 .. 255] = 255
) {.raises: [SDL2DrawError].} =
  renderer.setColor(SaohimeColor.new(color, a))

proc setScale*(renderer: Renderer, scale: Vector) {.raises: [SDL2DrawError].} =
  renderer.renderer.setScale(scale)

proc clear*(renderer: Renderer) {.raises: [SDL2RendererError].} =
  renderer.renderer.clear()

proc drawPoint*(renderer: Renderer, position: Vector) {.raises: [SDL2DrawError].} =
  renderer.renderer.drawPoint(position)

proc drawLine*(
    renderer: Renderer, position1, position2: Vector
) {.raises: [SDL2DrawError].} =
  renderer.renderer.drawLine(position1, position2)

proc drawRectangle*(
    renderer: Renderer, position, size: Vector
) {.raises: [SDL2DrawError].} =
  renderer.renderer.drawRectangle(position, size)

proc fillRectangle*(
    renderer: Renderer, position, size: Vector
) {.raises: [SDL2DrawError].} =
  renderer.renderer.fillRectangle(position, size)

proc drawCircle*(
    renderer: Renderer, position: Vector, radius: float
) {.raises: [SDL2DrawError].} =
  for px in -radius.int .. radius.int:
    let py = sqrt(radius ^ 2 - px ^ 2)

    renderer.drawPoint(position + Vector.new(px.float, py))
    renderer.drawPoint(position + Vector.new(px.float, -py))

  for py in -radius.int .. radius.int:
    let px = sqrt(radius ^ 2 - py ^ 2)
    renderer.drawPoint(position - Vector.new(-px, py.float))
    renderer.drawPoint(position - Vector.new(px, py.float))

proc fillCircle*(
    renderer: Renderer, position: Vector, radius: float
) {.raises: [SDL2DrawError].} =
  for px in -radius.int .. radius.int:
    let py = sqrt(radius ^ 2 - px ^ 2)
    renderer.drawLine(
      position + Vector.new(px.float, py), position + Vector.new(px.float, -py)
    )

  for py in -radius.int .. radius.int:
    let px = sqrt(radius ^ 2 - py ^ 2)
    renderer.drawLine(
      position - Vector.new(-px, py.float), position - Vector.new(px, py.float)
    )

proc present*(renderer: Renderer) =
  renderer.renderer.present()

proc loadTexture*(
    renderer: Renderer, file: string
): Texture {.raises: [SDL2TextureError].} =
  let texture = renderer.renderer.loadTexture(file)
  return Texture.new(texture)

proc createTexture*(
    renderer: Renderer, format = SdlPixelFormatRGB332, access: cint, width, height: int
): Texture =
  let texture = renderer.renderer.createTexture(format, access, width, height)
  return Texture.new(texture)

proc createTextureFromSurface*(
    renderer: Renderer, surface: Surface
): Texture {.raises: [SDL2TextureError].} =
  let texture = renderer.renderer.createTextureFromSurface(surface.surface)
  return Texture.new(texture)

proc createTextTexture*(
    renderer: Renderer, text: string, font: Font, fontSize = Medium
): Texture {.raises: [SDL2TextureError, SDL2SurfaceError].} =
  let surface = font.textBlended(text, fontSize)
  result = renderer.createTextureFromSurface(surface)
  destroy surface.surface

proc createRectangleTexture*(
    renderer: Renderer, color: SaohimeColor, size: Vector
): Texture {.raises: [SDL2RendererError].} =
  result = renderer.createTexture(
    access = SDLTextureAccessTarget, width = size.x.int, height = size.y.int
  )
  renderer.withTarget(result):
    renderer.setColor(color)
    renderer.fillRectangle(ZeroVector, size)

proc copy*(
    renderer: Renderer,
    texture: Texture,
    src: tuple[position, size: Vector],
    dest: tuple[position, size: Vector],
    rotation: float = 0, # [rad]
    center: Vector,
    flip: RendererFlip = SdlFlipNone,
) {.raises: [SDL2TextureError].} =
  renderer.renderer.copyEx(texture.texture, src, dest, rotation, center, flip)

proc copy*(
    renderer: Renderer,
    texture: Texture,
    src: tuple[position, size: Vector],
    dest: tuple[position, size: Vector],
    rotation: float = 0, # [rad]
    flip: RendererFlip = SdlFlipNone,
) {.raises: [SDL2TextureError].} =
  renderer.renderer.copyEx(texture.texture, src, dest, rotation, src.position / 2, flip)

proc copyEntire*(
    renderer: Renderer,
    texture: Texture,
    dest: tuple[position, size: Vector],
    rotation: float = 0, # [rad]
    center: Vector,
    flip: RendererFlip = SdlFlipNone,
) {.raises: [SDL2TextureError].} =
  let src = (position: ZeroVector, size: texture.getSize())
  renderer.renderer.copyEx(texture.texture, src, dest, rotation, center, flip)

proc copyEntire*(
    renderer: Renderer,
    texture: Texture,
    dest: tuple[position, size: Vector],
    rotation: float = 0, # [rad]
    flip: RendererFlip = SdlFlipNone,
) {.raises: [SDL2TextureError].} =
  let src = (position: ZeroVector, size: texture.getSize())
  renderer.renderer.copyEx(texture.texture, src, dest, rotation, src.position / 2, flip)

proc load*(
    container: AssetContainer[Texture], renderer: Renderer, fileName: string
): Texture {.raises: [KeyError, SDL2TextureError].} =
  if fileName in container:
    return container[fileName]

  result = renderer.loadTexture(container.assetPath / fileName)
  container[fileName] = result

proc load*(
    container: AssetContainer[Font], fileName: string
): Font {.raises: [KeyError, SDL2FontError].} =
  if fileName in container:
    return container[fileName]

  var sizeTable: array[FontSize, FontPtr]
  for (key, size) in defaultSizeTable:
    sizeTable[key] = openFont(container.assetPath / fileName, size)

  result = Font.new(sizeTable)
  container[fileName] = result

proc RectangleBundle*(
    entity: Entity,
    color: SaohimeColor,
    size: Vector,
    srcPosition = ZeroVector,
    renderingOrder = 0,
): Entity {.discardable, raises: [KeyError, SDL2RendererError].} =
  privateAccess(Entity)
  let renderer = entity.world.getResource(Renderer)
  let texture = renderer.createTexture(
    access = SDLTextureAccessTarget, width = size.x.int, height = size.y.int
  )
  renderer.withTarget(texture):
    renderer.setColor(color)
    renderer.fillRectangle(ZeroVector, size)

  return entity.withBundle(
    (
      texture,
      Renderable.new(srcPosition, texture.getSize(), renderingOrder),
      Image.new(),
    )
  )

proc TextBundle*(
    entity: Entity, text: string, font: Font, fontSize = Medium, renderingOrder = 0
): Entity {.discardable, raises: [KeyError, SDL2RendererError].} =
  privateAccess(Entity)
  let renderer = entity.world.getResource(Renderer)
  let texture = renderer.createTextTexture(text, font, fontSize)

  return entity.withBundle(
    (texture, Renderable.new(ZeroVector, texture.getSize(), renderingOrder), Text.new())
  )

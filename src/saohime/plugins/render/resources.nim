{.push raises: [].}

import
  std/[colors, math],
  ../../core/[exceptions, saohime_types, sdl2_helpers],
  ./components
import pkg/sdl2 except setDrawBlendMode, createRenderer, clear

type
  Renderer* = ref object
    renderer: RendererPtr
    window: WindowPtr
    index*: int
    flags*: cint

proc new*(
    _: type Renderer,
    index: int = -1,
    flags: cint
): Renderer =
  return Renderer(
    index: index,
    flags: flags
  )

proc create*(
    renderer: Renderer,
    window: WindowPtr
) {.raises: [SDL2RendererError].} =
  renderer.renderer = createRenderer(
    window = window,
    index = renderer.index,
    flags = renderer.flags
  )

proc destroy*(renderer: Renderer) =
  renderer.renderer.destroy()

proc setDrawBlendMode*(
    renderer: Renderer;
    blendMode: BlendMode
) {.raises: [SDL2DrawError].} =
  renderer.renderer.setDrawBlendMode(blendMode)

proc setColor*(
    renderer: Renderer;
    color: SaohimeColor
) {.raises: [SDL2DrawError].} =
  renderer.renderer.setDrawColor(color)

proc setColor*(
    renderer: Renderer;
    color: colors.Color;
    a: range[0..255] = 255
) {.raises: [SDL2DrawError].} =
  renderer.setColor(SaohimeColor.new(color, a))

proc setScale*(
    renderer: Renderer;
    scale: Vector;
) {.raises: [SDL2DrawError].} =
  renderer.renderer.setScale(scale)

proc clear*(renderer: Renderer) {.raises: [SDL2RendererError].} =
  renderer.renderer.clear()

proc drawPoint*(
    renderer: Renderer;
    position: Vector;
) {.raises: [SDL2DrawError].} =
  renderer.renderer.drawPoint(position)

proc drawLine*(
    renderer: Renderer;
    position1, position2: Vector;
) {.raises: [SDL2DrawError].} =
  renderer.renderer.drawLine(position1, position2)

proc drawRectangle*(
    renderer: Renderer;
    position, size: Vector;
) {.raises: [SDL2DrawError].} =
  renderer.renderer.drawRectangle(position, size)

proc fillRectangle*(
    renderer: Renderer;
    position, size: Vector;
) {.raises: [SDL2DrawError].} =
  renderer.renderer.fillRectangle(position, size)

proc drawCircle*(
    renderer: Renderer;
    position: Vector;
    radius: float;
) {.raises: [SDL2DrawError].} =
  for px in -radius.int..radius.int:
    let py = sqrt(radius^2 - float(px^2))

    renderer.drawPoint(position + Vector.new(px.float, py.float))
    renderer.drawPoint(position + Vector.new(px.float, -py.float))

  for py in -radius.int..radius.int:
    let px = sqrt(radius^2 - float(py^2))
    renderer.drawPoint(position - Vector.new(-px.float, py.float))
    renderer.drawPoint(position - Vector.new(px.float, py.float))

proc fillCircle*(
    renderer: Renderer;
    position: Vector;
    radius: float;
) {.raises: [SDL2DrawError].} =
  for px in -radius.int..radius.int:
    let py = sqrt(radius^2 - float(px^2))
    renderer.drawLine(
      position + Vector.new(px.float, py.float),
      position + Vector.new(px.float, -py.float),
    )

  for py in -radius.int..radius.int:
    let px = sqrt(radius^2 - float(py^2))
    renderer.drawLine(
      position - Vector.new(-px.float, py.float),
      position - Vector.new(px.float, py.float),
    )

proc present*(renderer: Renderer) =
  renderer.renderer.present()

proc loadTexture*(
    renderer: Renderer,
    file: string
): Texture {.raises: [SDL2TextureError].} =
  let texture = renderer.renderer.loadTexture(file)
  return Texture.new(texture)

proc copy*(
    renderer: Renderer,
    texture: Texture,
    src: tuple[position, size: Vector],
    dest: tuple[position, size: Vector],
    rotation: float = 0, # [rad]
    center: Vector,
    flip: RendererFlip = SdlFlipNone
) {.raises: [SDL2TextureError].} =
  renderer.renderer.copyEx(
    texture.texture, src, dest, rotation, center, flip
    )

proc copy*(
    renderer: Renderer,
    texture: Texture,
    src: tuple[position, size: Vector],
    dest: tuple[position, size: Vector],
    rotation: float = 0, # [rad]
    flip: RendererFlip = SdlFlipNone
) {.raises: [SDL2TextureError].} =
  renderer.renderer.copyEx(
    texture.texture, src, dest, rotation, src.position / 2, flip
    )

proc copyEntire*(
    renderer: Renderer,
    texture: Texture,
    dest: tuple[position, size: Vector],
    rotation: float = 0, # [rad]
    center: Vector,
    flip: RendererFlip = SdlFlipNone
) {.raises: [SDL2TextureError].} =
  let src = (position: Vector.new(0, 0), size: texture.getSize())
  renderer.renderer.copyEx(
    texture.texture, src, dest, rotation, center, flip
  )

proc copyEntire*(
    renderer: Renderer,
    texture: Texture,
    dest: tuple[position, size: Vector],
    rotation: float = 0, # [rad]
    flip: RendererFlip = SdlFlipNone
) {.raises: [SDL2TextureError].} =
  let src = (position: Vector.new(0, 0), size: texture.getSize())
  renderer.renderer.copyEx(
    texture.texture, src, dest, rotation, src.position / 2, flip
  )


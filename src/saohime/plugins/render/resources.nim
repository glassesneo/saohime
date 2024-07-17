{.push raises: [].}

import
  std/[colors],
  ../../core/[exceptions, sdl2_helpers]
import pkg/sdl2 except createRenderer, clear

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

proc setColor*(
    renderer: Renderer;
    r, g, b: range[0..255];
    a: range[0..255] = 255
) {.raises: [SDL2RendererError].} =
  renderer.renderer.setDrawColor(r, g, b, a)

proc setColor*(
    renderer: Renderer;
    color: colors.Color;
    a: range[0..255] = 255
) {.raises: [SDL2RendererError].} =
  let (r, g, b) = color.extractRGB()
  renderer.setColor(r, g, b, a)

proc clear*(renderer: Renderer) {.raises: [SDL2RendererError].} =
  renderer.renderer.clear()

proc drawPoint*(
    renderer: Renderer;
    x, y: float;
) {.raises: [SDL2DrawError].} =
  renderer.renderer.drawPoint(x, y)

proc drawLine*(
    renderer: Renderer;
    x1, y1, x2, y2: float;
) {.raises: [SDL2DrawError].} =
  renderer.renderer.drawLine(x1, y1, x2, y2)

proc drawRectangle*(
    renderer: Renderer;
    x, y, width, height: float;
) {.raises: [SDL2DrawError].} =
  renderer.renderer.drawRectangle(x, y, width, height)

proc fillRectangle*(
    renderer: Renderer;
    x, y, width, height: float;
) {.raises: [SDL2DrawError].} =
  renderer.renderer.fillRectangle(x, y, width, height)

proc drawCircle*(
    renderer: Renderer;
    x, y, radius: float;
) {.raises: [SDL2DrawError].} =
  discard

proc present*(renderer: Renderer) =
  renderer.renderer.present()

proc loadTexture*(
    renderer: Renderer,
    file: string
): TexturePtr {.raises: [SDL2TextureError].} =
  return renderer.renderer.loadTexture(file)


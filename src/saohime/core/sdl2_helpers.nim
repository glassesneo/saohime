{.push raises: [].}

import
  pkg/[sdl2, sdl2/image],
  ./[contract, exceptions, saohime_types]

proc sdl2Init*(flags: cint) {.raises: [SDL2InitError].} =
  if sdl2.init(flags) == SdlError:
    let msg = "Failed to initialize SDL2: " & $sdl2.getError()
    raise (ref SDL2InitError)(msg: msg)

proc sdl2Quit* =
  sdl2.quit()

proc sdl2ImageInit*(flags: cint) {.raises: [SDL2InitError].} =
  if image.init(flags) != flags:
    let msg = "Failed to initialize SDL2 image: " & $sdl2.getError()
    raise (ref SDL2InitError)(msg: msg)

proc sdl2ImageQuit* = image.quit()

proc createWindow*(
    title: string;
    x = SdlWindowposCentered.int;
    y = SdlWindowposCentered.int;
    width, height: int;
    flags: uint32
): WindowPtr {.raises: [SDL2WindowError].} =
  result = sdl2.createWindow(
    title.cstring,
    x.cint, y.cint,
    width.cint, height.cint,
    flags
  )

  if result == nil:
    let msg = "Failed to create a window: " & $sdl2.getError()
    raise (ref SDL2WindowError)(msg: msg)

proc createRenderer*(
    window: WindowPtr;
    index: int = -1;
    flags: cint
): RendererPtr {.raises: [SDL2RendererError].} =
  pre(window != nil)

  result = sdl2.createRenderer(
    window,
    index.cint,
    flags
  )

  if result == nil:
    let msg = "Failed to create a renderer: " & $sdl2.getError()
    raise (ref SDL2RendererError)(msg: msg)

proc setDrawBlendMode*(
    renderer: RendererPtr;
    blendMode: BlendMode
) {.raises: [SDL2DrawError].} =
  pre(renderer != nil)

  if sdl2.setDrawBlendMode(renderer, blendMode) == SdlError:
    let msg = "Failed to set blend mode for drawing: " & $sdl2.getError()
    raise (ref SDL2DrawError)(msg: msg)

proc setDrawColor*(
    renderer: RendererPtr;
    color: SaohimeColor
) {.raises: [SDL2DrawError].} =
  pre(renderer != nil)

  let (r, g, b, a) = color
  if sdl2.setDrawColor(renderer, r.uint8, g.uint8, b.uint8, a.uint8) == SdlError:
    let msg = "Failed to set draw color: " & $sdl2.getError()
    raise (ref SDL2DrawError)(msg: msg)

proc setScale*(
    renderer: RendererPtr;
    x, y: float;
) {.raises: [SDL2DrawError].} =
  pre(renderer != nil)

  if sdl2.setScale(renderer, x.cfloat, y.cfloat) == SdlError:
    let msg = "Failed to set scale: " & $sdl2.getError()
    raise (ref SDL2DrawError)(msg: msg)

proc clear*(renderer: RendererPtr) {.raises: [SDL2DrawError].} =
  pre(renderer != nil)

  if sdl2.clear(renderer) == SdlError:
    let msg = "Failed to clear: " & $sdl2.getError()
    raise (ref SDL2DrawError)(msg: msg)

proc drawPoint*(
    renderer: RendererPtr;
    x, y: float;
) {.raises: [SDL2DrawError].} =
  pre(renderer != nil)

  if renderer.drawPointF(x, y) == SdlError:
    let msg = "Failed to draw point: " & $sdl2.getError()
    raise (ref SDL2DrawError)(msg: msg)

proc drawLine*(
    renderer: RendererPtr;
    x1, y1, x2, y2: float;
) {.raises: [SDL2DrawError].} =
  pre(renderer != nil)

  if renderer.drawLineF(x1, y1, x2, y2) == SdlError:
    let msg = "Failed to draw point: " & $sdl2.getError()
    raise (ref SDL2DrawError)(msg: msg)

proc drawRectangle*(
    renderer: RendererPtr;
    x, y, width, height: float;
) {.raises: [SDL2DrawError].} =
  pre(renderer != nil)

  var rect = rectf(x, y, width, height)
  if renderer.drawRectF(rect) == SdlError:
    let msg = "Failed to draw rectangle: " & $sdl2.getError()
    raise (ref SDL2DrawError)(msg: msg)

proc fillRectangle*(
    renderer: RendererPtr;
    x, y, width, height: float;
) {.raises: [SDL2DrawError].} =
  pre(renderer != nil)

  var rect = rectf(x, y, width, height)
  if renderer.fillRectF(rect) == SdlError:
    let msg = "Failed to fill rectangle: " & $sdl2.getError()
    raise (ref SDL2DrawError)(msg: msg)

proc loadTexture*(
    renderer: RendererPtr;
    file: string
): TexturePtr {.raises: [SDL2TextureError].} =
  pre(renderer != nil)

  result = loadTexture(
    renderer,
    file.cstring
  )

  if result == nil:
    let msg = "Failed to create texture: " & $sdl2.getError()
    raise (ref SDL2TextureError)(msg: msg)


{.push raises: [].}

import
  std/[math],
  pkg/[sdl2/image, sdl2/ttf],
  ./[contract, exceptions, saohime_types]
import pkg/sdl2 except Surface

type
  Surface* = ref object
    surface*: SurfacePtr

proc new*(_: type Surface, surface: SurfacePtr): Surface =
  return Surface(surface: surface)

proc createRect(position, size: Vector): Rect =
  return rect(
    position.x.cint,
    position.y.cint,
    size.x.cint,
    size.y.cint
  )

proc createRectF(position, size: Vector): RectF =
  return rectf(
    position.x,
    position.y,
    size.x,
    size.y
  )

proc createPointF*(vector: Vector): PointF =
  return PointF(x: vector.x.cfloat, y: vector.y.cfloat)

proc toSDL2Color*(color: SaohimeColor): Color =
  return (color.r.uint8, color.g.uint8, color.b.uint8, color.a.uint8)

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

proc sdl2ImageQuit* =
  image.quit()

proc sdl2TtfInit* {.raises: [SDL2InitError].} =
  if ttf.ttfInit() == SdlError:
    let msg = "Failed to initialize SDL2 ttf: " & $sdl2.getError()
    raise (ref SDL2InitError)(msg: msg)

proc sdl2TtfQuit* =
  ttf.ttfQuit()

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
    index: int;
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
    scale: Vector;
) {.raises: [SDL2DrawError].} =
  pre(renderer != nil)

  if sdl2.setScale(renderer, scale.x.cfloat, scale.y.cfloat) == SdlError:
    let msg = "Failed to set scale: " & $sdl2.getError()
    raise (ref SDL2DrawError)(msg: msg)

proc clear*(renderer: RendererPtr) {.raises: [SDL2DrawError].} =
  pre(renderer != nil)

  if sdl2.clear(renderer) == SdlError:
    let msg = "Failed to clear: " & $sdl2.getError()
    raise (ref SDL2DrawError)(msg: msg)

proc drawPoint*(
    renderer: RendererPtr;
    position: Vector;
) {.raises: [SDL2DrawError].} =
  pre(renderer != nil)

  if renderer.drawPointF(position.x, position.y) == SdlError:
    let msg = "Failed to draw point: " & $sdl2.getError()
    raise (ref SDL2DrawError)(msg: msg)

proc drawLine*(
    renderer: RendererPtr;
    position1, position2: Vector;
) {.raises: [SDL2DrawError].} =
  pre(renderer != nil)

  if renderer.drawLineF(
    position1.x, position1.y,
    position2.x, position2.y,
  ) == SdlError:
    let msg = "Failed to draw point: " & $sdl2.getError()
    raise (ref SDL2DrawError)(msg: msg)

proc drawRectangle*(
    renderer: RendererPtr;
    position, size: Vector;
) {.raises: [SDL2DrawError].} =
  pre(renderer != nil)

  var rect = createRectF(position, size)
  if renderer.drawRectF(rect) == SdlError:
    let msg = "Failed to draw rectangle: " & $sdl2.getError()
    raise (ref SDL2DrawError)(msg: msg)

proc fillRectangle*(
    renderer: RendererPtr;
    position, size: Vector;
) {.raises: [SDL2DrawError].} =
  pre(renderer != nil)

  var rect = createRectF(position, size)
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

proc createTextureFromSurface*(
    renderer: RendererPtr;
    surface: SurfacePtr;
): TexturePtr {.raises: [SDL2TextureError].} =
  pre(renderer != nil)

  result = sdl2.createTextureFromSurface(renderer, surface)

  if result == nil:
    let msg = "Failed to create texture from surface: " & $sdl2.getError()
    raise (ref SDL2TextureError)(msg: msg)

proc getSize*(texture: TexturePtr): Vector {.raises: [SDL2TextureError].} =
  var w, h: cint
  if sdl2.queryTexture(texture, nil, nil, addr w, addr h) == SdlError:
    let msg = "Failed to get texture size: " & $sdl2.getError()
    raise (ref SDL2TextureError)(msg: msg)

  return Vector.new(w.float, h.float)

proc copy*(
    renderer: RendererPtr;
    texture: TexturePtr;
    source: tuple[position, size: Vector];
    destination: tuple[position, size: Vector];
) {.raises: [SDL2TextureError].} =
  pre(renderer != nil)

  var
    sourceRect = createRect(
      source.position,
      source.size
    )
    destinationRect = createRectF(
      destination.position,
      destination.size
    )

  if sdl2.copyf(renderer, texture, addr sourceRect, addr destinationRect) == SdlError:
    let msg = "Failed to copy texture: " & $sdl2.getError()
    raise (ref SDL2TextureError)(msg: msg)

proc copyEx*(
    renderer: RendererPtr;
    texture: TexturePtr;
    source: tuple[position, size: Vector];
    destination: tuple[position, size: Vector];
    angle: float; # [rad]
    center: Vector;
    flip: RendererFlip;
) {.raises: [SDL2TextureError].} =
  pre(renderer != nil)

  var
    sourceRect = createRect(
      source.position,
      source.size
    )
    destinationRect = createRectF(
      destination.position,
      destination.size
    )
    centerPoint = createPointF(center)

  if sdl2.copyExF(
    renderer,
    texture,
    addr sourceRect,
    addr destinationRect,
    angle.radToDeg(),
    addr centerPoint,
    flip
  ) == SdlError:
    let msg = "Failed to copy texture: " & $sdl2.getError()
    raise (ref SDL2TextureError)(msg: msg)

proc openFont*(
    file: string;
    fontSize: int
): FontPtr {.raises: [SDL2FontError].} =
  result = ttf.openFont(file.cstring, fontSize.cint)

  if result == nil:
    let msg = "Failed to open font: " & $sdl2.getError()
    raise (ref SDL2FontError)(msg: msg)

proc renderTextBlended*(
    font: FontPtr;
    text: string;
    fg: SaohimeColor;
): SurfacePtr {.raises: [SDL2SurfaceError].} =
  result = ttf.renderTextBlended(font, text.cstring, fg.toSDL2Color)

  if result == nil:
    let msg = "Failed to create surface: " & $sdl2.getError()
    raise (ref SDL2SurfaceError)(msg: msg)

proc renderUtf8Blended*(
    font: FontPtr;
    text: string;
    fg: SaohimeColor;
): SurfacePtr {.raises: [SDL2SurfaceError].} =
  result = ttf.renderUtf8Blended(font, text.cstring, fg.toSDL2Color)

  if result == nil:
    let msg = "Failed to create surface: " & $sdl2.getError()
    raise (ref SDL2SurfaceError)(msg: msg)


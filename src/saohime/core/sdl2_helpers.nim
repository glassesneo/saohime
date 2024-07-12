{.push raises: [].}

import
  pkg/[sdl2, sdl2/image],
  ./[contract, exceptions]

proc sdl2Init*(flags: cint) {.raises: [SDL2InitError].} =
  if sdl2.init(flags) == SdlError:
    let msg = "Failed to initialize SDL2: " & $sdl2.getError()
    raise (ref SDL2InitError)(msg: msg)

proc sdl2Quit* = sdl2.quit()

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


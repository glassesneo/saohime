{.push raises: [].}

import
  pkg/[sdl2, sdl2/image],
  ./[contract, plugin, exceptions]

proc sdl2Init*(flags: cint) {.raises: [SDL2InitError].} =
  post: exitCode == SdlSuccess
  do:
    let msg = "Failed to initialize SDL2" & $sdl2.getError()
    raise (ref SDL2InitError)(msg: msg)

  exitCode = sdl2.init(flags)

proc sdl2Quit* = sdl2.quit()

proc sdl2ImageInit*(flags: cint) {.raises: [SDL2InitError].} =
  var returnedFlags: cint
  post: returnedFlags == flags
  do:
    let msg = "Failed to initialize SDL2" & $sdl2.getError()
    raise (ref SDL2InitError)(msg: msg)

  returnedFlags = image.init(flags)

proc sdl2ImageQuit* = image.quit()

proc createWindow*(
    title: string;
    x = SdlWindowposCentered.int;
    y = SdlWindowposCentered.int;
    width, height: int;
    flags: uint32
): WindowPtr {.raises: [SDL2WindowError].} =
  post: result != nil
  do:
    let msg = "Failed to create window" & $sdl2.getError()
    raise (ref SDL2WindowError)(msg: msg)

  result = sdl2.createWindow(
    title.cstring,
    x.cint, y.cint,
    width.cint, height.cint,
    flags
  )

proc createRenderer*(
    window: WindowPtr;
    index: int = -1;
    flags: cint
): RendererPtr {.raises: [SDL2RendererError].} =
  post: result != nil
  do:
    let msg = "Failed to create renderer" & $sdl2.getError()
    raise (ref SDL2RendererError)(msg: msg)

  result = sdl2.createRenderer(
    window,
    index.cint,
    flags
  )

proc loadTexture*(
    renderer: RendererPtr;
    file: string
): TexturePtr {.raises: [SDL2TextureError].} =
  post: result != nil
  do:
    let msg = "Failed to create texture" & $sdl2.getError()
    raise (ref SDL2TextureError)(msg: msg)

  result = loadTexture(
    renderer,
    file.cstring
  )


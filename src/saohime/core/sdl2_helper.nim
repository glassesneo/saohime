{.push raises: [].}

import
  pkg/[sdl2],
  ./[contract, plugin, exceptions]

proc sdl2Init*(flags: cint) {.raises: [SDL2InitError].} =
  post: exitCode == SdlSuccess
  do:
    let msg = "Failed to initialize SDL2" & $sdl2.getError()
    raise (ref SDL2InitError)(msg: msg)

  exitCode = sdl2.init(flags)

proc sdl2Quit* = sdl2.quit()

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


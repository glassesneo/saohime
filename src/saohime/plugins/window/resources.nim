{.push raises: [].}

import
  pkg/[sdl2],
  ../../core/[exceptions, contract, sdl2_helpers]

type Window* = ref object
  window: WindowPtr

proc new*(
    _: type Window,
    title: string;
    x = SdlWindowposCentered.int;
    y = SdlWindowposCentered.int;
    width, height: int;
    flags: uint32
): Window {.raises: [SDL2WindowError].} =
  pre(window != nil)

  let window = createWindow(
    title = title,
    x = x,
    y = y,
    width = width,
    height = height,
    flags = flags
  )

  return Window(window: window)

proc size*(self: Window): tuple[width, height: cint] =
  sdl2.getSize(self.window, result.width, result.height)

proc setSize*(self: Window, width, height: cint) =
  sdl2.setSize(self.window, width, height)

proc destroy*(self: Window) =
  self.window.destroy()

export new


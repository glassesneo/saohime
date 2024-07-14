{.push raises: [].}

import
  ../../core/[exceptions, contract, sdl2_helpers]
import pkg/sdl2 except createWindow

type Window* = ref object
  window: WindowPtr
  initialArgs: tuple[title: string, x, y, width, height: int, flags: uint32]

proc new*(
    _: type Window,
    title: string;
    x = SdlWindowposCentered.int;
    y = SdlWindowposCentered.int;
    width, height: int;
    flags: uint32
): Window =
  return Window(
    initialArgs: (
      title: title,
      x: x,
      y: y,
      width: width,
      height: height,
      flags: flags
    )
  )

proc create*(self: Window) {.raises: [SDL2WindowError].} =
  self.window = createWindow(
    title = self.initialArgs.title,
    x = self.initialArgs.x,
    y = self.initialArgs.y,
    width = self.initialArgs.width,
    height = self.initialArgs.height,
    flags = self.initialArgs.flags
  )

proc size*(self: Window): tuple[width, height: cint] =
  sdl2.getSize(self.window, result.width, result.height)

proc setSize*(self: Window, width, height: cint) =
  sdl2.setSize(self.window, width, height)

proc destroy*(self: Window) =
  self.window.destroy()

export new


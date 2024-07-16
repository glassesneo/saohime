{.push raises: [].}

import
  ../../core/[exceptions, sdl2_helpers]
import pkg/sdl2 except createWindow

type
  Window* = ref object
    window: WindowPtr
    title*: string
    x*, y*: int
    width*, height*: int
    flags*: uint32

proc new*(
    _: type Window,
    title: string;
    x = SdlWindowposCentered.int;
    y = SdlWindowposCentered.int;
    width, height: int;
    flags: uint32
): Window =
  return Window(
    title: title,
    x: x,
    y: y,
    width: width,
    height: height,
    flags: flags
  )

proc create*(window: Window) {.raises: [SDL2WindowError].} =
  window.window = createWindow(
    title = window.title,
    x = window.x,
    y = window.y,
    width = window.width,
    height = window.height,
    flags = window.flags
  )

proc size*(window: Window): tuple[width, height: cint] =
  sdl2.getSize(window.window, result.width, result.height)

proc setSize*(window: Window, width, height: cint) =
  sdl2.setSize(window.window, width, height)

proc destroy*(window: Window) =
  window.window.destroy()

export new


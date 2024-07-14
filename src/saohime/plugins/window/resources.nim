{.push raises: [].}

import
  ../../core/[exceptions, sdl2_helpers]
import pkg/sdl2 except createWindow

type
  Window* = ref object
    window: WindowPtr
    initialArgs: tuple[title: string, x, y, width, height: int, flags: uint32]

  WindowSettings* = ref object
    title*: string
    x*, y*: int
    width*, height*: int
    flags*: uint32

proc new*(_: type Window): Window =
  return Window()

proc new*(
    _: type WindowSettings,
    title: string;
    x = SdlWindowposCentered.int;
    y = SdlWindowposCentered.int;
    width, height: int;
    flags: uint32
): WindowSettings =
  return WindowSettings(
    title: title,
    x: x,
    y: y,
    width: width,
    height: height,
    flags: flags
  )

proc create*(
    window: Window,
    title: string;
    x = SdlWindowposCentered.int;
    y = SdlWindowposCentered.int;
    width, height: int;
    flags: uint32
) {.raises: [SDL2WindowError].} =
  window.window = createWindow(
    title = title,
    x = x,
    y = y,
    width = width,
    height = height,
    flags = flags
  )

proc size*(window: Window): tuple[width, height: cint] =
  sdl2.getSize(window.window, result.width, result.height)

proc setSize*(window: Window, width, height: cint) =
  sdl2.setSize(window.window, width, height)

proc destroy*(window: Window) =
  window.window.destroy()

export new


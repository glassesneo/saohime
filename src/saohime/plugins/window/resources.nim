{.push raises: [].}
import pkg/[sdl2, seiryu]
import ../../core/saohime_types

type
  WindowArgs* = ref object
    title*: string
    position*, size*: IntVector
    flags*: uint32

  Window* = ref object
    window: WindowPtr

proc new*(
  T: type WindowArgs, title: string, position, size: IntVector, flags: uint32
): T {.construct.}

proc new*(T: type Window, window: sdl2.WindowPtr): T {.construct.}

proc destroy*(window: Window) =
  window.window.destroy()

proc setIcon*(window: Window, icon: SurfacePtr) =
  sdl2.setIcon(window.window, icon)

proc getTitle*(window: Window): string =
  return cast[string](window.window.getTitle())

proc setTitle*(window: Window, title: string) =
  window.window.setTitle(title)

proc getPosition*(window: Window): IntVector =
  var x, y: cint
  window.window.getPosition(x, y)
  return (x.int, y.int)

proc setPosition*(window: Window, x = 0, y = 0) =
  window.window.setPosition(x.cint, y.cint)

proc setPosition*(window: Window, position: IntVector = (0, 0)) =
  window.setPosition(position.x, position.y)

proc getSize*(window: Window): IntVector =
  var w, h: cint
  window.window.getSize(w, h)
  return (w.int, h.int)

proc setSize*(window: Window, w = 0, h = 0) =
  window.window.setPosition(w.cint, h.cint)

proc setSize*(window: Window, size: IntVector = (0, 0)) =
  window.setPosition(size.x, size.y)

export new

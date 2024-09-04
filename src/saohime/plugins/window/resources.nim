{.push raises: [].}
import
  pkg/[seiryu],
  ../../core/[exceptions, saohime_types, sdl2_helpers]
import pkg/sdl2 except createWindow

type
  Window* = ref object
    initialized: bool
    window: WindowPtr
    title: string
    x, y: int
    width, height: int
    flags*: uint32

proc new*(
    T: type Window,
    title: string;
    x = SdlWindowposCentered.int;
    y = SdlWindowposCentered.int;
    width, height: int;
    flags: uint32
): T {.construct.}

proc create*(window: Window) {.raises: [SDL2WindowError].} =
  window.window = createWindow(
    title = window.title,
    x = window.x,
    y = window.y,
    width = window.width,
    height = window.height,
    flags = window.flags
  )
  window.initialized = true

proc destroy*(window: Window) =
  window.window.destroy()

proc setIcon*(window: Window, icon: SurfacePtr) =
  sdl2.setIcon(window.window, icon)

proc title*(window: Window): string =
  return window.title

proc `title=`*(window: Window, title: string) =
  if window.initialized:
    sdl2.setTitle(window.window, title)
  else:
    window.title = title

proc position*(window: Window): tuple[x, y: int] =
  var x, y: cint
  sdl2.getPosition(window.window, x, y)
  return (x: x.int, y: y.int)

proc `position=`*(window: Window, position: tuple[x, y: int]) =
  if window.initialized:
    sdl2.setPosition(window.window, position.x.cint, position.y.cint)
  else:
    window.x = position.x
    window.y = position.y

proc size*(window: Window): tuple[w, h: int] =
  var w, h: cint
  sdl2.getSize(window.window, w, h)
  return (w: w.int, h: h.int)

proc `size=`*(window: Window, size: tuple[w, h: int]) =
  if window.initialized:
    sdl2.setSize(window.window, size.w.cint, size.h.cint)
  else:
    window.width = size.w
    window.height = size.h

export new


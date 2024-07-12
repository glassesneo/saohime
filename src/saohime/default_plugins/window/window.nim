{.push raises: [].}

import
  pkg/[ecslib, oolib, sdl2],
  ../../core/contract

type Window* = ref object
  window: WindowPtr

proc new*(_: type Window, window: WindowPtr): Window =
  pre(window != nil)

  return Window(window: window)

proc size*(self: Window): tuple[width, height: cint] =
  sdl2.getSize(self.window, result.width, result.height)

proc setSize*(self: Window, width, height: cint) =
  sdl2.setSize(self.window, width, height)

proc destroy*(self: Window) =
  self.window.destroy()

class pub WindowPlugin:
  var window: WindowPtr

  proc build*(world: World) =
    world.addResource(Window.new(self.window))

export new
export WindowPlugin


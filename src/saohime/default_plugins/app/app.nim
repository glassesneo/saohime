{.push raises: [].}

import
  pkg/[ecslib, oolib, sdl2],
  ../../core/[sdl2_helpers]

class pub AppState:
  var mainLoopFlag {.initial.} = false

  proc mainLoopFlag*: bool = self.mainLoopFlag

  proc activateMainLoop* =
    self.mainLoopFlag = true

  proc deactivateMainLoop* =
    self.mainLoopFlag = false

class pub WindowControl:
  var window: WindowPtr

  proc getSize*: tuple[width, height: cint] =
    sdl2.getSize(self.window, result.width, result.height)

  proc setSize*(width, height: cint) =
    sdl2.setSize(self.window, width, height)

  proc destroy* =
    self.window.destroy()

class pub AppPlugin:
  var window: WindowPtr

  proc build*(world: World) =
    world.addResource(AppState.new())
    world.addResource(WindowControl.new(self.window))

export AppPlugin

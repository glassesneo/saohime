{.push raises: [].}

import
  pkg/[ecslib, oolib, sdl2]

class pub AppState:
  var mainLoopFlag {.initial.} = false

  proc mainLoopFlag*: bool = self.mainLoopFlag

  proc activateMainLoop* =
    self.mainLoopFlag = true

  proc deactivateMainLoop* =
    self.mainLoopFlag = false

class pub AppPlugin:
  proc build*(world: World) =
    world.addResource(AppState.new())

export new
export AppPlugin


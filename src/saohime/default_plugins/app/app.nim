{.push raises: [].}

import
  pkg/[ecslib, oolib]

class pub AppState:
  var mainLoopFlag {.initial.} = false

  proc mainLoopFlag*: bool = self.mainLoopFlag

  proc activateMainLoop* =
    self.mainLoopFlag = true

  proc deactivateMainLoop* =
    self.mainLoopFlag = false

class pub AppPlugin:
  var name* {.initial.} = "AppPlugin"

  proc build*(world: World) =
    world.addResource(AppState.new())

export new
export AppPlugin


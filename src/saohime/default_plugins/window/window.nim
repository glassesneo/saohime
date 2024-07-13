{.push raises: [].}

import
  pkg/[ecslib, oolib],
  ./resources,
  ./systems
from pkg/sdl2 import WindowPtr

class pub WindowPlugin:
  var window: WindowPtr
  var name* {.initial.} = "WindowPlugin"

  proc build*(world: World) =
    world.addResource(Window.new(self.window))
    world.registerTerminateSystems(destroyWindow)

export
  resources,
  systems


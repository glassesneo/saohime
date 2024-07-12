{.push raises: [].}

import
  pkg/[ecslib, oolib, sdl2]

class pub EventListener:
  var event: Event

  proc pollEvent*: bool =
    return sdl2.pollEvent(self.event)

  proc checkQuitEvent*: bool =
    self.event.kind == QuitEvent

class pub EventPlugin:
  proc build*(world: World) =
    world.addResource(EventListener.new(defaultEvent))

export new
export EventPlugin


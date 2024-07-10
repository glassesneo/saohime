import
  pkg/[ecslib, oolib, sdl2]

class pub EventListener:
  var event*: Event

  proc getEvent* =
    discard sdl2.pollEvent(self.event)

  proc checkQuitEvent*: bool = self.event.kind == QuitEvent

proc pollEvent* {.system.} =
  let listener = command.getResource(EventListener)
  listener.getEvent()

class pub EventPlugin:
  proc build*(world: World) =
    world.registerSystems(pollEvent)
    world.addResource(EventListener.new(defaultEvent))


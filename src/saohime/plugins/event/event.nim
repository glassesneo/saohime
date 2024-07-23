import
  pkg/[ecslib, oolib, sdl2],
  ../../core/[contract],
  ./resources

class pub EventPlugin:
  var name* {.initial.} = "EventPlugin"
  proc build*(world: World) =
    world.addResource(EventListener.new(defaultEvent))

export new
export
  resources


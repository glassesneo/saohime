import
  pkg/[ecslib, oolib, sdl2],
  ./events,
  ./resources,
  ./systems

type
  EventPlugin* = ref object
    name*: string

proc new*(_: type EventPlugin): EventPlugin =
  return EventPlugin(name: "EventPlugin")

proc build*(plugin: EventPlugin, world: World) =
  world.addResource(EventListener.new(defaultEvent))
  world.addEvent(ApplicationEvent)
  world.addEvent(KeyboardEvent)
  world.addEvent(MouseEvent)
  world.registerSystems(dispatchSDL2Events)

export new
export
  events,
  resources,
  systems


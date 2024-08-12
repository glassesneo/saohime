import
  pkg/[ecslib, sdl2],
  ./events,
  ./resources,
  ./systems

type
  EventPlugin* = ref object

proc build*(plugin: EventPlugin, world: World) =
  world.addResource(EventListener.new())
  world.addResource(MouseInput.new())
  world.addEvent(ApplicationEvent)
  world.addEvent(KeyboardEvent)
  world.addEvent(MouseEvent)
  world.registerSystems(dispatchSDL2Events)
  # world.registerSystems(clearAllQueue)

export
  events,
  resources,
  systems


import
  pkg/[ecslib, sdl2],
  ./events,
  ./resources,
  ./systems

type
  EventPlugin* = ref object

proc build*(plugin: EventPlugin, world: World) =
  world.addResource(EventListener.new())
  world.addResource(KeyboardInput.new())
  world.addResource(MouseInput.new())
  world.addEvent(ApplicationEvent)
  world.addEvent(KeyboardEvent)
  world.addEvent(MouseButtonEvent)
  world.registerSystemsAt("first", readSDL2Events)
  world.registerSystemsAt("first",
    dispatchKeyboardEvent,
    dispatchMouseEvent
  )

export
  events,
  resources,
  systems


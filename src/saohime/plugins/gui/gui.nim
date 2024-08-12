import
  pkg/[ecslib],
  ./components,
  ./events,
  ./systems

type
  GUIPlugin* = ref object

proc build*(plugin: GUIPlugin, world: World) =
  world.addEvent(ButtonEvent)
  world.registerSystems(dispatchClickEvent, changeButtonColor)
  # world.registerSystems(clearAllQueue)

export
  components,
  events,
  systems


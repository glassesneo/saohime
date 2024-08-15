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

export
  components,
  events,
  systems


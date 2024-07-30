import
  pkg/[ecslib],
  ./components,
  ./events,
  ./systems

type
  GUIPlugin* = ref object
    name*: string

proc new*(_: type GUIPlugin): GUIPlugin =
  return GUIPlugin(name: "GUIPlugin")

proc build*(plugin: GUIPlugin, world: World) =
  world.addEvent(ButtonEvent)
  world.registerSystems(dispatchClickEvent)

export new
export
  components,
  events,
  systems



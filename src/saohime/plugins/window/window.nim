import
  pkg/[ecslib],
  ./resources,
  ./systems

type WindowPlugin* = ref object
  name*: string

proc new*(_: type WindowPlugin): WindowPlugin =
  return WindowPlugin(name: "WindowPlugin")

proc build*(plugin: WindowPlugin, world: World) =
  world.addResource(Window.new())
  world.registerStartupSystems(createWindow)
  world.registerTerminateSystems(destroyWindow)

export new
export
  resources,
  systems


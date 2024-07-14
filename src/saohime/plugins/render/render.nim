import
  pkg/[ecslib],
  ./resources,
  ./systems

type RenderPlugin* = ref object
  name*: string

proc new*(_: type RenderPlugin): RenderPlugin =
  return RenderPlugin(name: "RenderPlugin")

proc build*(plugin: RenderPlugin, world: World) =
  world.addResource(Renderer.new())
  world.registerStartupSystems(createRenderer)
  world.registerTerminateSystems(destroyRenderer)

export new
export
  resources,
  systems


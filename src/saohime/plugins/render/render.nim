import
  pkg/[ecslib],
  ./resources,
  ./systems
import pkg/sdl2 except createRenderer, destroyRenderer

type RenderPlugin* = ref object
  name*: string

proc new*(_: type RenderPlugin): RenderPlugin =
  return RenderPlugin(name: "RenderPlugin")

proc build*(plugin: RenderPlugin, world: World) =
  world.addResource(
    Renderer.new(
      flags = RendererAccelerated or RendererPresentVsync
    )
  )
  world.registerStartupSystems(createRenderer)
  world.registerTerminateSystems(destroyRenderer)

export new
export
  resources,
  systems


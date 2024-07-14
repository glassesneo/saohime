import
  std/[importutils],
  pkg/[ecslib],
  ../../core/[exceptions, sdl2_helpers],
  ../window/window,
  ./resources,
  ./systems
import pkg/sdl2 except destroyRenderer

type RenderPlugin* = ref object
  name*: string

proc new*(_: type RenderPlugin): RenderPlugin =
  return RenderPlugin(name: "RenderPlugin")

proc build*(plugin: RenderPlugin, world: World) =
  privateAccess(Window)
  let window = world.getResource(Window)
  world.addResource(
    Renderer.new(
      window.window,
      flags = RendererAccelerated or RendererPresentVsync
    )
  )
  world.registerTerminateSystems(destroyRenderer)

export new
export
  resources,
  systems


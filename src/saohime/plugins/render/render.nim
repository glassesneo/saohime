import
  pkg/ecslib,
  ./components,
  ./resources,
  ./systems
from pkg/sdl2 import RendererAccelerated, RendererPresentVSync

type
  RenderPlugin* = ref object

proc build*(plugin: RenderPlugin, world: World) =
  world.addResource(RendererArgs.new(
    index = -1,
    flags = RendererAccelerated or RendererPresentVSync
  ))
  world.registerStartupSystems(createSaohimeRenderer)
  world.registerTerminateSystems(destroyRenderer)
  world.registerSystemsAt("first", clearScreen)
  world.registerSystemsAt("update", passSpriteSrc)
  world.registerSystemsAt("draw", copyTexture)
  world.registerSystemsAt("last", present)

export
  components,
  resources,
  systems


import
  pkg/ecslib,
  ./components,
  ./resources,
  ./systems
from pkg/sdl2 import RendererAccelerated, RendererPresentVSync

type
  RenderPlugin* = ref object

proc build*(plugin: RenderPlugin, world: World) =
  world.addResource(Renderer.new(
    flags = RendererAccelerated or RendererPresentVSync
  ))
  world.registerStartupSystems(createRenderer)
  world.registerTerminateSystems(destroyRenderer)
  world.registerSystemsAt("update", passSpriteSrc)
  world.registerSystemsAt("draw", clearScreen)
  world.registerSystemsAt("draw", renderPoint, renderLine, renderRectangle, renderCircle)
  world.registerSystemsAt("draw", copyTexture)
  world.registerSystemsAt("last", present)

export
  components,
  resources,
  systems


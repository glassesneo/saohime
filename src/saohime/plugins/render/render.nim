{.push raises: [].}

import
  pkg/[ecslib],
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
  world.registerSystems(clearScreen)
  world.registerSystems(renderPoint, renderLine, renderRectangle, renderCircle)
  world.registerSystems(renderButton)
  world.registerSystems(copyImage, copySprite, copyText)
  world.registerSystems(present)

export
  components,
  resources,
  systems


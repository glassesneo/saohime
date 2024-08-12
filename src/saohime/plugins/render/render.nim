{.push raises: [].}

import
  pkg/[ecslib],
  ./components,
  ./resources,
  ./systems
from pkg/sdl2 import RendererAccelerated

type
  RenderPlugin* = ref object

proc build*(plugin: RenderPlugin, world: World) =
  world.addResource(Renderer.new(
    flags = RendererAccelerated
  ))
  world.registerStartupSystems(createRenderer)
  world.registerTerminateSystems(destroyRenderer)
  world.registerSystems(clearScreen)
  world.registerSystems(point, line, rectangle, circle)
  world.registerSystems(button)
  world.registerSystems(copyTexture)
  world.registerSystems(present)

export
  components,
  resources,
  systems


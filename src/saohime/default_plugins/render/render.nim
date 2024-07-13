{.push raises: [].}

import
  pkg/[ecslib, oolib],
  ../../core/[exceptions, sdl2_helpers],
  ./resources,
  ./systems
from pkg/sdl2 import RendererPtr

class pub RenderPlugin:
  var renderer: RendererPtr
  var name* {.initial.} = "RenderPlugin"

  proc build*(world: World) =
    world.addResource(Renderer.new(self.renderer))
    world.registerTerminateSystems(destroyRenderer)

export
  resources,
  systems


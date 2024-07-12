{.push raises: [].}

import
  pkg/[ecslib, oolib, sdl2],
  ../../core/[exceptions, sdl2_helpers]

class pub Drawer:
  var renderer: RendererPtr

  proc loadTexture*(path: string): TexturePtr {.raises: [SDL2TextureError].} =
    return self.renderer.loadTexture(file = path)

class pub RenderPlugin:
  var renderer: RendererPtr

  proc build*(world: World) =
    world.addResource(Drawer.new(self.renderer))


{.push raises: [].}

import
  pkg/[ecslib, oolib, sdl2],
  ../../core/[exceptions, sdl2_helpers]

class pub Drawer:
  var renderer: RendererPtr

  proc loadTexture*(file: string): TexturePtr {.raises: [SDL2TextureError].} =
    return self.renderer.loadTexture(file)

class pub RenderPlugin:
  var renderer: RendererPtr

  proc build*(world: World) =
    world.addResource(Drawer.new(self.renderer))

export new
export RenderPlugin


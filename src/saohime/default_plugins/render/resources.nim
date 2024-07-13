{.push raises: [].}

import
  pkg/[ecslib, oolib, sdl2],
  ../../core/[exceptions, sdl2_helpers]

class pub Renderer:
  var renderer: RendererPtr

  proc destroy* =
    self.renderer.destroy()

  proc loadTexture*(file: string): TexturePtr {.raises: [SDL2TextureError].} =
    return self.renderer.loadTexture(file)


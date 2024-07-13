{.push raises: [].}

import
  pkg/[ecslib, oolib, sdl2],
  ../../core/[exceptions, sdl2_helpers]

class pub Drawer:
  var renderer: RendererPtr

  proc destroy* =
    self.renderer.destroy()

  proc loadTexture*(file: string): TexturePtr {.raises: [SDL2TextureError].} =
    return self.renderer.loadTexture(file)

{.pop raises.}

proc destroyRenderer* {.system.} =
  let drawer = commands.getResource(Drawer)
  drawer.destroy()

class pub RenderPlugin:
  var renderer: RendererPtr
  var name* {.initial.} = "RenderPlugin"

  proc build*(world: World) =
    world.addResource(Drawer.new(self.renderer))
    world.registerTerminateSystems(destroyRenderer)

export new
export RenderPlugin


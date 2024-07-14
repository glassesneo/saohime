{.push raises: [].}

import
  ../../core/[exceptions, sdl2_helpers]
import pkg/sdl2 except createRenderer

type Renderer* = ref object
  renderer: RendererPtr

proc new*(
    _: type Renderer,
    window: WindowPtr,
    index = -1,
    flags: cint
): Renderer {.raises: [SDL2RendererError].} =
  let renderer = createRenderer(
    window = window,
    index = index,
    flags = flags
  )
  return Renderer(renderer: renderer)

proc destroy*(renderer: Renderer) =
  renderer.renderer.destroy()

proc loadTexture*(
    renderer: Renderer,
    file: string
): TexturePtr {.raises: [SDL2TextureError].} =
  return renderer.renderer.loadTexture(file)


{.push raises: [].}

import
  ../../core/[exceptions, sdl2_helpers]
import pkg/sdl2 except createRenderer

type
  Renderer* = ref object
    renderer: RendererPtr

  RendererSettings* = ref object
    index*: int
    flags*: cint

proc new*(_: type Renderer): Renderer =
  return Renderer()

proc new*(
    _: type RendererSettings,
    index: int = -1,
    flags: cint = RendererAccelerated or RendererPresentVsync
): RendererSettings =
  return RendererSettings(
    index = index,
    flags = flags
  )

proc create*(
    renderer: Renderer,
    window: WindowPtr,
    index: int = -1,
    flags: cint = RendererAccelerated or RendererPresentVsync
) {.raises: [SDL2RendererError].} =
  renderer.renderer = createRenderer(
    window = window,
    index = index,
    flags = flags
  )

proc destroy*(renderer: Renderer) =
  renderer.renderer.destroy()

proc loadTexture*(
    renderer: Renderer,
    file: string
): TexturePtr {.raises: [SDL2TextureError].} =
  return renderer.renderer.loadTexture(file)


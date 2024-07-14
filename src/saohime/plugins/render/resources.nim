{.push raises: [].}

import
  ../../core/[exceptions, sdl2_helpers]
import pkg/sdl2 except createRenderer

type Renderer* = ref object
  renderer: RendererPtr
  initialArgs: tuple[index: int, flags: cint]

proc new*(
    _: type Renderer,
    index = -1,
    flags: cint
): Renderer =
  return Renderer(
    initialArgs: (
      index: index,
      flags: flags
    )
  )

proc create*(
    renderer: Renderer,
    window: WindowPtr
) {.raises: [SDL2RendererError].} =
  renderer.renderer = createRenderer(
    window = window,
    index = renderer.initialArgs.index,
    flags = renderer.initialArgs.flags
  )


proc destroy*(renderer: Renderer) =
  renderer.renderer.destroy()

proc loadTexture*(
    renderer: Renderer,
    file: string
): TexturePtr {.raises: [SDL2TextureError].} =
  return renderer.renderer.loadTexture(file)


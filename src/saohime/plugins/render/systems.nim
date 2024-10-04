import std/[algorithm, colors, importutils, sugar]
import pkg/[ecslib]
import pkg/sdl2 except Point
import ../../core/[saohime_types, sdl2_helpers]
import ../transform/transform, ../window/window
import ./[components, resources]

proc createSaohimeRenderer*(
    args: Resource[RendererArgs], window: Resource[Window]
) {.system.} =
  privateAccess(Window)

  let renderer = Renderer.new(createRenderer(window.window, args.index, args.flags))

  commands.addResource(renderer)
  commands.deleteResource(RendererArgs)

proc destroyRenderer*(renderer: Resource[Renderer]) {.system.} =
  renderer.destroy()

proc clearScreen*(renderer: Resource[Renderer]) {.system.} =
  renderer.setColor(renderer.windowBg)
  renderer.clear()

proc passSpriteSrc*(sprites: [All[Texture, Renderable, Sprite]]) {.system.} =
  for _, renderable, sprite in sprites[Renderable, Sprite]:
    renderable.srcPosition = sprite.currentSrcPosition()

proc copyTexture*(
    textureQuery: [All[Texture, Renderable, Transform]],
    renderer: Resource[Renderer],
    globalScale: Resource[GlobalScale],
) {.system.} =
  let sortedQuery = textureQuery.sortedByIt(it[Renderable].renderingOrder)
  for _, texture, renderable, tf in sortedQuery[Texture, Renderable, Transform]:
    let
      scale = map(globalScale.scale, tf.scale, (a, b: float) => a * b)
      xFlip = if scale.x < 0: SdlFlipHorizontal else: 0
      yFlip = if scale.y < 0: SdlFlipVertical else: 0

    renderer.copy(
      texture,
      (renderable.srcPosition, renderable.srcSize),
      (
        position: tf.position,
        size: map(renderable.srcSize, scale, (a, b: float) => a * b.abs),
      ),
      tf.rotation,
      xFlip or yFlip,
    )

proc present*(renderer: Resource[Renderer]) {.system.} =
  renderer.present()

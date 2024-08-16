import
  std/[colors, importutils, sugar],
  pkg/[ecslib],
  ../../core/[saohime_types],
  ../graphics/graphics,
  ../gui/gui,
  ../transform/transform,
  ../window/window,
  ./components,
  ./resources
import sdl2 except Point

proc createRenderer*(
    window: Resource[Window],
    renderer: Resource[Renderer]
) {.system.} =
  privateAccess(Window)

  renderer.create(window.window)

proc destroyRenderer*(renderer: Resource[Renderer]) {.system.} =
  renderer.destroy()

proc clearScreen*(renderer: Resource[Renderer]) {.system.} =
  renderer.setColor(colBlack)
  renderer.clear()

proc point*(
    All: [Point, Transform, Material],
    renderer: Resource[Renderer],
    globalScale: Resource[GlobalScale]
) {.system.} =
  for transform, material in each(entities, [Transform, Material]):
    renderer.setColor(material.fill)
    renderer.setScale(
      map(globalScale.scale, transform.scale, (a, b: float) => a * b)
    )
    renderer.drawPoint(transform.position)

proc line*(
    All: [Line, Transform, Material],
    renderer: Resource[Renderer],
    globalScale: Resource[GlobalScale]
) {.system.} =
  for line, transform, material in each(entities, [Line, Transform, Material]):
    let position = transform.renderedPosition
    renderer.setColor(material.fill)
    renderer.setScale(
      map(globalScale.scale, transform.scale, (a, b: float) => a * b)
    )
    renderer.drawLine(position, position + line.vector)

proc rectangle*(
    All: [Rectangle, Transform, Material],
    renderer: Resource[Renderer],
    globalScale: Resource[GlobalScale]
) {.system.} =
  for rectangle, transform, material in each(entities, [Rectangle, Transform, Material]):
    let position = transform.renderedPosition
    renderer.setScale(
      map(globalScale.scale, transform.scale, (a, b: float) => a * b)
    )
    renderer.setColor(material.fill)
    renderer.fillRectangle(position, rectangle.size)

    renderer.setColor(material.stroke)
    renderer.drawRectangle(position, rectangle.size)

proc circle*(
    All: [Circle, Transform, Material],
    renderer: Resource[Renderer],
    globalScale: Resource[GlobalScale]
) {.system.} =
  for circle, transform, material in each(entities, [Circle, Transform, Material]):
    let position = transform.renderedPosition
    renderer.setScale(
      map(globalScale.scale, transform.scale, (a, b: float) => a * b)
    )
    renderer.setColor(material.fill)
    renderer.fillCircle(position, circle.radius)

    renderer.setColor(material.stroke)
    renderer.drawCircle(position, circle.radius)

proc button*(
    All: [Button, Transform],
    renderer: Resource[Renderer],
    globalScale: Resource[GlobalScale]
) {.system.} =
  for button, transform in each(entities, [Button, Transform]):
    let position = transform.renderedPosition
    renderer.setScale(
      map(globalScale.scale, transform.scale, (a, b: float) => a * b)
    )
    renderer.setColor(button.currentColor)
    renderer.fillRectangle(position, button.size)

proc copyTexture*(
    All: [Texture, Transform],
    renderer: Resource[Renderer],
    globalScale: Resource[GlobalScale]
) {.system.} =
  for texture, transform in each(entities, [Texture, Transform]):
    let
      scale = map(globalScale.scale, transform.scale, (a, b: float) => a * b)
      size = texture.getSize()
      xFlip = if scale.x < 0: SdlFlipHorizontal else: 0
      yFlip = if scale.y < 0: SdlFlipVertical else: 0

    renderer.copyEntire(
      texture,
      (
        position: transform.position,
        size: map(size, scale, (x, y: float) => x * y.abs)
      ),
      transform.rotation,
      xFlip or yFlip
    )

proc copySprite*(
    All: [Sprite, Transform],
    renderer: Resource[Renderer],
    globalScale: Resource[GlobalScale]
) {.system.} =
  for sprite, transform in each(entities, [Sprite, Transform]):
    let
      scale = map(globalScale.scale, transform.scale, (a, b: float) => a * b)
      size = sprite.spriteSize
      xFlip = if scale.x < 0: SdlFlipHorizontal else: 0
      yFlip = if scale.y < 0: SdlFlipVertical else: 0

    renderer.copy(
      sprite,
      (
        position: transform.position,
        size: map(size, scale, (x, y: float) => x * y.abs)
      ),
      transform.rotation,
      xFlip or yFlip
    )

proc present*(renderer: Resource[Renderer]) {.system.} =
  renderer.present()


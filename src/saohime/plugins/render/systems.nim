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

proc renderPoint*(
    points: [All[Point, Transform, Material]],
    renderer: Resource[Renderer],
    globalScale: Resource[GlobalScale]
) {.system.} =
  for transform, material in each(points, [Transform, Material]):
    renderer.setColor(material.fill)
    renderer.setScale(
      map(globalScale.scale, transform.scale, (a, b: float) => a * b)
    )
    renderer.drawPoint(transform.position)

proc renderLine*(
    lines: [All[Line, Transform, Material]],
    renderer: Resource[Renderer],
    globalScale: Resource[GlobalScale]
) {.system.} =
  for line, transform, material in each(lines, [Line, Transform, Material]):
    let position = transform.renderedPosition
    renderer.setColor(material.fill)
    renderer.setScale(
      map(globalScale.scale, transform.scale, (a, b: float) => a * b)
    )
    renderer.drawLine(position, position + line.vector)

proc renderRectangle*(
    rectangles: [All[Rectangle, Transform, Material]],
    renderer: Resource[Renderer],
    globalScale: Resource[GlobalScale]
) {.system.} =
  for rectangle, transform, material in each(rectangles, [Rectangle, Transform, Material]):
    let position = transform.renderedPosition
    renderer.setScale(
      map(globalScale.scale, transform.scale, (a, b: float) => a * b)
    )
    renderer.setColor(material.fill)
    renderer.fillRectangle(position, rectangle.size)

    renderer.setColor(material.stroke)
    renderer.drawRectangle(position, rectangle.size)

proc renderCircle*(
    circles: [All[Circle, Transform, Material]],
    renderer: Resource[Renderer],
    globalScale: Resource[GlobalScale]
) {.system.} =
  for circle, transform, material in each(circles, [Circle, Transform, Material]):
    let position = transform.renderedPosition
    renderer.setScale(
      map(globalScale.scale, transform.scale, (a, b: float) => a * b)
    )
    renderer.setColor(material.fill)
    renderer.fillCircle(position, circle.radius)

    renderer.setColor(material.stroke)
    renderer.drawCircle(position, circle.radius)

proc renderButton*(
    buttons: [All[Button, Transform]],
    renderer: Resource[Renderer],
    globalScale: Resource[GlobalScale]
) {.system.} =
  for button, transform in each(buttons, [Button, Transform]):
    let position = transform.renderedPosition
    renderer.setScale(
      map(globalScale.scale, transform.scale, (a, b: float) => a * b)
    )
    renderer.setColor(button.currentColor)
    renderer.fillRectangle(position, button.size)

proc copyImage*(
    images: [All[Texture, Image, Transform], None[Sprite]],
    renderer: Resource[Renderer],
    globalScale: Resource[GlobalScale]
) {.system.} =
  for texture, image, transform in each(images, [Texture, Image, Transform]):
    let
      scale = map(globalScale.scale, transform.scale, (a, b: float) => a * b)
      size = texture.getSize()
      xFlip = if scale.x < 0: SdlFlipHorizontal else: 0
      yFlip = if scale.y < 0: SdlFlipVertical else: 0

    renderer.copy(
      texture,
      (
        position: image.srcPosition,
        size: image.srcSize,
      ),
      (
        position: transform.position,
        size: map(size, scale, (x, y: float) => x * y.abs)
      ),
      transform.rotation,
      xFlip or yFlip
    )

proc copySprite*(
    sprites: [All[Texture, Sprite, Transform]],
    renderer: Resource[Renderer],
    globalScale: Resource[GlobalScale]
) {.system.} =
  for texture, sprite, transform in each(sprites, [Texture, Sprite, Transform]):
    let
      scale = map(globalScale.scale, transform.scale, (a, b: float) => a * b)
      size = sprite.spriteSize
      xFlip = if scale.x < 0: SdlFlipHorizontal else: 0
      yFlip = if scale.y < 0: SdlFlipVertical else: 0

    renderer.copy(
      texture,
      (
        position: sprite.currentSrcPosition(),
        size: sprite.spriteSize,
      ),
      (
        position: transform.position,
        size: map(size, scale, (x, y: float) => x * y.abs)
      ),
      transform.rotation,
      xFlip or yFlip
    )

proc copyText*(
    texts: [All[Texture, Text, Transform]],
    renderer: Resource[Renderer],
    globalScale: Resource[GlobalScale]
) {.system.} =
  for texture, text, transform in each(texts, [Texture, Text, Transform]):
    let
      scale = map(globalScale.scale, transform.scale, (a, b: float) => a * b)
      size = text.size
      xFlip = if scale.x < 0: SdlFlipHorizontal else: 0
      yFlip = if scale.y < 0: SdlFlipVertical else: 0

    renderer.copy(
      texture,
      (
        position: ZeroVector,
        size: size,
      ),
      (
        position: transform.position,
        size: map(size, scale, (x, y: float) => x * y.abs)
      ),
      transform.rotation,
      xFlip or yFlip
    )

proc present*(renderer: Resource[Renderer]) {.system.} =
  renderer.present()


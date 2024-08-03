import
  std/[colors, importutils],
  pkg/[ecslib, sdl2],
  ../../core/[saohime_types],
  ../graphics/graphics,
  ../gui/gui,
  ../transform/transform,
  ../window/window,
  ./components,
  ./resources

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
    renderer: Resource[Renderer]
) {.system.} =
  for transform, material in each(entities, [Transform, Material]):
    renderer.setColor(material.fill)
    renderer.setScale(transform.scale)
    renderer.drawPoint(transform.position)

proc line*(
    All: [Line, Transform, Material],
    renderer: Resource[Renderer]
) {.system.} =
  for line, transform, material in each(entities, [Line, Transform, Material]):
    let position = transform.renderedPosition
    renderer.setColor(material.fill)
    renderer.setScale(transform.scale)
    renderer.drawLine(position, position + line.vector)

proc rectangle*(
    All: [Rectangle, Transform, Material],
    renderer: Resource[Renderer]
) {.system.} =
  for rectangle, transform, material in each(entities, [Rectangle, Transform, Material]):
    let position = transform.renderedPosition
    renderer.setScale(transform.scale)
    renderer.setColor(material.fill)
    renderer.fillRectangle(position, rectangle.size)

    renderer.setColor(material.stroke)
    renderer.drawRectangle(position, rectangle.size)

proc circle*(
    All: [Circle, Transform, Material],
    renderer: Resource[Renderer]
) {.system.} =
  for circle, transform, material in each(entities, [Circle, Transform, Material]):
    let position = transform.renderedPosition
    renderer.setScale(transform.scale)
    renderer.setColor(material.fill)
    renderer.fillCircle(position, circle.radius)

    renderer.setColor(material.stroke)
    renderer.drawCircle(position, circle.radius)

proc button*(
    All: [Button, Transform],
    renderer: Resource[Renderer]
) {.system.} =
  for button, transform in each(entities, [Button, Transform]):
    let position = transform.renderedPosition
    renderer.setScale(transform.scale)
    renderer.setColor(button.currentColor)
    renderer.fillRectangle(position, button.size)

proc copyTexture*(
    All: [Texture, Transform],
    renderer: Resource[Renderer]
) {.system.} =
  for texture, transform in each(entities, [Texture, Transform]):
    let
      scale = transform.scale
      size = texture.getSize()
      xFlip = if scale.x < 0: SdlFlipHorizontal else: 0
      yFlip = if scale.y < 0: SdlFlipVertical else: 0

    renderer.copyEntire(
      texture,
      (
        position: transform.position,
        size: Vector.new(size.x * scale.x.abs, size.y * scale.y.abs)
      ),
      transform.rotation,
      xFlip or yFlip
    )

proc present*(renderer: Resource[Renderer]) {.system.} =
  renderer.present()


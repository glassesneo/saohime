import
  std/[colors, importutils],
  pkg/[ecslib, sdl2],
  ../../core/[saohime_types],
  ../font/font,
  ../graphics/graphics,
  ../transform/transform,
  ../window/window,
  ./components,
  ./resources

proc createRenderer* {.system.} =
  privateAccess(Window)
  let
    window = commands.getResource(Window)
    renderer = commands.getResource(Renderer)

  renderer.create(window.window)

proc destroyRenderer* {.system.} =
  let renderer = commands.getResource(Renderer)
  renderer.destroy()

proc clearScreen* {.system.} =
  let renderer = commands.getResource(Renderer)

  renderer.setColor(colBlack)
  renderer.clear()

proc point*(All: [Point, Transform, Material]) {.system.} =
  let renderer = commands.getResource(Renderer)

  for transform, material in each(entities, [Transform, Material]):
    renderer.setColor(material.fill)
    renderer.setScale(transform.scale)
    renderer.drawPoint(transform.position)

proc line*(All: [Line, Transform, Material]) {.system.} =
  let renderer = commands.getResource(Renderer)

  for line, transform, material in each(entities, [Line, Transform, Material]):
    let position = transform.renderedPosition
    renderer.setColor(material.fill)
    renderer.setScale(transform.scale)
    renderer.drawLine(position, position + line.vector)

proc rectangle*(All: [Rectangle, Transform, Material]) {.system.} =
  let renderer = commands.getResource(Renderer)

  for rectangle, transform, material in each(entities, [Rectangle, Transform, Material]):
    let position = transform.renderedPosition
    renderer.setScale(transform.scale)
    renderer.setColor(material.fill)
    renderer.fillRectangle(position, rectangle.size)

    renderer.setColor(material.stroke)
    renderer.drawRectangle(position, rectangle.size)

proc circle*(All: [Circle, Transform, Material]) {.system.} =
  let renderer = commands.getResource(Renderer)

  for circle, transform, material in each(entities, [Circle, Transform, Material]):
    let position = transform.renderedPosition
    renderer.setScale(transform.scale)
    renderer.setColor(material.fill)
    renderer.fillCircle(position, circle.radius)

    renderer.setColor(material.stroke)
    renderer.drawCircle(position, circle.radius)

proc copyTexture*(All: [Texture, Transform]) {.system.} =
  let renderer = commands.getResource(Renderer)
  for texture, transform in each(entities, [Texture, Transform]):
    let
      scale = transform.scale
      size = texture.getSize()
      xFlip = if scale.x < 0: SdlFlipHorizontal else: 0
      yFlip = if scale.x < 0: SdlFlipVertical else: 0

    renderer.copyEntire(
      texture,
      (
        position: transform.position,
        size: Vector.new(size.x * scale.x.abs, size.y * scale.y.abs)
      ),
      transform.rotation,
      xFlip or yFlip
    )

proc present* {.system.} =
  let renderer = commands.getResource(Renderer)
  renderer.present()


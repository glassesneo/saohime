import
  std/[colors, importutils],
  pkg/[ecslib],
  ../../core/[saohime_types],
  ../graphics/graphics,
  ../transform/transform,
  ../window/window,
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

proc present* {.system.} =
  let renderer = commands.getResource(Renderer)
  renderer.present()


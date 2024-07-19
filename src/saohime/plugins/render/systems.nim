import
  std/[colors, importutils],
  pkg/[ecslib],
  ../../core/color,
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
    let
      scale = transform.scale
      position = transform.renderedPosition
    renderer.setColor(material.fill)
    renderer.setScale(scale.x, scale.y)
    renderer.drawPoint(position.x, position.y)

proc line*(All: [Line, Transform, Material]) {.system.} =
  let renderer = commands.getResource(Renderer)

  for line, transform, material in each(entities, [Line, Transform, Material]):
    let
      scale = transform.scale
      position = transform.renderedPosition
    renderer.setColor(material.fill)
    renderer.setScale(scale.x, scale.y)
    renderer.drawLine(
      position.x,
      position.y,
      position.x + line.x,
      position.y + line.y
    )

proc rectangle*(All: [Rectangle, Transform, Material]) {.system.} =
  let renderer = commands.getResource(Renderer)

  for rectangle, transform, material in each(entities, [Rectangle, Transform, Material]):
    let
      scale = transform.scale
      position = transform.renderedPosition
    renderer.setScale(scale.x, scale.y)

    if material.fill.a != 0:
      renderer.setColor(material.fill)
      renderer.fillRectangle(
        position.x,
        position.y,
        rectangle.width,
        rectangle.height
      )

    if material.stroke.a != 0:
      renderer.setColor(material.stroke)
      renderer.drawRectangle(
        position.x,
        position.y,
        rectangle.width,
        rectangle.height
      )

proc circle*(All: [Circle, Transform, Material]) {.system.} =
  let renderer = commands.getResource(Renderer)

  for circle, transform, material in each(entities, [Circle, Transform, Material]):
    let
      scale = transform.scale
      position = transform.renderedPosition
    renderer.setScale(scale.x, scale.y)

    if material.fill.a != 0:
      renderer.setColor(material.fill)
      renderer.fillCircle(
        position.x,
        position.y,
        circle.radius
      )
    if material.stroke.a != 0:
      renderer.setColor(material.stroke)
      renderer.drawCircle(
        position.x,
        position.y,
        circle.radius
      )

proc present* {.system.} =
  let renderer = commands.getResource(Renderer)
  renderer.present()


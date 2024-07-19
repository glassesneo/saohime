import
  std/[colors, importutils],
  pkg/[ecslib],
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
      (r, g, b, a) = material.color
      scale = transform.scale
      position = transform.renderedPosition
    renderer.setColor(r, g, b, a)
    renderer.setScale(scale.x, scale.y)
    renderer.drawPoint(position.x, position.y)

proc line*(All: [Line, Transform, Material]) {.system.} =
  let renderer = commands.getResource(Renderer)

  for line, transform, material in each(entities, [Line, Transform, Material]):
    let
      (r, g, b, a) = material.color
      scale = transform.scale
      position = transform.renderedPosition
    renderer.setColor(r, g, b, a)
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
      (r, g, b, a) = material.color
      scale = transform.scale
      position = transform.renderedPosition
    renderer.setColor(r, g, b, a)
    renderer.setScale(scale.x, scale.y)
    if material.filled:
      renderer.fillRectangle(
        position.x,
        position.y,
        rectangle.width,
        rectangle.height
      )
    else:
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
      (r, g, b, a) = material.color
      scale = transform.scale
      position = transform.renderedPosition
    renderer.setColor(r, g, b, a)
    renderer.setScale(scale.x, scale.y)
    if material.filled:
      renderer.fillCircle(
        position.x,
        position.y,
        circle.radius
      )
    else:
      renderer.drawCircle(
        position.x,
        position.y,
        circle.radius
      )

proc present* {.system.} =
  let renderer = commands.getResource(Renderer)
  renderer.present()


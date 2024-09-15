import
  std/[colors, importutils, sugar],
  pkg/[ecslib],
  ../../core/[saohime_types],
  ../graphics/graphics,
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
  for _, transform, material in points[Transform, Material]:
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
  for _, line, transform, material in lines[Line, Transform, Material]:
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
  for _, rectangle, transform, material in rectangles[Rectangle, Transform, Material]:
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
  for _, circle, transform, material in circles[Circle, Transform, Material]:
    let position = transform.renderedPosition
    renderer.setScale(
      map(globalScale.scale, transform.scale, (a, b: float) => a * b)
    )
    renderer.setColor(material.fill)
    renderer.fillCircle(position, circle.radius)

    renderer.setColor(material.stroke)
    renderer.drawCircle(position, circle.radius)

proc passSpriteSrc*(sprites: [All[Texture, Renderable, Sprite]]) {.system.} =
  for _, renderable, sprite in sprites[Renderable, Sprite]:
    renderable.srcPosition = sprite.currentSrcPosition()

proc copyTexture*(
    textureQuery: [All[Texture, Renderable, Transform]],
    renderer: Resource[Renderer],
    globalScale: Resource[GlobalScale]
) {.system.} =
  for _, texture, renderable, tf in textureQuery[Texture, Renderable, Transform]:
    let
      scale = map(globalScale.scale, tf.scale, (a, b: float) => a * b)
      xFlip = if scale.x < 0: SdlFlipHorizontal else: 0
      yFlip = if scale.y < 0: SdlFlipVertical else: 0

    renderer.copy(
      texture,
      (renderable.srcPosition, renderable.srcSize),
      (
        position: tf.position,
        size: map(renderable.srcSize, scale, (a, b: float) => a * b.abs)
      ),
      tf.rotation,
      xFlip or yFlip
    )

proc present*(renderer: Resource[Renderer]) {.system.} =
  renderer.present()


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

proc copyImage*(
    images: [All[Texture, Image, Transform], None[Sprite]],
    renderer: Resource[Renderer],
    globalScale: Resource[GlobalScale]
) {.system.} =
  for _, texture, image, transform in images[Texture, Image, Transform]:
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
  for _, texture, sprite, transform in sprites[Texture, Sprite, Transform]:
    let
      scale = map(globalScale.scale, transform.scale, (a, b: float) => a * b)
      size = sprite.spriteSize
      xFlip = if scale.x < 0: SdlFlipHorizontal else: 0
      yFlip = if scale.y < 0: SdlFlipVertical else: 0

    renderer.copy(
      texture,
      (
        position: sprite.currentSrcPosition(),
        size: size
      ),
      (
        position: transform.position,
        size: map(size, scale, (x, y: float) => x * y.abs)
      ),
      transform.rotation,
      xFlip or yFlip
    )

proc copyTileMap*(
    tileMaps: [All[Texture, TileMap, Transform]],
    renderer: Resource[Renderer],
    globalScale: Resource[GlobalScale]
) {.system.} =
  for _, texture, tile, transform in tileMaps[Texture, TileMap, Transform]:
    let
      scale = map(globalScale.scale, transform.scale, (a, b: float) => a * b)
      size = tile.tileSize
      xFlip = if scale.x < 0: SdlFlipHorizontal else: 0
      yFlip = if scale.y < 0: SdlFlipVertical else: 0

    renderer.copy(
      texture,
      (
        position: tile.srcPosition,
        size: size
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
  for _, texture, text, transform in texts[Texture, Text, Transform]:
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


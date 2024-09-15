import
  std/[lenientops],
  ../src/saohime,
  ../src/saohime/default_plugins

proc pollEvent(appEvent: Event[ApplicationEvent]) {.system.} =
  for e in appEvent:
    let app = commands.getResource(Application)
    app.terminate()

let app = Application.new()

proc load(assetManager: Resource[AssetManager]) {.system.} =
  let catTexture = assetManager.loadTexture("cat.jpg")

  let cat = commands.create()
    .ImageBundle(catTexture, renderingOrder = 5)
    .attach(Transform.new(
      x = 0, y = 0,
      scale = Vector.new(0.125, 0.125),
    ))

  let knightTexture = assetManager.loadTexture("knight.png")

  let spriteSheet = SpriteSheet.new(
    knightTexture.getSize(),
    columnLen = 8,
    rowLen = 8
  )

  let
    standingSprite = spriteSheet[0, 4]
    runningSprite = spriteSheet[2..3]
    rollingSprite = spriteSheet[5]

  let spriteList = @[
    standingSprite,
    runningSprite,
    rollingSprite
  ]

  for i in 0..<3:
    commands.create()
      .SpriteBundle(knightTexture, spriteList[i], renderingOrder = (i+1) * 3)
      .attach(Transform.new(
        x = 200f * i, y = 200f,
        scale = Vector.new(5f, 5f)
      ))

proc rotateSpriteIndex(
    spriteQuery: [All[Sprite]],
    fpsManager: Resource[FPSManager]
) {.system.} =
  if fpsManager.frameCount mod 3 != 0:
    return

  for _, sprite in spriteQuery[Sprite]:
    sprite.rotateIndex()
app.loadPluginGroup(DefaultPlugins)

app.start:
  world.updateResource(Window(size: (1000, 500)))
  world.registerSystems(pollEvent, rotateSpriteIndex)
  world.registerStartupSystems(load)


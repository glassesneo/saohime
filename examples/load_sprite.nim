import
  std/[lenientops],
  ../src/saohime,
  ../src/saohime/default_plugins

proc pollEvent(appEvent: Event[ApplicationEvent]) {.system.} =
  for e in appEvent:
    let app = commands.getResource(Application)
    app.terminate()

let app = Application.new()

proc load(renderer: Resource[Renderer]) {.system.} =
  let spriteSheet = renderer.loadSpriteSheet(
    "assets/knight.png",
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
      .attach(spriteList[i])
      .attach(Transform.new(
        x = 200f * i, y = 200f,
        scale = Vector.new(5f, 5f)
      ))

proc rotateSpriteIndex(All: [Sprite]) {.system.} =
  for sprite in each(entities, [Sprite]):
    sprite.rotateIndex()

app.loadPluginGroup(DefaultPlugins)


app.start:
  world.updateResource(Window(size: (1000, 500)))
  world.updateResource(FPSManager(fps: 30))
  world.registerSystems(pollEvent, rotateSpriteIndex)
  world.registerStartupSystems(load)


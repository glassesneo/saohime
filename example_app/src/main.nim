import
  std/[math],
  ../../src/saohime,
  ../../src/saohime/default_plugins

type
  Player = ref object

proc pollEvent(appEvent: Event[ApplicationEvent]) {.system.} =
  for e in appEvent:
    let app = commands.getResource(Application)
    app.terminate()

let app = Application.new()

proc load(assetManager: Resource[AssetManager]) {.system.} =
  let spriteSheet = assetManager.loadSpriteSheet(
    "knight.png",
    columnLen = 8,
    rowLen = 8
  )

  let sprite = spriteSheet[0, 4]

  commands.create()
    .attach(Player())
    .attach(sprite)
    .attach(Transform.new(
      x = 50, y = 300,
      scale = Vector.new(3f, 3f)
    ))

proc playerMove(
    All: [Player, Sprite, Transform],
    fpsManager: Resource[FPSManager],
    keyboardEvent: Event[KeyboardEvent]
) {.system.} =
  for e in keyboardEvent:
    for sprite, transform in each(entities, [Sprite, Transform]):
      if e.isDown(K_d):
        transform.position.x += 5
        transform.scale.x = transform.scale.x.abs
        if fpsManager.frameCount mod 3 == 0:
          sprite.rotateIndex()
      elif e.isDown(K_a):
        transform.position.x -= 5
        transform.scale.x = -transform.scale.x.abs
        if fpsManager.frameCount mod 3 == 0:
          sprite.rotateIndex()
      else:
        sprite.currentIndex = 0


  keyboardEvent.clearQueue()


app.loadPluginGroup(DefaultPlugins)


app.start:
  world.registerSystems(pollEvent, playerMove)
  world.registerStartupSystems(load)


import
  std/[colors, lenientops, random],
  ../../src/saohime,
  ../../src/saohime/default_plugins

type
  Player = ref object
    state: PlayerState
    direction: PlayerDirection

  PlayerState = enum
    Idle
    Running
    Rolling

  PlayerDirection = enum
    Left
    Right

  PlayerSpriteList = ref object
    spriteTable: array[PlayerState, Sprite]

proc setup(assetManager: Resource[AssetManager]) {.system.} =
  assetManager.loadIcon("example_app_icon.png")
  let spriteSheet = assetManager.loadSpriteSheet(
    "knight.png",
    columnLen = 8,
    rowLen = 8
  )

  let
    idleSprite = spriteSheet[0, 4]
    runningSprite = spriteSheet[2..3]
    rollingSprite = spriteSheet[5]

  let spriteList = PlayerSpriteList(
    spriteTable: [idleSprite, runningSprite, rollingSprite]
  )

  let knight = commands.create()
    .attach(Player(state: Idle, direction: Right))
    .attach(idleSprite)
    .attach(spriteList)
    .attach(Transform.new(
      x = 50, y = 300,
      scale = Vector.new(3f, 3f)
    ))

  for i in 0..<200:
    let length = rand(1.0..3.00)
    let color = SaohimeColor.new()
    color.r = rand(255)
    color.g = rand(255)
    color.b = 255
    color.a = rand(255)
    commands.create()
      .attach(Circle.new(radius = length))
      .attach(Transform.new(x = rand(0f..2000f), y = rand(0f..220f)))
      .attach(Material.new(color = color))

  for i in 0..<300:
    let length = rand(0.01..2.00)
    let color = SaohimeColor.new()
    color.r = rand(255)
    color.g = rand(255)
    color.b = rand(255)
    commands.create()
      .attach(Circle.new(radius = length))
      .attach(Transform.new(x = rand(0f..2000f), y = rand(0f..300f)))
      .attach(Material.new(color = color))

  let floor = commands.create()
    .attach(Rectangle.new(2000, 200))
    .attach(Transform.new(x = 0, y = 375))
    .attach(Material.new(
      color = colLightGrey.toSaohimeColor()
    ))

proc pollEvent(appEvent: Event[ApplicationEvent]) {.system.} =
  for e in appEvent:
    let app = commands.getResource(Application)
    app.terminate()

proc updateSprite(All: [Player]) {.system.} =
  for player, spriteList in each(entities, [Player, PlayerSpriteList]):
    let sprite = spriteList.spriteTable[player.state]
    if entity[Sprite] != sprite:
      sprite.currentIndex = 0
      entity[Sprite] = sprite

proc rotateSpriteIndex(
    All: [Player, Sprite],
    fpsManager: Resource[FPSManager]
) {.system.} =
  for player, sprite in each(entities, [Player, Sprite]):
    let interval = case player.state
      of Idle: fpsManager.interval(12)
      of Running: fpsManager.interval(8)
      of Rolling: fpsManager.interval(4)

    sprite.rotateIndex(interval)

proc changePlayerState(
    All: [Player],
    keyboardEvent: Event[KeyboardEvent]
) {.system.} =
  for player, sprite in each(entities, [Player, Sprite]):
    if player.state == Rolling:
      if sprite.currentIndex == 7:
        player.state = Idle
      return

    for e in keyboardEvent:
      if e.isDown(K_d):
        player.direction = Right
        player.state = if e.isDown(K_LSHIFT):
          Rolling
        else:
          Running
        return

      elif e.isDown(K_a):
        player.direction = Left
        player.state = if e.isDown(K_LSHIFT):
          Rolling
        else:
          Running
        return

    player.state = Idle

proc playerMove(All: [Player]) {.system.} =
  for player, transform in each(entities, [Player, Transform]):
    case player.state
    of Idle:
      discard

    of Running:
      case player.direction
      of Right:
        transform.scale.x = transform.scale.x.abs
        transform.translate(x = 3)
      of Left:
        transform.scale.x = -transform.scale.x.abs
        transform.translate(x = -3)

    of Rolling:
      case player.direction
      of Right:
        transform.scale.x = transform.scale.x.abs
        transform.translate(x = 6)
      of Left:
        transform.scale.x = -transform.scale.x.abs
        transform.translate(x = -6)

proc scroll(
    All: [Player],
    camera: Resource[Camera],
) {.system.} =
  for transform, sprite in each(entities, [Transform, Sprite]):
    let renderedSpriteSize = sprite.spriteCentralSize.x * transform.scale.x.abs
    let playerPos = transform.position.x + renderedSpriteSize
    let cameraCentralSize = camera.centralSize

    # Go right
    if playerPos > camera.position.x + cameraCentralSize.x:
      if camera.position.x + camera.size.x < 2000:
        camera.position.x = playerPos - cameraCentralSize.x

    # Go left
    if playerPos < camera.position.x + cameraCentralSize.x:
      if camera.position.x > 0:
        camera.position.x = playerPos - cameraCentralSize.x

let app = Application.new()

app.loadPluginGroup(DefaultPlugins)

app.start:
  world.registerStartupSystems(setup)
  world.registerSystems(pollEvent)
  world.registerSystems(updateSprite, rotateSpriteIndex, changePlayerState, playerMove)
  world.registerSystems(scroll)


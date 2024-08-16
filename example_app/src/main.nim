import
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

  commands.create()
    .attach(Player(state: Idle, direction: Right))
    .attach(idleSprite)
    .attach(spriteList)
    .attach(Transform.new(
      x = 50, y = 300,
      scale = Vector.new(3f, 3f)
    ))

proc pollEvent(appEvent: Event[ApplicationEvent]) {.system.} =
  for e in appEvent:
    let app = commands.getResource(Application)
    app.terminate()

let app = Application.new()

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
      of Rolling: fpsManager.interval(4)
      else: fpsManager.interval(8)

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
      of Left:
        transform.scale.x = -transform.scale.x.abs
        transform.position.x -= 3
      of Right:
        transform.scale.x = transform.scale.x.abs
        transform.position.x += 3

    of Rolling:
      case player.direction
      of Left:
        transform.scale.x = -transform.scale.x.abs
        transform.position.x -= 6
      of Right:
        transform.scale.x = transform.scale.x.abs
        transform.position.x += 6

app.loadPluginGroup(DefaultPlugins)


app.start:
  world.registerSystems(
    pollEvent,
    updateSprite,
    rotateSpriteIndex,
    changePlayerState,
    playerMove
  )
  world.registerStartupSystems(setup)


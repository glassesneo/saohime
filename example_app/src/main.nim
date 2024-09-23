import
  std/[lenientops, os, random, sugar],
  ../../src/saohime,
  ../../src/saohime/default_plugins,
  ./physics/physics

type
  Player = ref object
    state: PlayerState
    direction: PlayerDirection
    onGround: bool

  PlayerState = enum
    Idle
    Jumping
    Running
    Rolling

  PlayerDirection = enum Left, Right

  PlayerSpriteList = ref object
    spriteTable: array[PlayerState, Sprite]

  Status = ref object
    speed: float
    jump: float

proc setup(
    assetManager: Resource[AssetManager],
    renderer: Resource[Renderer]
) {.system.} =
  commands.updateResource(Gravity(g: 45))
  block:
    let
      knightTexture = assetManager[Texture].load(renderer, "knight.png")

      spriteSheet = SpriteSheet.new(
        knightTexture.getSize(),
        columnLen = 8, rowLen = 8
      )
      idleSprite = spriteSheet[0, 4]
      runningSprite = spriteSheet[2..3]
      rollingSprite = spriteSheet[5]

      spriteList = PlayerSpriteList(spriteTable: [
        idleSprite, idleSprite, runningSprite, rollingSprite
      ])

      knightScale = Vector.new(3f, 3f)

    let knight = commands.create()
      .attach(Player(state: Idle, direction: Right))
      .SpriteBundle(knightTexture, idleSprite)
      .attach(spriteList)
      .attach(Transform.new(
        x = 50, y = 150,
        scale = knightScale
      ))
      .attach(Rigidbody.new(mass = 10, useGravity = true))
      .attach(RectangleCollider.new(map(
        idleSprite.srcSize, knightScale, (a, b: float) => a * b
      )))
      .attach(Status(speed: 3, jump: 25))

  for i in 0..<200:
    let length = rand(1.0..3.00)
    let color = SaohimeColor.new(
      r = rand(255),
      g = rand(255),
      b = 255,
      a = rand(255),
    )
    commands.create()
      .attach(Circle.new(radius = length))
      .attach(Transform.new(x = rand(0f..2000f), y = rand(0f..220f)))
      .attach(Fill.new(color = color))

  for i in 0..<300:
    let length = rand(0.01..2.00)
    let color = SaohimeColor.new(
      r = rand(255),
      g = rand(255),
      b = rand(255)
    )
    commands.create()
      .attach(Circle.new(radius = length))
      .attach(Transform.new(x = rand(0f..2000f), y = rand(0f..300f)))
      .attach(Fill.new(color = color))

  block:
    let
      tileMapTexture = assetManager[Texture].load(renderer, "world_tileset.png")
      tileMapSheet = TileMapSheet.new(
        tileMapTexture.getSize(),
        columnLen = 16,
        rowLen = 16
      )

    let position = Vector.new(x = 0, y = 320)

    let
      floor = commands.create()
        .attach(Transform.new(position.x, position.y))
        .attach(Rigidbody.new(mass = 100, useGravity = false))
        .attach(RectangleCollider.new(Vector.new(2000, 200)))

    let tileScale = Vector.new(3f, 3f)
    for i in 0..<42:
      commands.create()
        .attach(Transform.new(
          x = tileMapSheet.tileSize.x * i * tileScale.x,
          y = position.y,
          scale = tileScale
        ))
        .TileMapBundle(tileMapTexture, tileMapSheet.at(0, 0))

      commands.create()
        .attach(Transform.new(
          x = tileMapSheet.tileSize.x * i * tileScale.x,
          y = position.y + 45,
          scale = tileScale
        ))
        .TileMapBundle(tileMapTexture, tileMapSheet.at(0, 1))

      commands.create()
        .attach(Transform.new(
          x = tileMapSheet.tileSize.x * i * tileScale.x,
          y = position.y + 90,
          scale = tileScale
        ))
        .TileMapBundle(tileMapTexture, tileMapSheet.at(3, 1))

proc pollEvent(appEvent: Event[ApplicationEvent]) {.system.} =
  for e in appEvent:
    let app = commands.getResource(Application)
    app.terminate()

proc playerLand(
    playerQuery: [All[Player]],
    collision: Event[CollisionEvent]
) {.system.} =
  let
    playerEntity = playerQuery[0]
    player = playerEntity[Player]

  player.onGround = false
  if player.state == Jumping:
    return
  for event in collision:
    let
      e1 = commands.getEntity(event.entityId1)
      e2 = commands.getEntity(event.entityId2)

    if e1.id == playerEntity.id and event.normal.y == 1f or
      e2.id == playerEntity.id and event.normal.y == -1f:

      player.onGround = true
      let rb = playerEntity.get(Rigidbody)
      if rb.velocity.y > 0:
        rb.velocity.y = 0
      if rb.force.y > 0:
        rb.force.y = 0

proc updateSprite(playerQuery: [All[Player]]) {.system.} =
  let playerEntity = playerQuery[0]

  let
    (player, spriteList) = playerEntity[Player, PlayerSpriteList]
  let sprite = spriteList.spriteTable[player.state]

  if playerEntity[Sprite] != sprite:
    sprite.currentIndex = 0
    playerEntity[Sprite] = sprite

proc rotateSpriteIndex(
    playerQuery: [All[Player]],
    fpsManager: Resource[FPSManager]
) {.system.} =
  let
    playerEntity = playerQuery[0]
    (player, sprite) = playerEntity[Player, Sprite]

  let interval = case player.state
    of Idle: fpsManager.interval(12)
    of Running: fpsManager.interval(8)
    of Rolling: fpsManager.interval(4)
    of Jumping: fpsManager.interval(12)

  sprite.rotateIndex(interval)

proc changePlayerState(
    playerQuery: [All[Player]],
    keyboardEvent: Event[KeyboardEvent]
) {.system.} =
  let
    playerEntity = playerQuery[0]
    (player, sprite) = playerEntity[Player, Sprite]

  if player.state == Rolling:
    if sprite.currentIndex == 7:
      player.state = Idle
    return

  for e in keyboardEvent:
    if e.isPressed(K_Space):
      if not player.onGround:
        continue

      if player.state in {Idle, Running}:
        player.state = Jumping
      return

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

proc playerAction(
    playerQuery: [All[Player]],
) {.system.} =
  let
    playerEntity = playerQuery[0]
    player = playerEntity[Player]
    (tf, rb, status) = playerEntity[
      Transform, Rigidbody,
      Status
    ]

  case player.state
  of Idle:
    discard

  of Running:
    case player.direction
    of Right:
      tf.scale.x = tf.scale.x.abs
      tf.translate(x = status.speed)
    of Left:
      tf.scale.x = -tf.scale.x.abs
      tf.translate(x = -status.speed)

  of Rolling:
    case player.direction
    of Right:
      tf.scale.x = tf.scale.x.abs
      tf.translate(x = status.speed * 2)
    of Left:
      tf.scale.x = -tf.scale.x.abs
      tf.translate(x = -status.speed * 2)

  of Jumping:
    rb.velocity.y -= status.jump * 10
    player.state = Idle

proc scroll(
    playerQuery: [All[Player]],
    cameraQuery: [All[Camera]]
) {.system.} =
  let
    playerEntity = playerQuery[0]
    cameraEntity = cameraQuery[0]
    (transform, sprite) = playerEntity[Transform, Sprite]
    (camera, cameraTransform) = cameraEntity[Camera, Transform]

    renderedSpriteSize = sprite.spriteCentralSize.x * transform.scale.x.abs
    playerPos = transform.position.x + renderedSpriteSize

    cameraCentralSize = camera.centralSize

  # Go right
  if playerPos > cameraTransform.position.x + cameraCentralSize.x:
    if cameraTransform.position.x + camera.size.x < 2000:
      cameraTransform.position.x = playerPos - cameraCentralSize.x

  # Go left
  if playerPos < cameraTransform.position.x + cameraCentralSize.x:
    if cameraTransform.position.x > 0:
      cameraTransform.position.x = playerPos - cameraCentralSize.x

let app = Application.new()

app.loadPluginGroup(DefaultPlugins)

app.loadPlugin(PhysicsPlugin)

app.start:
  world.registerStartupSystems(setup)
  world.registerSystems(pollEvent)
  world.registerSystems(
    playerLand,
    updateSprite,
    rotateSpriteIndex,
    changePlayerState,
    playerAction,
  )
  world.registerSystems(scroll)


import
  std/[colors, lenientops, random, sugar],
  ../../src/saohime,
  ../../src/saohime/default_plugins,
  ./physics/physics

type
  Player = ref object
    state: PlayerState
    direction: PlayerDirection

  PlayerState = enum
    Idle
    Jumping
    Running
    Rolling

  PlayerDirection = enum
    Left
    Right

  PlayerSpriteList = ref object
    spriteTable: array[PlayerState, Sprite]

proc setup(assetManager: Resource[AssetManager]) {.system.} =
  assetManager.loadIcon("example_app_icon.png")
  let texture = assetManager.loadTexture("knight.png")

  let spriteSheet = SpriteSheet.new(
    texture.getSize(),
    columnLen = 8,
    rowLen = 8
  )

  let
    idleSprite = spriteSheet[0, 4]
    runningSprite = spriteSheet[2..3]
    rollingSprite = spriteSheet[5]

  let spriteList = PlayerSpriteList(
    spriteTable: [idleSprite, idleSprite, runningSprite, rollingSprite]
  )

  block:
    let knightScale = Vector.new(3f, 3f)
    let knight = commands.create()
      .attach(Player(state: Idle, direction: Right))
      .SpriteBundle(texture, idleSprite)
      .attach(spriteList)
      .attach(Transform.new(
        x = 50, y = 150,
        scale = knightScale
      ))
      .attach(Rigidbody.new(mass = 20, useGravity = true))
      .attach(RectangleCollider.new(map(
        idleSprite.spriteSize, knightScale, (a, b: float) => a * b
      )))

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
    .attach(Rigidbody.new(mass = 100, useGravity = false))
    .attach(RectangleCollider.new(Vector.new(2000, 200)))

proc pollEvent(appEvent: Event[ApplicationEvent]) {.system.} =
  for e in appEvent:
    let app = commands.getResource(Application)
    app.terminate()

proc playerLand(
    playerQuery: [All[Player]],
    collision: Event[CollisionEvent]
) {.system.} =
  for event in collision:
    let
      e1 = commands.getEntity(event.entityId1)
      e2 = commands.getEntity(event.entityId2)
    for player in playerQuery:
      if player.get(Player).state == Jumping:
        return

      if e1.id == player.id:
        if event.normal.y == 1f:
          let rb = player.get(Rigidbody)
          if rb.velocity.y > 0:
            rb.velocity.y = 0
          if rb.force.y > 0:
            echo rb.force
            rb.force.y = 0

      elif e2.id == player.id:
        if event.normal.y == -1f:
          let rb = player.get(Rigidbody)
          if rb.velocity.y > 0:
            rb.velocity.y = 0
          if rb.force.y > 0:
            echo rb.force
            rb.force.y = 0

proc updateSprite(entities: [All[Player]]) {.system.} =
  for entity in entities:
    let
      player = entity.get(Player)
      spriteList = entity.get(PlayerSpriteList)
    let sprite = spriteList.spriteTable[player.state]
    if entity[Sprite] != sprite:
      sprite.currentIndex = 0
      entity[Sprite] = sprite

proc rotateSpriteIndex(
    entities: [All[Player, Sprite]],
    fpsManager: Resource[FPSManager]
) {.system.} =
  for player, sprite in each(entities, [Player, Sprite]):
    let interval = case player.state
      of Idle: fpsManager.interval(12)
      of Running: fpsManager.interval(8)
      of Rolling: fpsManager.interval(4)
      of Jumping: fpsManager.interval(12)

    sprite.rotateIndex(interval)

proc changePlayerState(
    entities: [All[Player]],
    keyboardEvent: Event[KeyboardEvent]
) {.system.} =
  for player, sprite in each(entities, [Player, Sprite]):
    if player.state == Rolling:
      if sprite.currentIndex == 7:
        player.state = Idle
      return

    for e in keyboardEvent:
      if e.isDown(K_Space):
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

proc playerMove(
    entities: [All[Player]],
) {.system.} =
  for player, tf, rb in each(entities, [Player, Transform, Rigidbody]):
    case player.state
    of Idle:
      discard

    of Running:
      case player.direction
      of Right:
        tf.scale.x = tf.scale.x.abs
        tf.translate(x = 3)
      of Left:
        tf.scale.x = -tf.scale.x.abs
        tf.translate(x = -3)

    of Rolling:
      case player.direction
      of Right:
        tf.scale.x = tf.scale.x.abs
        tf.translate(x = 6)
      of Left:
        tf.scale.x = -tf.scale.x.abs
        tf.translate(x = -6)

    of Jumping:
      # rb.addForce(y = -300)
      rb.velocity.y -= 25
      player.state = Idle

proc scroll(
    entities: [All[Player]],
    cameraQuery: [All[Camera]]
) {.system.} =
  for transform, sprite in each(entities, [Transform, Sprite]):
    let renderedSpriteSize = sprite.spriteCentralSize.x * transform.scale.x.abs
    let playerPos = transform.position.x + renderedSpriteSize
    for camera, cameraTransform in each(cameraQuery, [Camera, Transform]):
      let cameraCentralSize = camera.centralSize
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
    playerMove,
  )
  world.registerSystems(scroll)


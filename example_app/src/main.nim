import
  std/[colors, lenientops, random, sugar],
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

proc setup(assetManager: Resource[AssetManager]) {.system.} =
  commands.updateResource(Gravity(g: 45))
  assetManager.loadIcon("example_app_icon.png")

  block:
    let
      texture = assetManager.loadTexture("knight.png")
      jumpSound = assetManager.loadSound("jump.wav")

      spriteSheet = SpriteSheet.new(
        texture.getSize(),
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
      .attach(SoundSpeaker.new(jumpSound))

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
    player = playerEntity[Player]
    spriteList = playerEntity[PlayerSpriteList]
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
    player = playerEntity[Player]
    sprite = playerEntity[Sprite]

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
    player = playerEntity[Player]
    sprite = playerEntity[Sprite]

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

proc playerMove(
    playerQuery: [All[Player]],
) {.system.} =
  let
    playerEntity = playerQuery[0]
    player = playerEntity[Player]
    tf = playerEntity[Transform]
    rb = playerEntity[Rigidbody]
    speaker = playerEntity[SoundSpeaker]

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
    rb.velocity.y -= 250
    player.state = Idle
    speaker.play()

proc scroll(
    playerQuery: [All[Player]],
    cameraQuery: [All[Camera]]
) {.system.} =
  let
    playerEntity = playerQuery[0]
    transform = playerEntity[Transform]
    sprite = playerEntity[Sprite]
    cameraEntity = cameraQuery[0]
    camera = cameraEntity[Camera]
    cameraTransform = cameraEntity[Transform]

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
    playerMove,
  )
  world.registerSystems(scroll)


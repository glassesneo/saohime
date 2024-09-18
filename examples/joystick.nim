import
  std/colors,
  ../src/saohime,
  ../src/saohime/default_plugins

type Player = ref object

proc setup(
    renderer: Resource[Renderer],
    joystickManager: Resource[JoystickManager]
) {.system.} =
  let connectResult = joystickManager.connect(0)
  if connectResult.isOk:
    echo "======================"
    echo "Device connected"
    echo "======================"
    let joystick = connectResult.value
    joystickManager[joystick].deadZone = 10000
    commands.create()
      .attach(joystick)
  else:
    echo "======================"
    echo "No device available"
    echo "======================"

  let rectangleTexture = renderer.createRectangleTexture(
    colBlue.toSaohimeColor(),
    size = Vector.new(50f, 50f)
  )
  let rectangle = commands.create()
    .ImageBundle(rectangleTexture, renderingOrder = 5)
    .attach(Transform.new(
      x = 200, y = 400
    ))
    .attach(Player())

proc pollEvent(appEvent: Event[ApplicationEvent]) {.system.} =
  for e in appEvent:
    let app = commands.getResource(Application)
    app.terminate()

proc inputJoystick(
    renderer: Resource[Renderer],
    joystickManager: Resource[JoystickManager],
    joystickQuery: [All[JoystickController]],
    rectangleQuery: [All[Player, Image, Transform]]
) {.system.} =
  for _, tf in rectangleQuery[Transform]:
    for _, joystick in joystickQuery[JoystickController]:
      let input = joystickManager[joystick]

      if input.direction != ZeroVector:
        let speed = input.values.normalized() * 4
        echo speed
        tf.position += speed

      if input.heldFrameList[0] == 1:
        let rectangleTexture = renderer.createRectangleTexture(
          colOrange.toSaohimeColor(),
          size = Vector.new(50f, 50f)
        )
        commands.create()
          .ImageBundle(rectangleTexture, renderingOrder = 4)
          .attach(Transform.new(position = tf.position))

let app = Application.new()

app.loadPluginGroup(DefaultPlugins)


app.start:
  world.registerStartupSystems(setup)
  world.registerSystems(pollEvent)
  world.registerSystems(inputJoystick)


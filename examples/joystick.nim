import
  std/colors,
  ../src/saohime,
  ../src/saohime/default_plugins

type Player = ref object

proc setup(
    renderer: Resource[Renderer],
    controllerManager: Resource[ControllerManager]
) {.system.} =
  let device = ControllerDevice.new(index = 0, deadZone = 15000)
  controllerManager.register(device)
  echo "======================"
  echo "Device connected"
  echo "======================"
  commands.create()
    .attach(device)

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
    deviceQuery: [All[ControllerDevice]],
    rectangleQuery: [All[Player, Image, Transform]],
    cameraQuery: [All[Camera]]
) {.system.} =
  let tf = rectangleQuery[0].get(Transform)
  let cameraTf = cameraQuery[0].get(Transform)
  for _, device in deviceQuery[ControllerDevice]:
    let input = device.input

    if input.leftStickDirection != ZeroVector:
      let speed = input.leftStickMotion.normalized() * 4
      # move blue rectangle with left stick
      tf.position += speed

    if input.rightStickDirection != ZeroVector:
      let speed = input.rightStickMotion.normalized() * 4
      # move camera with right stick
      cameraTf.position += speed

    if input.heldFrameList[SDLControllerButtonA] == 1:
      let rectangleTexture = renderer.createRectangleTexture(
        colOrange.toSaohimeColor(),
        size = Vector.new(50f, 50f)
      )
      commands.create()
        .ImageBundle(rectangleTexture, renderingOrder = 4)
        .attach(Transform.new(position = tf.position))

    if SDLControllerButtonDPadUp in input.downButtonSet:
      echo "pressed"

let app = Application.new()

app.loadPluginGroup(DefaultPlugins)


app.start:
  world.registerStartupSystems(setup)
  world.registerSystems(pollEvent)
  world.registerSystems(inputJoystick)


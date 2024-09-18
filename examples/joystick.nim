import
  ../src/saohime,
  ../src/saohime/default_plugins

proc setup(joystickManager: Resource[JoystickManager]) {.system.} =
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

proc pollEvent(appEvent: Event[ApplicationEvent]) {.system.} =
  for e in appEvent:
    let app = commands.getResource(Application)
    app.terminate()

proc printJoystick(
    joystickManager: Resource[JoystickManager],
    joystickQuery: [All[JoystickController]]
) {.system.} =
  for _, joystick in joystickQuery[JoystickController]:
    let input = joystickManager[joystick]

    if input.direction == ZeroVector:
      continue

    echo input.values.heading()

let app = Application.new()

app.loadPluginGroup(DefaultPlugins)


app.start:
  world.registerStartupSystems(setup)
  world.registerSystems(pollEvent)
  world.registerSystems(printJoystick)


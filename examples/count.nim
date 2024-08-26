import
  std/[colors, packedsets],
  ../src/saohime,
  ../src/saohime/default_plugins

type Time = ref object
  elapsedTime: float

proc pollEvent(
    appEvent: Event[ApplicationEvent],
    mouseEvent: Event[MouseButtonEvent],
) {.system.} =
  for e in appEvent:
    let app = commands.getResource(Application)
    app.terminate()

  for e in mouseEvent:
    if e.isPressed(ButtonLeft):
      let mousePosition = e.position
      commands.create()
        .withBundle((
          Circle.new(35),
          Transform.new(x = mousePosition.x, mousePosition.y),
          Material.new(colOrange.toSaohimeColor, SaohimeColor.new(a = 0))
        ))

proc settings(renderer: Resource[Renderer]) {.system.} =
  renderer.setDrawBlendMode(BlendModeBlend)

proc counter(
    time: Resource[Time],
    fpsManager: Resource[FPSManager]
) {.system.} =
  time.elapsedTime += fpsManager.deltaTime

  let interval = fpsManager.interval(60)
  if interval.trigger():
    echo time.elapsedTime

let app = Application.new()

app.loadPluginGroup(DefaultPlugins)


app.start:
  world.registerStartupSystems(settings)
  world.registerSystems(pollEvent, counter)
  world.addResource(Time(elapsedTime: 0))


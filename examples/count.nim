import
  std/[colors, math],
  ../src/saohime,
  ../src/saohime/default_plugins

type Time = ref object
  currentTime: int
  count: uint
  elapsedTime: float

proc pollEvent(
    appEvent: Event[ApplicationEvent],
    mouseEvent: Event[MouseEvent],
) {.system.} =
  defer:
    mouseEvent.clearQueue()

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
  time.count += 1
  time.elapsedTime += fpsManager.deltaTime

  if time.count == fpsManager.fps:
    echo time.elapsedTime
    time.count = 0

let app = Application.new()

app.loadPluginGroup(DefaultPlugins.new())


app.start:
  world.registerStartupSystems(settings)
  world.registerSystems(pollEvent, counter)
  world.addResource(Time(currentTime: 0, count: 0, elapsedTime: 0))
  world.updateResource(FPSManager(fps: 120))


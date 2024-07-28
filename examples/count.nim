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
    mouse: Resource[MouseInput]
) {.system.} =
  for e in appEvent:
    let app = commands.getResource(Application)
    app.terminate()

  for e in mouseEvent:
    if e.eventType == MouseEventType.MouseButtonDown:
      if e.button == ButtonLeft:
        commands.create()
          .withBundle((
            Circle.new(35),
            Transform.new(x = mouse.x.float, mouse.y.float),
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

let app = Application.new(title = "sample")

app.loadPluginGroup(DefaultPlugins.new())


app.start:
  world.registerStartupSystems(settings)
  world.registerSystems(pollEvent, counter)
  world.addResource(Time(currentTime: 0, count: 0, elapsedTime: 0))
  world.updateResource(FPSManager(fps: 120))


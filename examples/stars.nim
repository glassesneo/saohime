import
  std/[colors, random],
  ../src/saohime,
  ../src/saohime/default_plugins

type Time = ref object
  currentTime: int
  count: uint
  elapsedTime: float

proc pollEvent(
    entities: [All[Circle, Transform, Material]],
    appEvent: Event[ApplicationEvent],
    mouseEvent: Event[MouseButtonEvent],
) {.system.} =
  for e in appEvent:
    let app = commands.getResource(Application)
    app.terminate()

  for e in mouseEvent:
    if e.isPressed(ButtonLeft):
      for _, circle, material in entities[Circle, Material]:
        circle.radius *= rand(0.01..2.0)
        material.fill.r = rand(255)
        material.fill.g = rand(255)
        material.fill.b = rand(255)

proc settings(renderer: Resource[Renderer]) {.system.} =
  randomize()
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

  if time.count mod 2 == 0:
    let
      x = rand(640f)
      y = rand(480f)
      length = time.count.int / 5
    # commands.create()
    #   .withBundle((
    #     Circle.new(radius = length),
    #     Transform.new(x = x.float, y = y.float),
    #     Material.new(colOrange.toSaohimeColor, SaohimeColor.new(a = 0))
    #   ))
    commands.create()
      .withBundle((
        Circle.new(radius = length),
        Transform.new(x = x, y = y),
        Material.new(colOrange.toSaohimeColor, SaohimeColor.new(a = 0))
      ))

let app = Application.new()

app.loadPluginGroup(DefaultPlugins)


app.start:
  world.registerStartupSystems(settings)
  world.registerSystems(pollEvent, counter)
  world.addResource(Time(currentTime: 0, count: 0, elapsedTime: 0))
  world.updateResource(FPSManager(fps: 60))


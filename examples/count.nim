import
  std/[colors, math],
  ../src/saohime,
  ../src/saohime/default_plugins

type Time = ref object
  currentTime: int
  count: uint
  elapsedTime: float

proc pollEvent {.system.} =
  let listener = commands.getResource(EventListener)
  let mouse = commands.getResource(MouseInput)

  while listener.pollEvent():
    if listener.checkQuitEvent():
      let app = commands.getResource(Application)
      app.terminate()

    if listener.checkEvent(KeyDown):
      echo listener.currentKeyName()

    if listener.checkEvent(MouseButtonDown):
      if mouse.isDown(ButtonLeft):
        commands.create()
          .withBundle((
            Circle.new(35),
            Transform.new(x = mouse.x.float, mouse.y.float),
            Material.new(colOrange.toSaohimeColor, SaohimeColor.new(a = 0))
          ))

proc settings {.system.} =
  commands.getResource(Renderer).setDrawBlendMode(BlendModeBlend)

proc counter {.system.} =
  let time = commands.getResource(Time)
  let fpsManager = commands.getResource(FPSManager)
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

  let point = world.create()
    .withBundle((
      Point.new(),
      Transform.new(x = 100, y = 150, scale = Vector.new(1, 5)),
      Material.new(fill = colRed.toSaohimeColor())
    ))

  let line = world.create()
    .withBundle((
      Line.new(Vector.new(50, 50)),
      Transform.new(x = 200, y = 100, scale = Vector.new(1, 4)),
      Material.new(fill = colOrange.toSaohimeColor())
    ))

  let rect = world.create()
    .withBundle((
      Rectangle.new(Vector.new(50, 50)),
      Transform.new(x = 200, y = 100, scale = Vector.new(1, 4)),
      Material.new(SaohimeColor.new(a = 0), colBlue.toSaohimeColor())
    ))

  let circle1 = world.create()
    .withBundle((
      Circle.new(35),
      Transform.new(x = 400, y = 300, scale = Vector.new(1, 2)),
      Material.new(colOrange.toSaohimeColor, SaohimeColor.new(a = 0))
    ))

  let circle2 = world.create()
    .withBundle((
      Circle.new(10),
      Transform.new(x = 400, y = 300, scale = Vector.new(2, 1)),
      Material.new(SaohimeColor.new(a = 0), colBlue.toSaohimeColor())
    ))



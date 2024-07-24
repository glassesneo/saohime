import
  std/[colors, lenientops, random],
  ../src/saohime,
  ../src/saohime/default_plugins

type Time = ref object
  currentTime: int
  count: uint
  elapsedTime: float

proc pollEvent(All = [Rectangle, Transform, Material]) {.system.} =
  let listener = commands.getResource(EventListener)
  let mouse = commands.getResource(MouseInput)

  while listener.pollEvent():
    if listener.checkQuitEvent():
      let app = commands.getResource(Application)
      app.terminate()

    if listener.checkEvent(MouseButtonDown):
      if mouse.isDown(ButtonLeft):
        for transform, material in each(entities, [Transform, Material]):
          transform.scale = Vector.new(
            x = rand(1f..5f),
            y = rand(1f..5f)
          )
          material.fill.r = rand(255)
          material.fill.g = rand(255)
          material.fill.b = rand(255)

proc settings {.system.} =
  randomize()
  commands.getResource(Renderer).setDrawBlendMode(BlendModeBlend)

proc counter {.system.} =
  let time = commands.getResource(Time)
  let fpsManager = commands.getResource(FPSManager)
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
        Rectangle.new(Vector.new(x = length, y = length)),
        Transform.new(x = x, y = y),
        Material.new(colOrange.toSaohimeColor, SaohimeColor.new(a = 0))
      ))

let app = Application.new(title = "sample")

app.loadPluginGroup(DefaultPlugins.new())


app.start:
  world.registerStartupSystems(settings)
  world.registerSystems(pollEvent, counter)
  world.addResource(Time(currentTime: 0, count: 0, elapsedTime: 0))
  world.updateResource(FPSManager(fps: 60))


import
  std/[colors, math],
  ../src/saohime,
  ../src/saohime/default_plugins

proc pollEvent(appEvent: Event[ApplicationEvent]) {.system.} =
  for e in appEvent:
    let app = commands.getResource(Application)
    app.terminate()

proc setup {.system.} =
  let floor1 = commands.create()
    .attach(Rectangle.new(320, 200))
    .attach(Transform.new(x = 0, y = 200))
    .attach(Material.new(
      color = colLightGrey.toSaohimeColor()
    ))

  let floor2 = commands.create()
    .attach(Rectangle.new(320, 200))
    .attach(Transform.new(x = 320, y = 200))
    .attach(Material.new(
      color = colYellow.toSaohimeColor()
    ))

  let ball = commands.create()
    .attach(Circle.new(20))
    .attach(Transform.new(x = 320, y = 180))
    .attach(Material.new(
      color = colBlue.toSaohimeColor()
    ))

proc scroll(
    camera: Resource[Camera],
    fpsManager: Resource[FPSManager]
) {.system.} =
  let period = fpsManager.frameCount.int / 60
  let v = sin(period * PI) / 50
  camera.zoom += Vector.new(v, v)

let app = Application.new()

app.loadPluginGroup(DefaultPlugins)


app.start:
  world.registerSystems(pollEvent, scroll)
  world.registerStartupSystems(setup)


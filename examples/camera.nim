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
    .attach(Rectangle.new(300, 200))
    .attach(Transform.new(x = 100, y = 200))
    .attach(Material.new(
      color = colLightGrey.toSaohimeColor()
    ))

  let floor2 = commands.create()
    .attach(Rectangle.new(300, 200))
    .attach(Transform.new(x = 400, y = 200))
    .attach(Material.new(
      color = colYellow.toSaohimeColor()
    ))

proc scroll(
    cameraQuery: [All[Camera]],
    fpsManager: Resource[FPSManager]
) {.system.} =
  for transform in each(cameraQuery, [Transform]):
    let period = fpsManager.frameCount.int / 40
    let v = sin(period * PI)
    transform.position += Vector.new(v * 10, 0)

let app = Application.new()

app.loadPluginGroup(DefaultPlugins)


app.start:
  world.registerSystems(pollEvent, scroll)
  world.registerStartupSystems(setup)


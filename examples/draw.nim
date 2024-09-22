import
  std/[colors],
  ../src/saohime,
  ../src/saohime/default_plugins

proc settings(renderer: Resource[Renderer]) {.system.} =
  renderer.setDrawBlendMode(BlendModeBlend)

proc pollEvent(appEvent: Event[ApplicationEvent]) {.system.} =
  for e in appEvent:
    let app = commands.getResource(Application)
    app.terminate()

let app = Application.new()

app.loadPluginGroup(DefaultPlugins)


app.start:
  world.registerStartupSystems(settings)
  world.registerSystems(pollEvent)

  let point = world.create().PointBundle(
      color = colRed.toSaohimeColor()
    ).attach(Transform.new(
      x = 100, y = 150,
      scale = Vector.new(1, 5),
    ))

  let line = world.create().LineBundle(
      vector = Vector.new(50, 50),
      color = colOrange.toSaohimeColor()
    ).attach(Transform.new(
      x = 200, y = 100,
      scale = Vector.new(1, 4),
    ))

  let rect = world.create().RectangleBundle(
      size = Vector.new(50, 50),
      border = colBlue.toSaohimeColor()
    ).attach(Transform.new(
      x = 200, y = 100,
      scale = Vector.new(1, 4)
    ))

  let circle1 = world.create().CircleBundle(
      radius = 35,
      bg = colOrange.toSaohimeColor
    ).attach(Transform.new(
      x = 400, y = 300,
      scale = Vector.new(1, 2)
    ))

  let circle2 = world.create().CircleBundle(
      radius = 10,
      border = colBlue.toSaohimeColor
    ).attach(Transform.new(
      x = 400, y = 300,
      scale = Vector.new(2, 1)
    ))


import
  std/[colors],
  ../src/saohime,
  ../src/saohime/default_plugins

proc settings(renderer: Resource[Renderer]) {.system.} =
  renderer.setDrawBlendMode(BlendModeBlend)

proc pollEvent(listener: Resource[EventListener]) {.system.} =
  while listener.pollEvent():
    if listener.checkQuitEvent():
      let app = commands.getResource(Application)
      app.terminate()

let app = Application.new(title = "sample")

app.loadPluginGroup(DefaultPlugins.new())


app.start:
  world.updateResource(SDL2Handler(mainFlags: InitVideo))
  world.registerStartupSystems(settings)
  world.registerSystems(pollEvent)

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


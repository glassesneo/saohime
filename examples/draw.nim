import
  std/[colors],
  ../src/saohime,
  ../src/saohime/default_plugins

proc pollEvent {.system.} =
  let listener = commands.getResource(EventListener)
  while listener.pollEvent():
    if listener.checkQuitEvent():
      let app = commands.getResource(Application)
      app.deactivateMainLoop()

let app = Application.new(title = "sample")

app.registerPluginGroup(DefaultPlugins())


app.start:
  world.updateResource(SDL2Handler(mainFlags: InitVideo))
  world.registerSystems(pollEvent)
  let rect = world.create()
    .attach(Rectangle.new(50, 60))
    .attach(Transform.new(200, 100))
    .attach(Material.new(filled = false))

  let line = world.create()
    .attach(Line.new(50, 60))
    .attach(Transform.new(200, 100))
    .attach(Material.new())

  let point = world.create()
    .attach(Point.new())
    .attach(Transform.new(100, 150))
    .attach(Material.new())


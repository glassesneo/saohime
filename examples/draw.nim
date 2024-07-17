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

app.loadPluginGroup(DefaultPlugins.new())


app.start:
  world.updateResource(SDL2Handler(mainFlags: InitVideo))
  world.registerSystems(pollEvent)
  let rect = world.create()
    .objectBundle(x = 200, y = 100, filled = false)
    .attach(Rectangle.new(50, 60))

  let line = world.create()
    .objectBundle(x = 200, y = 100, color = colOrange)
    .attach(Line.new(50, 60))

  let point = world.create()
    .objectBundle(x = 100, y = 150, color = colOrange)
    .attach(Point.new())


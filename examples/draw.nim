import
  std/[colors],
  ../src/saohime,
  ../src/saohime/default_plugins

proc pollEvent {.system.} =
  let listener = commands.getResource(EventListener)
  while listener.pollEvent():
    if listener.checkQuitEvent():
      let app = commands.getResource(Application)
      app.terminate()

let app = Application.new(title = "sample")

app.loadPluginGroup(DefaultPlugins.new())


app.start:
  world.updateResource(SDL2Handler(mainFlags: InitVideo))
  world.registerSystems(pollEvent)

  let point = world.create()
    .objectBundle(x = 100, y = 150, color = colOrange)
    .attach(Point.new())

  let line = world.create()
    .objectBundle(x = 200, y = 100, color = colOrange)
    .attach(Line.new(50, 60))

  let rect = world.create()
    .objectBundle(x = 200, y = 100, filled = false)
    .attach(Rectangle.new(50, 60))

  let circle1 = world.create()
    .objectBundle(x = 400, y = 300, filled = true)
    .attach(Circle.new(30))

  let circle2 = world.create()
    .objectBundle(x = 400, y = 300, color = colBlue, filled = true)
    .attach(Circle.new(10))


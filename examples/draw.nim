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
    .objectBundle(x = 100, y = 150, scale = Vector.new(1, 5))
    .attach(Point.new())

  let line = world.create()
    .objectBundle(x = 200, y = 100, scale = Vector.new(1, 4), color = colOrange)
    .attach(Line.new(50, 50))

  let rect = world.create()
    .objectBundle(x = 200, y = 100, scale = Vector.new(1, 4), filled = false)
    .attach(Rectangle.new(50, 50))

  let circle1 = world.create()
    .objectBundle(x = 400, y = 300, scale = Vector.new(1, 2), filled = true)
    .attach(Circle.new(35))

  let circle2 = world.create()
    .objectBundle(x = 400, y = 300, color = colBlue, scale = Vector.new(2, 1), filled = true)
    .attach(Circle.new(10))


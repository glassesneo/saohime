import
  ../src/saohime,
  ../src/saohime/default_plugins

proc pollEvent(listener: Resource[EventListener]) {.system.} =
  while listener.pollEvent():
    if listener.checkQuitEvent():
      let app = commands.getResource(Application)
      app.terminate()

let app = Application.new(title = "sample")

proc load(renderer: Resource[Renderer]) {.system.} =
  let texture = renderer.loadTexture("assets/cat.jpg")

  let cat = commands.create()
    .attach(texture)
    .attach(Transform.new(
      x = 0, y = 0,
      scale = Vector.new(-0.2, -0.2),
      rotation = 0.5
    ))

app.loadPluginGroup(DefaultPlugins.new())


app.start:
  world.updateResource(SDL2Handler(
    mainFlags: InitVideo,
    imageFlags: ImgInitJpg
  ))
  world.updateResource(Window(size: (1000, 500)))
  world.registerSystems(pollEvent)
  world.registerStartupSystems(load)


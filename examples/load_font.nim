import
  ../src/saohime,
  ../src/saohime/default_plugins

proc pollEvent {.system.} =
  let listener = commands.getResource(EventListener)
  while listener.pollEvent():
    if listener.checkQuitEvent():
      let app = commands.getResource(Application)
      app.terminate()

let app = Application.new(title = "sample")

proc load {.system.} =
  let renderer = commands.getResource(Renderer)
  let fontManager = commands.getResource(FontManager)
  let font = fontManager.loadFont("mplus", "assets/MPLUS1p-Regular.ttf")

  let surface = font.textBlended("Sample Text")
  let texture = renderer.createTextureFromSurface(surface)

  let text = commands.create()
    .attach(texture)
    .attach(Transform.new(
      x = 100, y = 100,
      scale = Vector.new(1.2, 1.2),
      rotation = 0.5
    ))

app.loadPluginGroup(DefaultPlugins.new())


app.start:
  world.updateResource(SDL2Handler(
    mainFlags: InitVideo,
  ))
  world.updateResource(Window(size: (1000, 500)))
  world.registerSystems(pollEvent)
  world.registerStartupSystems(load)



import
  ../src/saohime,
  ../src/saohime/default_plugins

proc pollEvent(appEvent: Event[ApplicationEvent]) {.system.} =
  for e in appEvent:
    let app = commands.getResource(Application)
    app.terminate()

let app = Application.new()

proc load(
    renderer: Resource[Renderer],
    assetManager: Resource[AssetManager]
) {.system.} =
  let font = assetManager.loadFont("MPLUS1p-Regular.ttf")

  let surface = font.textBlended("Sample Text")
  let texture = renderer.createTextureFromSurface(surface)

  let text = commands.create()
    .TextBundle(texture)
    .attach(Transform.new(
      x = 100, y = 100,
      scale = Vector.new(1.2, 1.2),
      rotation = 0.5
    ))

app.loadPluginGroup(DefaultPlugins)


app.start:
  world.updateResource(Window(size: (1000, 500)))
  world.registerSystems(pollEvent)
  world.registerStartupSystems(load)


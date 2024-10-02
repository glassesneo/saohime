import
  std/colors,
  ../src/saohime,
  ../src/saohime/default_plugins

proc pollEvent(appEvent: Event[ApplicationEvent]) {.system.} =
  for e in appEvent:
    let app = commands.getResource(Application)
    app.terminate()

proc load(
    assetManager: Resource[AssetManager],
    renderer: Resource[Renderer]
) {.system.} =
  let texture = assetManager[Texture].load(renderer, "cat.jpg")

  let cat = commands.create()
    .ImageBundle(texture)
    .attach(Transform.new(
      x = 0, y = 0,
      scale = Vector.new(0.23, 0.23),
    ))

  let rectangle = commands.create()
    .RectangleBundle(
      colBlue.toSaohimeColor(),
      size = Vector.new(50f, 50f),
      renderingOrder = 5
    )
    .attach(Transform.new(x = 0, y = 0))

let app = Application.new()

app.loadPluginGroup(DefaultPlugins)


app.start:
  world.updateResource(WindowArgs(size: (1000, 500)))
  world.registerSystems(pollEvent)
  world.registerStartupSystems(load)


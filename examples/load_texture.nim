import
  ../src/saohime,
  ../src/saohime/default_plugins

proc pollEvent(appEvent: Event[ApplicationEvent]) {.system.} =
  for e in appEvent:
    let app = commands.getResource(Application)
    app.terminate()

let app = Application.new()

proc load(assetManager: Resource[AssetManager]) {.system.} =
  let texture = assetManager.loadImage("cat.jpg")

  let cat = commands.create()
    .attach(texture)
    .attach(Transform.new(
      x = 0, y = 0,
      scale = Vector.new(-0.2, -0.2),
      rotation = 0.5
    ))

app.loadPluginGroup(DefaultPlugins)


app.start:
  world.updateResource(Window(size: (1000, 500)))
  world.registerSystems(pollEvent)
  world.registerStartupSystems(load)


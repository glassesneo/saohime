import
  ../src/saohime,
  ../src/saohime/default_plugins

proc pollEvent(listener: Resource[EventListener]) {.system.} =
  while listener.pollEvent():
    if listener.checkQuitEvent():
      let app = commands.getResource(Application)
      app.terminate()

let app = Application.new(title = "sample")

app.loadPluginGroup(DefaultPlugins.new())


app.start:
  world.registerSystems(pollEvent)


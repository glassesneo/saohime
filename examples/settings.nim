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

app.loadPluginGroup(DefaultPlugins.new())


app.start:
  world.registerSystems(pollEvent)
  world.updateResource(Window(title: "changed", size: (1000, 500)))


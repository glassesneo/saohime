import
  ../src/saohime,
  ../src/saohime/default_plugins

proc pollEvent {.system.} =
  let listener = commands.getResource(EventListener)
  while listener.pollEvent():
    if listener.checkQuitEvent():
      let app = commands.getResource(Application)
      app.deactivateMainLoop()

let app = Application.new(title = "sample")

app.registerPluginGroup(DefaultPlugins())

app.start:
  world.registerSystems(pollEvent)

import
  ../src/saohime,
  ../src/saohime/default_plugins

proc pollEvent(appEvent: Event[ApplicationEvent]) {.system.} =
  for e in appEvent:
    let app = commands.getResource(Application)
    app.terminate()

let app = Application.new()

app.loadPluginGroup(DefaultPlugins)


app.start:
  world.registerSystems(pollEvent)
  world.updateResource(Window(title: "changed", size: (1000, 500)))


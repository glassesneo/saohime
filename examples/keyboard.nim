import
  ../src/saohime,
  ../src/saohime/default_plugins

proc pollEvent(
    appEvent: Event[ApplicationEvent],
    keyboardEvent: Event[KeyboardEvent]
) {.system.} =
  for e in appEvent:
    let app = commands.getResource(Application)
    app.terminate()

  for e in keyboardEvent:
    if e.isPressed(K_ESCAPE):
      let app = commands.getResource(Application)
      app.terminate()

let app = Application.new(title = "sample")

app.loadPluginGroup(DefaultPlugins.new())


app.start:
  world.registerSystems(pollEvent)


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
    case e.eventType
    of KeyDown:
      if e.key == K_ESCAPE:
        let app = commands.getResource(Application)
        app.terminate()
    else:
      discard

let app = Application.new(title = "sample")

app.loadPluginGroup(DefaultPlugins.new())


app.start:
  world.registerSystems(pollEvent)


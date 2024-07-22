import
  ../src/saohime,
  ../src/saohime/default_plugins

proc pollEvent {.system.} =
  let listener = commands.getResource(EventListener)
  let keyboard = commands.getResource(KeyboardInput)

  while listener.pollEvent():
    if listener.checkQuitEvent():
      let app = commands.getResource(Application)
      app.terminate()

    if listener.checkEvent(KeyDown):
      echo listener.currentKeyName()

  if keyboard.isDown(K_ESCAPE):
    let app = commands.getResource(Application)
    app.terminate()

let app = Application.new(title = "sample")

app.loadPluginGroup(DefaultPlugins.new())


app.start:
  world.registerSystems(pollEvent)

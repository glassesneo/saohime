import
  ../src/saohime,
  ../src/saohime/default_plugins

proc pollEvent {.system.} =
  let listener = commands.getResource(EventListener)
  let mouse = commands.getResource(MouseInput)

  while listener.pollEvent():
    if listener.checkQuitEvent():
      let app = commands.getResource(Application)
      app.terminate()

    if listener.checkEvent(KeyDown):
      echo listener.currentKeyName()

    if listener.checkEvent(MouseButtonDown):
      if mouse.isDown(ButtonLeft):
        commands.create()
          .objectBundle(x = mouse.x.float, y = mouse.y.float, filled = true)
          .attach(Circle.new(20))

let app = Application.new(title = "sample")

app.loadPluginGroup(DefaultPlugins.new())


app.start:
  world.registerSystems(pollEvent)


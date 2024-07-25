import
  std/[colors],
  ../src/saohime,
  ../src/saohime/default_plugins

proc settings(renderer: Resource[Renderer]) {.system.} =
  renderer.setDrawBlendMode(BlendModeBlend)

proc pollEvent(
    listener: Resource[EventListener],
    mouse: Resource[MouseInput]
    ) {.system.} =
  while listener.pollEvent():
    if listener.checkQuitEvent():
      let app = commands.getResource(Application)
      app.terminate()

    if listener.checkEvent(KeyDown):
      echo listener.currentKeyName()

    if listener.checkEvent(MouseButtonDown):
      if mouse.isDown(ButtonLeft):
        commands.create()
          .withBundle((
            Circle.new(35),
            Transform.new(x = mouse.x.float, mouse.y.float),
            Material.new(colOrange.toSaohimeColor, SaohimeColor.new(a = 0))
          ))

let app = Application.new(title = "sample")

app.loadPluginGroup(DefaultPlugins.new())


app.start:
  world.registerStartupSystems(settings)
  world.registerSystems(pollEvent)


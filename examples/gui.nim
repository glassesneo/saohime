import
  std/[colors],
  ../src/saohime,
  ../src/saohime/default_plugins

proc settings(renderer: Resource[Renderer]) {.system.} =
  renderer.setDrawBlendMode(BlendModeBlend)

proc pollEvent(appEvent: Event[ApplicationEvent]) {.system.} =
  for e in appEvent:
    let app = commands.getResource(Application)
    app.terminate()

let app = Application.new()

app.loadPluginGroup(DefaultPlugins)


app.start:
  world.registerStartupSystems(settings)
  world.registerSystems(pollEvent)

  let button1 = world.create()
    .withBundle((
      Button.new(
        text = "Button",
        size = Vector.new(30, 15),
        normalColor = colOrange.toSaohimeColor(),
        pressedColor = colWhite.toSaohimeColor()
      ),
      Transform.new(x = 200, y = 100),
    ))

  let button2 = world.create()
    .withBundle((
      Button.new(
        text = "Button",
        size = Vector.new(30, 15),
        normalColor = colBlue.toSaohimeColor(),
        pressedColor = colWhite.toSaohimeColor()
      ),
      Transform.new(x = 400, y = 100),
    ))


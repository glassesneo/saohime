import
  std/[colors],
  ../src/saohime,
  ../src/saohime/default_plugins

proc settings(renderer: Resource[Renderer]) {.system.} =
  renderer.setDrawBlendMode(BlendModeBlend)

proc pollEvent(
    appEvent: Event[ApplicationEvent],
    mouseEvent: Event[MouseEvent]
    ) {.system.} =
  defer:
    mouseEvent.clearQueue()

  for e in appEvent:
    let app = commands.getResource(Application)
    app.terminate()

  for e in mouseEvent:
    if e.isPressed(ButtonLeft):
      let mousePosition = e.position
      commands.create()
        .withBundle((
          Circle.new(35),
          Transform.new(x = mousePosition.x, mousePosition.y),
          Material.new(colOrange.toSaohimeColor, SaohimeColor.new(a = 0))
        ))

let app = Application.new()

app.loadPluginGroup(DefaultPlugins)


app.start:
  world.registerStartupSystems(settings)
  world.registerSystems(pollEvent)


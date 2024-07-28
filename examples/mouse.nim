import
  std/[colors],
  ../src/saohime,
  ../src/saohime/default_plugins

proc settings(renderer: Resource[Renderer]) {.system.} =
  renderer.setDrawBlendMode(BlendModeBlend)

proc pollEvent(
    mouse: Resource[MouseInput],
    appEvent: Event[ApplicationEvent],
    mouseEvent: Event[MouseEvent]
    ) {.system.} =
  for e in appEvent:
    let app = commands.getResource(Application)
    app.terminate()

  for e in mouseEvent:
    case e.eventType
    of MouseButtonDown:
      if mouse.isDown(ButtonLeft):
        commands.create()
          .withBundle((
            Circle.new(35),
            Transform.new(x = mouse.x.float, mouse.y.float),
            Material.new(colOrange.toSaohimeColor, SaohimeColor.new(a = 0))
          ))

    else:
      discard


let app = Application.new(title = "sample")

app.loadPluginGroup(DefaultPlugins.new())


app.start:
  world.registerStartupSystems(settings)
  world.registerSystems(pollEvent)


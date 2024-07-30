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

proc clicked(
    buttonEvent: Event[ButtonEvent]
) {.system.} =
  for e in buttonEvent:
    if e.actionType == Click:
      let material = commands.getEntity(e.entityId).get(Material)
      material.fill.a -= 20
      echo "clicked"

let app = Application.new(title = "sample")

app.loadPluginGroup(DefaultPlugins.new())


app.start:
  world.registerStartupSystems(settings)
  world.registerSystems(pollEvent, clicked)

  let button1 = world.create()
    .withBundle((
      Button.new("Button", Vector.new(30, 15)),
      Transform.new(x = 200, y = 100),
      Material.new(colOrange.toSaohimeColor(), colWhite.toSaohimeColor())
    ))

  let button2 = world.create()
    .withBundle((
      Button.new("Button", Vector.new(30, 15)),
      Transform.new(x = 400, y = 100),
      Material.new(colBlue.toSaohimeColor(), colWhite.toSaohimeColor())
    ))


import
  std/[random],
  ../src/saohime,
  ../src/saohime/default_plugins

proc setup(renderer: Resource[Renderer]) {.system.} =
  randomize()
  renderer.setDrawBlendMode(BlendModeBlend)

proc pollEvent(appEvent: Event[ApplicationEvent]) {.system.} =
  for event in appEvent:
    if event.eventType == ApplicationEventType.Quit:
      let app = commands.getResource(Application)
      app.terminate()

proc randomCircles(fpsManager: Resource[FPSManager]) {.system.} =
  if fpsManager.frameCount mod 20 == 0:
    let color = SaohimeColor.new(
      r = rand(255),
      g = rand(255),
      b = rand(255),
      a = rand(255),
    )
    color.r = color.r * 2
    color.g = color.g * 2
    color.b = color.b * 2

    commands.create()
      .attach(Circle.new(1))
      .attach(
        Transform.new(x = rand(600f), y = rand(400f), scale = Vector.new(1, 1)),
      )
      .attach(Material.new(color = color))

proc increaseRadius(
    circleQuery: [All[Circle]]
) {.system.} =
  for entity in circleQuery:
    let circle = entity[Circle]
    circle.radius += 1
    if circle.radius > 150:
      entity.delete()

let app = Application.new()

app.loadPluginGroup(DefaultPlugins)


app.start:
  world.registerStartupSystems(setup)
  world.registerSystems(pollEvent, randomCircles, increaseRadius)


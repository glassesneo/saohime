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
      b = 255,
      a = rand(127),
    )

    commands.create()
      .attach(Circle.new(radius = 1))
      .attach(
        Transform.new(x = rand(640f), y = rand(480f), scale = Vector.new(1, 1)),
      )
      .attach(Material.new(color = color))

proc increaseRadius(
    circleQuery: [All[Circle]]
) {.system.} =
  for entity, circle in circleQuery[Circle]:
    circle.radius += 1.2
    if circle.radius > 200:
      entity.delete()

let app = Application.new()

app.loadPluginGroup(DefaultPlugins)

app.start:
  world.registerStartupSystems(setup)
  world.registerSystems(pollEvent, randomCircles, increaseRadius)


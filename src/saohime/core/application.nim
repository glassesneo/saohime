{.push raises: [].}

import
  std/[tables],
  pkg/[ecslib],
  ./plugin

type
  Application* = ref object
    title: string
    world: World
    plugins: OrderedTable[string, PluginTuple]
    mainLoopFlag: bool

proc new*(_: type Application, title: string): Application =
  result = Application(
    title: title,
    mainLoopFlag: true
  )
  let world = World.new()
  world.addResource(result)
  result.world = world

proc loadPlugin*(app: Application, plugin: PluginTuple) {.raises: [Exception].} =
  plugin.build(app.world)

proc loadPluginGroup*(app: Application, group: PluginGroup) {.raises: [Exception].} =
  group.build()
  for plugin in group.plugins:
    app.loadPlugin(plugin)

proc mainLoop*(app: Application) {.raises: [Exception].} =
  while app.mainLoopFlag:
    app.world.runSystems()

proc activateMainLoop*(app: Application) =
  app.mainLoopFlag = true

proc deactivateMainLoop*(app: Application) =
  app.mainLoopFlag = false

template start*(app: Application, body: untyped): untyped =
  block:
    defer:
      app.world.runTerminateSystems()

    let world {.inject.} = app.world
    body

    app.world.runStartupSystems()
    app.mainLoop()

export new


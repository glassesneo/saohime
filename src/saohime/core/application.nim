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

proc registerPlugin*(app: Application, plugin: PluginTuple) =
  app.plugins[plugin.name] = plugin

proc registerPluginGroup*(app: Application, pluginGroup: PluginGroup) =
  pluginGroup.build(app.world)
  for plugin in pluginGroup.group:
    app.registerPlugin(plugin)

proc deletePlugin*(app: Application, pluginName: string) =
  app.plugins.del(pluginName)

proc loadPlugins*(app: Application) {.raises: [Exception].} =
  for plugin in app.plugins.values:
    plugin.build(app.world)

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

    app.loadPlugins()

    let world {.inject.} = app.world
    body

    app.world.runStartupSystems()
    app.mainLoop()

export new


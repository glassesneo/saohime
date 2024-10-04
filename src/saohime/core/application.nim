{.push raises: [].}
import std/[macrocache, macros, os]
import pkg/ecslib

const PluginTable = CacheTable"PluginTable"

type Application* = ref object
  world: World
  appPath*: string
  mainLoopFlag: bool

proc new*(_: type Application): Application {.raises: [OSError].} =
  result = Application(appPath: getAppDir(), mainLoopFlag: true)
  let world = World.new()
  world.addResource(result)
  world.arrangeStageList(["first", "update", "draw", "last"])
  result.world = world

macro loadPlugin*(app: Application, plugin: untyped): untyped =
  let pluginName = plugin.strVal
  if PluginTable.hasKey pluginName:
    error "Plugin" & pluginName & "is already loaded"

  PluginTable[pluginName] = newLit(true)

  result = newStmtList()
  result.add quote do:
    `plugin`().build(`app`.world)

macro loadPluginGroup*(app: Application, group: untyped): untyped =
  result = quote:
    `group`().build(app)

proc terminate*(app: Application) =
  app.mainLoopFlag = false

template start*(app: Application, body: untyped): untyped =
  block:
    defer:
      app.world.runTerminateSystems()

    let world {.inject.} = app.world
    body

    app.world.runStartupSystems()
    while app.mainLoopFlag:
      app.world.runSystems()

export new

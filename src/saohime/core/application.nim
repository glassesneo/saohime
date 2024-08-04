{.push raises: [].}

import
  std/[os, sets],
  pkg/[ecslib],
  ./exceptions,
  ./plugin

type
  Application* = ref object
    title: string
    world: World
    appPath*: string
    mainLoopFlag: bool
    plugins: HashSet[string]

proc new*(
    _: type Application,
    title: string
): Application {.raises: [OSError].} =
  result = Application(
    title: title,
    appPath: getAppDir(),
    mainLoopFlag: true
  )
  let world = World.new()
  world.addResource(result)
  result.world = world

proc loadPlugin*(
    app: Application,
    plugin: PluginTuple
) {.raises: [DuplicatePluginError].} =
  if plugin.name in app.plugins:
    let msg = "Plugin" & plugin.name & "is already loaded"
    raise (ref DuplicatePluginError)(msg: msg)

  plugin.build(app.world)
  app.plugins.incl plugin.name

proc loadPluginGroup*(
    app: Application, group: PluginGroup
) {.raises: [DuplicatePluginError].} =
  group.build()
  for plugin in group.plugins:
    app.loadPlugin(plugin)

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


{.push raises: [].}

import
  std/[os],
  pkg/[ecslib],
  ../../core/application,
  ../render/render,
  ./resources

proc fakeSystem*() {.system.} =
  discard

type
  AssetPlugin* = ref object

proc build*(plugin: AssetPlugin, world: World) {.raises: [KeyError].} =
  let app = world.getResource(Application)
  let renderer = world.getResource(Renderer)
  world.addResource(AssetManager.new(renderer, app.appPath/"assets"))
  world.registerStartupSystems(fakeSystem)

export
  resources


{.push raises: [].}

import
  std/[os],
  pkg/[ecslib],
  ../../core/application,
  ../render/render,
  ../window/window,
  ./resources

proc fakeSystem*() {.system.} =
  discard

type
  AssetPlugin* = ref object

proc build*(plugin: AssetPlugin, world: World) {.raises: [KeyError].} =
  let
    app = world.getResource(Application)
    window = world.getResource(Window)
    renderer = world.getResource(Renderer)
  world.addResource(AssetManager.new(window, renderer, app.appPath/"assets"))
  world.registerStartupSystems(fakeSystem)

export
  resources


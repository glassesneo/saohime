import
  std/[os],
  pkg/[ecslib],
  ../../core/application,
  ../render/render,
  ../window/window,
  ./resources

type
  AssetPlugin* = ref object

proc build*(plugin: AssetPlugin, world: World) =
  let
    app = world.getResource(Application)
    window = world.getResource(Window)
    renderer = world.getResource(Renderer)
  world.addResource(AssetManager.new(window, renderer, app.appPath/"assets"))

export
  resources


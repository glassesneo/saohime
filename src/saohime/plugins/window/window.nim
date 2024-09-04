import
  std/[os],
  pkg/[ecslib],
  ./resources,
  ./systems
import pkg/sdl2 except createWindow, destroyWindow

type WindowPlugin* = ref object

proc build*(plugin: WindowPlugin, world: World) =
  world.addResource(Window.new(
    title = getAppFileName().extractFileName(),
    width = 640,
    height = 480,
    flags = SdlWindowShown
  ))
  world.registerStartupSystems(createWindow)
  world.registerTerminateSystems(destroyWindow)

export
  resources,
  systems


import
  std/os,
  pkg/ecslib,
  ./resources,
  ./systems
import pkg/sdl2 except destroyWindow

type WindowPlugin* = ref object

proc build*(plugin: WindowPlugin, world: World) =
  world.addResource(WindowArgs.new(
    title = getAppFileName().extractFileName(),
    position = (SDLWindowPosCentered.int, SDLWindowPosCentered.int),
    size = (640, 480),
    flags = SdlWindowShown
  ))

  world.registerStartupSystems(createSaohimeWindow)
  world.registerTerminateSystems(destroyWindow)

export
  resources,
  systems


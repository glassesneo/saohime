import std/os
import pkg/ecslib
import pkg/sdl2 except destroyWindow
import ./[resources, systems]

type WindowPlugin* = ref object

proc build*(plugin: WindowPlugin, world: World) =
  world.addResource(
    WindowArgs.new(
      title = getAppFileName().extractFileName(),
      position = (SDLWindowPosCentered.int, SDLWindowPosCentered.int),
      size = (640, 480),
      flags = SdlWindowShown,
    )
  )

  world.registerStartupSystems(createSaohimeWindow)
  world.registerTerminateSystems(destroyWindow)

export resources, systems

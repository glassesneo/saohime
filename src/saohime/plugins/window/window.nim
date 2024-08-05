{.push raises: [].}

import
  std/[os],
  pkg/[ecslib],
  ./resources,
  ./systems
import pkg/sdl2 except createWindow, destroyWindow

type WindowPlugin* = ref object
  name*: string

proc new*(_: type WindowPlugin): WindowPlugin =
  return WindowPlugin(name: "WindowPlugin")

proc build*(plugin: WindowPlugin, world: World) {.raises: [OSError].} =
  world.addResource(Window.new(
    title = getAppFileName().extractFileName(),
    width = 640,
    height = 480,
    flags = SdlWindowResizable or SdlWindowShown
  ))
  world.registerStartupSystems(createWindow)
  world.registerTerminateSystems(destroyWindow)

export new
export
  resources,
  systems


{.push raises: [].}

import
  std/[importutils],
  pkg/[ecslib],
  ../../core/[application],
  ./resources,
  ./systems
import pkg/sdl2 except createWindow, destroyWindow

type WindowPlugin* = ref object
  name*: string

proc new*(_: type WindowPlugin): WindowPlugin =
  return WindowPlugin(name: "WindowPlugin")

proc build*(plugin: WindowPlugin, world: World) {.raises: [KeyError].} =
  privateAccess(Application)
  let app = world.getResource(Application)
  world.addResource(Window.new(
    title = app.title,
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


{.push raises: [].}

import
  pkg/[ecslib, sdl2, sdl2/image],
  ./resources,
  ./systems

type SDL2Plugin* = ref object

proc build*(plugin: SDL2Plugin, world: World) =
  world.addResource(SDL2Handler.new(
    mainFlags = InitVideo,
    imageFlags = ImgInitJpg or ImgInitPng,
  ))
  world.registerStartupSystems(initializeSDL2)
  world.registerTerminateSystems(quitSDL2)

export
  resources,
  systems


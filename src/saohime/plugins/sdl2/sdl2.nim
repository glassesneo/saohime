{.push raises: [].}

import
  pkg/[ecslib],
  ./resources,
  ./systems

type SDL2Plugin* = ref object
  name*: string

proc new*(_: type SDL2Plugin): SDL2Plugin =
  return SDL2Plugin(name: "SDL2Plugin")

proc build*(plugin: SDL2Plugin, world: World) =
  world.addResource(SDL2Handler.new())
  world.registerStartupSystems(
    initializeSDL2,
    initializeSDL2Image,
    initializeSDL2Ttf
  )
  world.registerTerminateSystems(
    quitSDL2,
    quitSDL2Image,
    quitSDL2Ttf
  )

export new
export
  resources,
  systems


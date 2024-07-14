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
  world.registerStartupSystems(initializeSDL2)
  world.registerTerminateSystems(quitSDL2)

export new
export
  resources,
  systems


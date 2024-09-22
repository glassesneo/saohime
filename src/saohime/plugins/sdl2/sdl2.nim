import
  pkg/[ecslib, sdl2, sdl2/image],
  ./resources,
  ./systems

type SDL2Plugin* = ref object

proc build*(plugin: SDL2Plugin, world: World) =
  world.addResource(SDL2Args.new(

  ))
  world.addResource(SDL2Args.new(
    mainFlags = InitVideo or InitGameController or InitJoyStick,
    imageFlags = ImgInitJpg or ImgInitPng,
  ))
  world.registerStartupSystems(initSDL2, initImage, initTtf, deleteArgs)
  world.registerTerminateSystems(quitSDL2, quitImage, quitTtf)

export
  resources,
  systems


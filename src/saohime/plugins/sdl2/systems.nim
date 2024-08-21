import
  pkg/[ecslib],
  ./resources

proc initializeSDL2*(sdl2Handler: Resource[SDL2Handler]) {.system.} =
  sdl2Handler.init()
  sdl2Handler.initImage()
  sdl2Handler.initTtf()

proc quitSDL2*(sdl2Handler: Resource[SDL2Handler]) {.system.} =
  sdl2Handler.quitTtf()
  sdl2Handler.quitImage()
  sdl2Handler.quit()


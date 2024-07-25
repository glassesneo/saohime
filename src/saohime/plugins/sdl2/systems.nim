import
  pkg/[ecslib],
  ./resources

proc initializeSDL2*(sdl2Handler: Resource[SDL2Handler]) {.system.} =
  sdl2Handler.init()

proc quitSDL2*(sdl2Handler: Resource[SDL2Handler]) {.system.} =
  sdl2Handler.quit()

proc initializeSDL2Image*(sdl2Handler: Resource[SDL2Handler]) {.system.} =
  sdl2Handler.initImage()

proc quitSDL2Image*(sdl2Handler: Resource[SDL2Handler]) {.system.} =
  sdl2Handler.quitImage()

proc initializeSDL2Ttf*(sdl2Handler: Resource[SDL2Handler]) {.system.} =
  sdl2Handler.initTtf()

proc quitSDL2Ttf*(sdl2Handler: Resource[SDL2Handler]) {.system.} =
  sdl2Handler.quitTtf()


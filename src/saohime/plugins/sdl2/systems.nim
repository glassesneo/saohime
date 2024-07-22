import
  pkg/[ecslib],
  ./resources

proc initializeSDL2* {.system.} =
  let sdl2Handler = commands.getResource(SDL2Handler)
  sdl2Handler.init()

proc quitSDL2* {.system.} =
  let sdl2Handler = commands.getResource(SDL2Handler)
  sdl2Handler.quit()

proc initializeSDL2Image* {.system.} =
  let sdl2Handler = commands.getResource(SDL2Handler)
  sdl2Handler.initImage()

proc quitSDL2Image* {.system.} =
  let sdl2Handler = commands.getResource(SDL2Handler)
  sdl2Handler.quitImage()

proc initializeSDL2Ttf* {.system.} =
  let sdl2Handler = commands.getResource(SDL2Handler)
  sdl2Handler.initTtf()

proc quitSDL2Ttf* {.system.} =
  let sdl2Handler = commands.getResource(SDL2Handler)
  sdl2Handler.quitTtf()


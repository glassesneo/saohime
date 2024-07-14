import
  pkg/[ecslib],
  ./resources

proc initializeSDL2* {.system.} =
  let sdl2Handler = commands.getResource(SDL2Handler)
  sdl2Handler.init()

proc quitSDL2* {.system.} =
  let sdl2Handler = commands.getResource(SDL2Handler)
  sdl2Handler.quit()


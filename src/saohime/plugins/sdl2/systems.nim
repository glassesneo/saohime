import pkg/ecslib
import ../../core/sdl2_helpers
import ./resources

proc initSDL2*(args: Resource[SDL2Args]) {.system.} =
  sdl2Init(args.mainFlags)

proc initImage*(args: Resource[SDL2Args]) {.system.} =
  sdl2ImageInit(args.imageFlags)

proc initTtf*(args: Resource[SDL2Args]) {.system.} =
  sdl2TtfInit()

proc deleteArgs*() {.system.} =
  commands.deleteResource(SDL2Args)

proc quitSDL2*() {.system.} =
  sdl2Quit()

proc quitImage*() {.system.} =
  sdl2ImageQuit()

proc quitTtf*() {.system.} =
  sdl2TtfQuit()

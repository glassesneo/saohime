{.push raises: [].}

import
  ../../core/[exceptions, sdl2_helpers]

type SDL2Handler* = ref object
  mainFlags*: cint
  imageFlags*: cint

proc new*(
    _: type SDL2Handler,
    mainFlags: cint = 0,
    imageFlags: cint = 0,
): SDL2Handler =
  return SDL2Handler(
    mainFlags: mainFlags,
    imageFlags: imageFlags,
  )

proc init*(handler: SDL2Handler) {.raises: [SDL2InitError].} =
  sdl2Init(handler.mainFlags)

proc quit*(handler: SDL2Handler) =
  sdl2Quit()

proc initImage*(handler: SDL2Handler) {.raises: [SDL2InitError].} =
  sdl2ImageInit(handler.imageFlags)

proc quitImage*(handler: SDL2Handler) =
  sdl2ImageQuit()

proc initTtf*(handler: SDL2Handler) {.raises: [SDL2InitError].} =
  sdl2TtfInit()

proc quitTtf*(handler: SDL2Handler) =
  sdl2TtfQuit()

export new


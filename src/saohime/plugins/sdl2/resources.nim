{.push raises: [].}

import
  ../../core/[exceptions, sdl2_helpers]

type SDL2Handler* = ref object
  flags: cint

proc new*(_: type SDL2Handler): SDL2Handler =
  return SDL2Handler(flags: 0)

proc init*(handler: SDL2Handler) {.raises: [SDL2InitError].} =
  sdl2Init(handler.flags)

proc quit*(handler: SDL2Handler) =
  sdl2Quit()

export new


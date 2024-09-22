{.push raises: [].}
import
  pkg/[seiryu]

type SDL2Args* = ref object
  mainFlags*: cint
  imageFlags*: cint

proc new*(T: type SDL2Args, mainFlags, imageFlags: cint): T {.construct.}
export new


import
  pkg/[sdl2]

template pre*(condition) =
  when compileOption "assertions":
    if not condition:
      raiseAssert "pre condition failed"

template pre*(condition, proccess) =
  when compileOption "assertions":
    if not condition:
      proccess
      raiseAssert "pre condition failed"

template post*(condition) =
  var exitCode {.inject.}: SDL_Return
  when compileOption "assertions":
    defer:
      if not condition:
        raiseAssert "post condition failed"

template post*(condition, proccess) =
  var exitCode {.inject, used.}: SDL_Return
  when compileOption "assertions":
    defer:
      if not condition:
        proccess
        raiseAssert "post condition failed"

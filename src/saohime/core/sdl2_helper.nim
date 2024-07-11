import
  pkg/[sdl2],
  ./[plugin],
  ../[templates]

proc sdl2Init* =
  post: exitCode == SdlSuccess
  do:
    echo "Failed to initialize SDL2" & $sdl2.getError()

  exitCode = sdl2.init(0)

proc sdl2Quit* = sdl2.quit()


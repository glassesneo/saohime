import
  pkg/[sdl2, ecslib, oolib],
  saohime/[templates]

proc sdl2Init =
  post: exitCode == SdlSuccess
  do:
    echo "Failed to initialize SDL2" & $sdl2.getError()

  exitCode = sdl2.init(0)

class pub App:
  var
    window: WindowPtr
    world: World

  proc `new`: App =
    sdl2Init()

  proc setup*(
      title: string;
      x = SDL_WINDOWPOS_CENTERED.int;
      y = SDL_WINDOWPOS_CENTERED.int;
      width, height: int
  ) =
    post: self.window != nil
    do:
      echo "Failed to create window" & $sdl2.getError()

    self.window = sdl2.createWindow(
      title.cstring,
      x.cint, y.cint,
      width.cint, height.cint,
      SDL_WINDOW_RESIZABLE or SDL_WINDOW_SHOWN
    )

    self.world = World.new()

  proc mainLoop =
    while true:
      self.world.runSystems()
      var event = defaultEvent

      while pollEvent(event):
        case event.kind:
        of QuitEvent:
          break
        else:
          discard

  proc start* =
    defer:
      self.window.destroy()
      sdl2.quit()

    self.world.runStartupSystems()
    self.mainLoop()


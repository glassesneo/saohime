import
  pkg/[sdl2, ecslib, oolib],
  saohime/[templates],
  saohime/core/[plugin],
  saohime/default_plugins/[event/event]

proc sdl2Init* =
  post: exitCode == SdlSuccess
  do:
    echo "Failed to initialize SDL2" & $sdl2.getError()

  exitCode = sdl2.init(0)

proc sdl2Quit* = sdl2.quit()

class pub App:
  var
    window: WindowPtr
    world*: World

  proc `new`: App =
    sdl2Init()

  proc setup*(
      title: string;
      x = SdlWindowposCentered.int;
      y = SdlWindowposCentered.int;
      width, height: int
  ) =
    post: self.window != nil
    do:
      echo "Failed to create window" & $sdl2.getError()

    self.window = sdl2.createWindow(
      title.cstring,
      x.cint, y.cint,
      width.cint, height.cint,
      SdlWindowResizable or SdlWindowShown
    )

    self.world = World.new()

    self.world.loadPlugins(
      EventPlugin()
    )

  proc mainLoop =
    while true:
      self.world.runSystems()

  template start*(body) =
    block:
      defer:
        self.window.destroy()
        sdl2Quit()

      let world = self.world

      self.world.runStartupSystems()
      self.mainLoop()

export saohime.ecslib
export saohime.event

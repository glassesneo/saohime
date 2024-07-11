import
  pkg/[sdl2, ecslib, oolib],
  saohime/[templates],
  saohime/core/[plugin, sdl2_helper],
  saohime/default_plugins/[app/app, event/event]

class pub App:
  var
    window: WindowPtr
    world: World

  proc `new`: App =
    sdl2Init()
    self.world = World.new()

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

    self.world.loadPlugins(
      AppPlugin.new(self.window),
      EventPlugin.new()
    )

  proc mainLoop =
    let appState = self.world.getResource(AppState)
    appState.activateMainLoop()
    while appState.mainLoopFlag:
      self.world.runSystems()

  template start*(body) =
    block:
      defer:
        self.window.destroy()
        sdl2Quit()

      block:
        defer:
          self.world.runTerminateSystems()

        let world {.inject.} = self.world

        body

        self.world.runStartupSystems()
        self.mainLoop()

export new
export saohime.ecslib
export saohime.sdl2
export
  saohime.app,
  saohime.event

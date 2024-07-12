{.push raises: [].}

import
  pkg/[sdl2, ecslib, oolib],
  saohime/core/[exceptions, plugin, sdl2_helper],
  saohime/default_plugins/[
    app/app,
    event/event,
    render/render,
    transform/transform
  ]

class pub App:
  var
    window: WindowPtr
    renderer: RendererPtr
    world: World

  proc `new`: App {.raises: [SDL2InitError].} =
    sdl2Init(0)
    self.world = World.new()

  proc setup*(
      title: string;
      x = SdlWindowposCentered.int;
      y = SdlWindowposCentered.int;
      width, height: int
  ) {.raises: [SDL2WindowError, SDL2RendererError].} =
    self.window = createWindow(
      title = title,
      x = x,
      y = y,
      width = width,
      height = height,
      flags = SdlWindowResizable or SdlWindowShown
    )

    self.renderer = createRenderer(
      window = self.window,
      flags = RendererAccelerated or RendererPresentVsync
    )

    self.world.loadPlugins(
      AppPlugin.new(self.window),
      EventPlugin.new(),
      RenderPlugin.new(self.renderer),
      TransformPlugin.new()
    )

  proc mainLoop {.raises: [Exception].} =
    let appState = self.world.getResource(AppState)
    appState.activateMainLoop()
    while appState.mainLoopFlag:
      self.world.runSystems()

  template start*(body) =
    block:
      defer:
        self.renderer.destroy()
        self.window.destroy()
        sdl2ImageQuit()
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
  saohime.event,
  saohime.render,
  saohime.transform

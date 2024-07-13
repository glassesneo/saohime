{.push raises: [].}

import
  std/[tables],
  pkg/[sdl2, ecslib, oolib],
  saohime/core/[exceptions, plugin, sdl2_helpers],
  saohime/default_plugins/[default_plugins]

class pub App:
  var
    window: WindowPtr
    renderer: RendererPtr
    world: World
    plugins: Table[string, PluginTuple]

  proc `new`: App {.raises: [SDL2InitError].} =
    sdl2Init(0)
    self.world = World.new()

  proc registerPlugin*(plugin: PluginTuple) =
    self.plugins[plugin.name] = plugin

  proc registerPluginGroup*(pluginGroup: PluginGroup) =
    for plugin in pluginGroup.group:
      self.registerPlugin(plugin)

  proc deletePlugin*(pluginName: string) =
    self.plugins.del(pluginName)

  proc loadPlugins* =
    for plugin in self.plugins.values:
      plugin.build(self.world)

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

    self.registerPluginGroup(defaultPlugins(self.window, self.renderer))

  proc mainLoop {.raises: [Exception].} =
    let appState = self.world.getResource(AppState)
    appState.activateMainLoop()
    while appState.mainLoopFlag:
      self.world.runSystems()

  template start*(body) =
    block:
      defer:
        sdl2ImageQuit()
        sdl2Quit()

      block:
        defer:
          self.world.runTerminateSystems()

        self.loadPlugins()

        let world {.inject.} = self.world
        body

        self.world.runStartupSystems()
        self.mainLoop()

export new
export saohime.ecslib
export saohime.sdl2
export saohime.default_plugins


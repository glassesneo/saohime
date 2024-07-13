{.push raises: [].}

import
  pkg/[sdl2],
  ../core/[plugin],
  ./app/app,
  ./event/event,
  ./render/render,
  ./transform/transform,
  ./window/window

proc defaultPlugins*(
    window: WindowPtr;
    renderer: RendererPtr
): PluginGroup =
  return PluginGroup.new(
    AppPlugin.new(),
    EventPlugin.new(),
    RenderPlugin.new(renderer),
    TransformPlugin.new(),
    WindowPlugin.new(window)
  )

export
  app,
  event,
  render,
  transform,
  window

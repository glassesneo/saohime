import
  std/[importutils],
  pkg/[ecslib],
  ../window/window,
  ./resources

proc createRenderer* {.system.} =
  privateAccess(Window)
  let
    window = commands.getResource(Window)
    renderer = commands.getResource(Renderer)

  if commands.hasResource(RendererSettings):
    let settings = commands.getResource(RendererSettings)
    renderer.create(window.window, settings.index, settings.flags)
  else:
    renderer.create(window.window)

proc destroyRenderer* {.system.} =
  let renderer = commands.getResource(Renderer)
  renderer.destroy()


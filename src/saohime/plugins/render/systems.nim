import
  std/[importutils],
  pkg/[ecslib],
  ../window/window,
  ./resources

proc createRenderer* {.system.} =
  let renderer = commands.getResource(Renderer)
  privateAccess(Window)
  let window = commands.getResource(Window)
  renderer.create(window.window)

proc destroyRenderer* {.system.} =
  let renderer = commands.getResource(Renderer)
  renderer.destroy()


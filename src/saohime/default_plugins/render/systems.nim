import
  pkg/[ecslib],
  ./resources

proc destroyRenderer* {.system.} =
  let renderer = commands.getResource(Renderer)
  renderer.destroy()


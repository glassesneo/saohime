import
  pkg/[ecslib],
  ./resources

proc destroyWindow* {.system.} =
  let window = commands.getResource(Window)
  window.destroy()


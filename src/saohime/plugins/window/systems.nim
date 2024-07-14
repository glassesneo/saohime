import
  pkg/[ecslib],
  ./resources

proc createWindow* {.system.} =
  let window = commands.getResource(Window)
  window.create()

proc destroyWindow* {.system.} =
  let window = commands.getResource(Window)
  window.destroy()


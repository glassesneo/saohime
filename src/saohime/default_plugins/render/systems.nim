import
  pkg/[ecslib],
  ./resources

proc destroyRenderer* {.system.} =
  let drawer = commands.getResource(Drawer)
  drawer.destroy()


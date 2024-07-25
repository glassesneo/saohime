import
  pkg/[ecslib],
  ../../core/application,
  ./resources

proc createWindow*(window: Resource[Window]) {.system.} =
  window.create()

proc destroyWindow*(window: Resource[Window]) {.system.} =
  window.destroy()


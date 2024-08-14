import
  pkg/[ecslib],
  ./resources

proc adjustFrame*(fpsManager: Resource[FPSManager]) {.system.} =
  fpsManager.incrementFrameCount()
  fpsManager.adjust()
  fpsManager.updateDeltaTime()


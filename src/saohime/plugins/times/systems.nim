import pkg/[ecslib]
import ./resources

proc adjustFrame*(fpsManager: Resource[FPSManager]) {.system.} =
  fpsManager.incrementFrameCount()
  fpsManager.adjust()
  fpsManager.updateDeltaTime()

{.push raises: [].}
import
  std/[lenientops, math],
  pkg/[ecslib, sdl2],
  ../../core/[saohime_types]

type
  FPSManager* = ref object
    fps: uint
    idealDeltaTime, elapsedFrame: float
    previousElapsedTime: uint
    deltaTime: float # actual decimal
    frameCount: uint

  Interval* = ref object
    fpsManager: FPSManager
    frame*: uint

proc new*(_: type FPSManager, fps: uint): FPSManager =
  return FPSManager(
    fps: fps.uint,
    idealDeltaTime: (1000 / fps.int),
    frameCount: 0
  )

proc fps*(manager: FPSManager): uint =
  return manager.fps

proc `fps=`*(manager: FPSManager, fps: uint) =
  manager.fps = fps
  manager.idealDeltaTime = (1000 / fps.int)

proc adjust*(manager: FPSManager) =
  let elapsedTime = getTicks()

  let difference = manager.elapsedFrame - elapsedTime.float
  if difference > 0:
    delay(difference.round.uint32)

  manager.elapsedFrame += manager.idealDeltaTime

proc updateDeltaTime*(manager: FPSManager) =
  let elapsedTime = getTicks()

  manager.deltaTime = (elapsedTime - manager.previousElapsedTime).int / 1000
  manager.previousElapsedTime = elapsedTime

proc incrementFrameCount*(manager: FPSManager) =
  manager.frameCount.inc

proc resetFrameCount*(manager: FPSManager) =
  manager.frameCount = 0

proc deltaTime*(manager: FPSManager): float =
  manager.deltaTime

proc frameCount*(manager: FPSManager): uint =
  return manager.frameCount

proc interval*(manager: FPSManager, frame: uint): Interval =
  return Interval(fpsManager: manager, frame: frame)

proc trigger*(interval: Interval): bool =
  return interval.fpsManager.frameCount mod interval.frame == 0

export new


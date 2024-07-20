import
  std/[math],
  pkg/[ecslib, oolib, sdl2],
  ../../core/[saohime_types]

type
  FPSManager* = ref object
    fps: uint
    idealDeltaTime, elapsedFrame: float
    previousElapsedTime: uint
    deltaTime: float # actual decimal

proc new*(_: type FPSManager, fps: uint = 60): FPSManager =
  return FPSManager(fps: fps.uint, idealDeltaTime: (1000 / fps.int))

proc fps*(manager: FPSManager): uint =
  return manager.fps

proc `fps=`*(manager: FPSManager, fps: uint) =
  manager.fps = fps
  manager.idealDeltaTime = (1000 / fps.int)

proc adjust(manager: FPSManager) =
  let elapsedTime = getTicks()

  let difference = manager.elapsedFrame - elapsedTime.float
  if difference > 0:
    delay(difference.round.uint32)

  manager.elapsedFrame += manager.idealDeltaTime

proc updateDeltaTime(manager: FPSManager) =
  let elapsedTime = getTicks()

  manager.deltaTime = (elapsedTime - manager.previousElapsedTime).int / 1000
  manager.previousElapsedTime = elapsedTime

proc deltaTime*(manager: FPSManager): float =
  manager.deltaTime

proc adjustFrame* {.system.} =
  let fpsManager = commands.getResource(FPSManager)
  fpsManager.adjust()
  fpsManager.updateDeltaTime()

type
  TimesPlugin* = ref object
    name*: string

proc new*(_: type TimesPlugin): TimesPlugin =
  return TimesPlugin(name: "TimesPlugin")

proc build*(plugin: TimesPlugin, world: World) =
  world.addResource(FPSManager.new())
  world.registerStartupSystems(adjustFrame)
  world.registerSystems(adjustFrame)
  world.registerTerminateSystems(adjustFrame)

export new


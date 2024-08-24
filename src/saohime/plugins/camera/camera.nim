{.push raises: [].}
import
  pkg/[ecslib],
  ./components,
  ./systems

type
  CameraPlugin* = ref object

proc build*(plugin: CameraPlugin, world: World) {.raises: [KeyError].} =
  world.registerStartupSystems(initializeCamera)
  world.registerSystems(setViewport)

export
  components,
  systems


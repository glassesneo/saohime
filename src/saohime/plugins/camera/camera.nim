{.push raises: [].}
import
  pkg/[ecslib],
  ./resources,
  ./systems

type
  CameraPlugin* = ref object

proc build*(plugin: CameraPlugin, world: World) {.raises: [KeyError].} =
  world.addResource(Camera.new())
  world.registerStartupSystems(initializeCamera)
  world.registerSystems(setViewport)

export
  resources,
  systems


{.push raises: [].}
import
  pkg/[ecslib],
  ./resources,
  ./systems

type
  CameraPlugin* = ref object

proc build*(plugin: CameraPlugin, world: World) =
  world.addResource(Camera.new())
  world.registerStartupSystems(initializeCamera)
  world.registerSystems(setCamera)

export
  resources,
  systems


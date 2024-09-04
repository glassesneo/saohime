import
  pkg/[ecslib],
  ./components,
  ./systems

type
  CameraPlugin* = ref object

proc build*(plugin: CameraPlugin, world: World) =
  world.registerStartupSystems(initializeCamera)
  world.registerSystems(setViewport)

export
  components,
  systems


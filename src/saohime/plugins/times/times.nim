import
  pkg/[ecslib],
  ./resources,
  ./systems

type
  TimesPlugin* = ref object

proc build*(plugin: TimesPlugin, world: World) =
  world.addResource(FPSManager.new())
  world.registerStartupSystems(adjustFrame)
  world.registerSystems(adjustFrame)
  world.registerTerminateSystems(adjustFrame)

export
  resources,
  systems


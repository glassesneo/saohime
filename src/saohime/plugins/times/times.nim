import pkg/[ecslib]
import ./[resources, systems]

type TimesPlugin* = ref object

proc build*(plugin: TimesPlugin, world: World) =
  world.addResource(FPSManager.new(fps = 60))
  world.registerStartupSystems(adjustFrame)
  world.registerSystemsAt("last", adjustFrame)
  world.registerTerminateSystems(adjustFrame)

export resources, systems

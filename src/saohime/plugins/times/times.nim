import
  pkg/[ecslib],
  ./resources

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
export
  resources


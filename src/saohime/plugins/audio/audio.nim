import
  pkg/[ecslib],
  ./components,
  ./resources,
  ./systems

type
  AudioPlugin* = ref object

proc build*(plugin: AudioPlugin, world: World) =
  world.addResource(Audio.new())
  world.registerStartupSystems(initAudio)

export
  components,
  resources,
  systems


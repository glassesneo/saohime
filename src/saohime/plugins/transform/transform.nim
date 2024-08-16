{.push raises: [].}

import
  pkg/[ecslib],
  ./components,
  ./resources

type
  TransformPlugin* = ref object

proc build*(plugin: TransformPlugin, world: World) =
  world.addResource(GlobalScale.new(1f, 1f))

export
  components,
  resources


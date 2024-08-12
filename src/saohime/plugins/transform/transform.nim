{.push raises: [].}

import
  pkg/[ecslib],
  ./components

type
  TransformPlugin* = ref object

proc build*(plugin: TransformPlugin, world: World) =
  discard

export
  components


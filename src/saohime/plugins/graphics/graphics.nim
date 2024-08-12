{.push raises: [].}

import
  pkg/[ecslib],
  ./components

type
  GraphicsPlugin* = ref object

proc build*(plugin: GraphicsPlugin, world: World) =
  discard

export
  components


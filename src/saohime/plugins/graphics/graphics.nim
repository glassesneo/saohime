{.push raises: [].}

import
  pkg/[ecslib],
  ../../core/[saohime_types],
  ./components

type
  GraphicsPlugin* = ref object
    name*: string

proc new*(_: type GraphicsPlugin): GraphicsPlugin =
  return GraphicsPlugin(name: "GraphicsPlugin")

proc build*(plugin: GraphicsPlugin, world: World) =
  discard

export new
export
  components


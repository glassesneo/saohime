{.push raises: [].}

import
  pkg/[ecslib],
  ./components

type
  TransformPlugin* = ref object
    name*: string

proc new*(_: type TransformPlugin): TransformPlugin =
  return TransformPlugin(name: "TransformPlugin")

proc build*(plugin: TransformPlugin, world: World) =
  discard

export new
export
  components


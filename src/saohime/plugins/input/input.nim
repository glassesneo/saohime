{.push raises: [].}

import
  pkg/[ecslib],
  ./resources

type InputPlugin* = ref object
  name*: string

proc new*(_: type InputPlugin): InputPlugin =
  return InputPlugin(name: "InputPlugin")

proc build*(plugin: InputPlugin, world: World) =
  world.addResource(KeyboardInput.new())
  world.addResource(MouseInput.new())

export new
export
  resources


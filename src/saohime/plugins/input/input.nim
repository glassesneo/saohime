{.push raises: [].}

import
  std/[macros],
  pkg/[ecslib, sdl2],
  ../../core/saohime_types

type
  KeyboardInput* = ref object
    keyState: ptr array[0..SdlNumScancodes.int, uint8]

proc new*(_: type KeyboardInput): KeyboardInput =
  result = KeyboardInput(keyState: getKeyboardState())

proc isDown*(input: KeyboardInput, key: cint): bool =
  input.keyState[key.getScancodeFromKey().int] == 1

proc isUp*(input: KeyboardInput, key: cint): bool =
  input.keyState[key.getScancodeFromKey().int] == 0

macro keyDown*(input: KeyboardInput, key: untyped): bool =
  let keyIdent = ident("K_" & key.strVal)
  result = quote do:
    `input`.isDown(`keyIdent`)

macro keyUp*(input: KeyboardInput, key: untyped): bool =
  let keyIdent = ident("K_" & key.strVal)
  result = quote do:
    `input`.isUp(`keyIdent`)

type
  MouseInput* = ref object
    mouseState: uint8
    x, y: cint

proc new*(_: type MouseInput): MouseInput =
  result = MouseInput()
  result.mouseState = getMouseState(addr result.x, addr result.y)

proc getState(input: MouseInput) =
  input.mouseState = getMouseState(addr input.x, addr input.y)

proc x*(input: MouseInput): cint =
  input.getState()
  return input.x

proc y*(input: MouseInput): cint =
  input.getState()
  return input.y

proc position*(input: MouseInput): Vector =
  input.getState()
  return Vector.new(input.x.float, input.y.float)

proc isDown*(input: MouseInput, button: uint8): bool =
  input.getState()
  return (input.mouseState and SdlButton(button)) == 1

proc isUp*(input: MouseInput, button: uint8): bool =
  input.getState()
  return (input.mouseState and SdlButton(button)) == 0

type InputPlugin* = ref object
  name*: string

proc new*(_: type InputPlugin): InputPlugin =
  return InputPlugin(name: "InputPlugin")

proc build*(plugin: InputPlugin, world: World) =
  world.addResource(KeyboardInput.new())
  world.addResource(MouseInput.new())

export new


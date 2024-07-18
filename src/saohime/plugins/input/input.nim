import
  std/[macros],
  pkg/[ecslib, sdl2]

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

type InputPlugin* = ref object
  name*: string

proc new*(_: type InputPlugin): InputPlugin =
  return InputPlugin(name: "InputPlugin")

proc build*(plugin: InputPlugin, world: World) =
  world.addResource(KeyboardInput.new())

export new


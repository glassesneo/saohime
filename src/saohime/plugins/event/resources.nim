{.push raises: [].}
import
  std/[packedsets],
  pkg/ecslib,
  pkg/results,
  pkg/[sdl2, sdl2/joystick],
  pkg/[seiryu],
  ../../core/saohime_types,
  ./components

type
  EventListener* = ref object
    event*: sdl2.Event

  KeyboardInput* = ref object
    keyState*: ptr array[0..SDLNumScancodes.int, uint8]
    downKeySet*, releasedKeySet*: set[0..SDLNumScancodes.int]
    heldFrameList*: seq[Natural]

  MouseInput* = ref object
    downButtonSet*, releasedButtonSet*: set[uint8]
    heldFrameList*: seq[Natural]
    x*, y*: cint
    eventPosition*: Vector

  ControllerManager* = ref object
    inputList*: seq[ControllerInput]
    idSet: PackedSet[JoystickID]

proc new*(T: type EventListener): T {.construct.} =
  result.event = defaultEvent

proc pollEvent*(listener: EventListener): bool =
  return sdl2.pollEvent(listener.event)

proc new*(T: type KeyboardInput): T {.construct.} =
  result.keyState = getKeyboardState()
  result.heldFrameList = newSeq[Natural](len = SdlNumScancodes.int)

proc new*(T: type MouseInput): T {.construct.} =
  result.heldFrameList = newseq[Natural](len = 5)
  result.eventPosition = ZeroVector

proc getState*(input: MouseInput): uint8 =
  return getMouseState(addr input.x, addr input.y)

proc new*(T: type ControllerManager): T {.construct.} =
  result.inputList = newSeq[ControllerInput](len = 16)
  result.idSet = initPackedSet[JoystickID]()

proc register*(manager: ControllerManager, device: ControllerDevice) =
  manager.idSet.incl device.id
  manager.inputList[device.id] = device.input

proc unregister*(manager: ControllerManager, device: ControllerDevice) =
  manager.idSet.excl device.id

proc `[]`*(manager: ControllerManager, device: ControllerDevice): ControllerInput =
  return manager.inputList[device.id]

export new

export
  results


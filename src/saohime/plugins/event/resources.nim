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
    keyState*: ptr array[0..SdlNumScancodes.int, uint8]
    downKeySet*, releasedKeySet*: PackedSet[int]
    heldFrameList*: seq[Natural]

  MouseInput* = ref object
    downButtonSet*, releasedButtonSet*: PackedSet[uint8]
    heldFrameList*: seq[Natural]
    x*, y*: cint
    eventPosition*: Vector

  JoystickInput* = ref object
    deadZone*: Natural
    direction*: Vector
    values*: Vector

  JoystickManager* = ref object
    joystickList*: seq[JoystickInput]
    idSet: PackedSet[JoystickID]

  JoystickConnectError* = enum
    NoDevice
    FailedToOpen

proc new*(T: type EventListener): T {.construct.} =
  result.event = defaultEvent

proc pollEvent*(listener: EventListener): bool =
  return sdl2.pollEvent(listener.event)

proc new*(T: type KeyboardInput): T =
  return KeyboardInput(
    keyState: getKeyboardState(),
    downKeySet: initPackedSet[int](),
    releasedKeySet: initPackedSet[int](),
    heldFrameList: newSeq[Natural](len = SdlNumScancodes.int + 1)
  )

proc new*(T: type MouseInput): T =
  return MouseInput(
    downButtonSet: initPackedSet[uint8](),
    releasedButtonSet: initPackedSet[uint8](),
    heldFrameList: newSeq[Natural](len = 5),
    eventPosition: ZeroVector
  )

proc getState*(input: MouseInput): uint8 =
  return getMouseState(addr input.x, addr input.y)

proc new*(T: type JoystickInput, deadZone: Natural = 0): T {.construct.} =
  result.deadZone = deadZone
  result.direction = ZeroVector
  result.values = ZeroVector

proc new*(T: type JoystickManager): T {.construct.} =
  result.joystickList = newSeq[JoystickInput](len = 16)
  result.idSet = initPackedSet[JoystickID]()

proc connect*(
    manager: JoystickManager,
    id: JoystickID
): Result[JoystickController, JoystickConnectError] =
  if numJoySticks() <= manager.idSet.len():
    result.err NoDevice
    return

  let joystick = joystickOpen(id)

  if joystick == nil:
    result.err FailedToOpen
    return

  manager.idSet.incl id
  manager.joystickList[id] = JoystickInput.new()
  result.ok JoystickController.new(joystick, id)
  return

proc disconnect*(manager: JoystickManager, joystick: JoystickController) =
  joystickClose(joystick.joystick)
  manager.idSet.excl joystick.id

proc `[]`*(manager: JoystickManager, joystick: JoystickController): JoystickInput =
  return manager.joystickList[joystick.id]

export new

export
  results


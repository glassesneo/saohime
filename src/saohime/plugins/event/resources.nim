{.push raises: [].}

import
  std/[packedsets],
  pkg/[ecslib, sdl2],
  ../../core/saohime_types

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

proc new*(_: type EventListener): EventListener =
  return EventListener(
    event: defaultEvent
  )

proc pollEvent*(listener: EventListener): bool =
  return sdl2.pollEvent(listener.event)

proc new*(_: type KeyboardInput): KeyboardInput =
  return KeyboardInput(
    keyState: getKeyboardState(),
    downKeySet: initPackedSet[int](),
    releasedKeySet: initPackedSet[int](),
    heldFrameList: newSeq[Natural](len = SdlNumScancodes.int + 1)
  )

proc new*(_: type MouseInput): MouseInput =
  return MouseInput(
    downButtonSet: initPackedSet[uint8](),
    releasedButtonSet: initPackedSet[uint8](),
    heldFrameList: newSeq[Natural](len = 5),
    eventPosition: ZeroVector
  )

proc getState*(input: MouseInput): uint8 =
  return getMouseState(addr input.x, addr input.y)

export new


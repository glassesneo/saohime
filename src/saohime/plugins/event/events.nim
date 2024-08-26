import
  std/[packedsets],
  pkg/[ecslib, oolib],
  ../../core/[saohime_types]

type
  ApplicationEventType* = enum
    Quit

class pub ApplicationEvent:
  var
    eventType*: ApplicationEventType

type
  KeyboardEvent* = object
    heldKeys*, pressedKeys*, releasedKeys*: PackedSet[cint]

  MouseButtonEvent* = object
    heldButtons*, pressedButtons*, releasedButtons*: PackedSet[uint8]
    position: Vector

proc new*(
    _: type KeyboardEvent,
    heldKeys, pressedKeys, releasedKeys: PackedSet[cint]
): KeyboardEvent =
  return KeyboardEvent(
    heldKeys: heldKeys,
    pressedKeys: pressedKeys,
    releasedKeys: releasedKeys
  )

proc isDown*(event: KeyboardEvent, keycode: cint): bool =
  return keycode in event.heldKeys or keycode in event.pressedKeys

proc isHeld*(event: KeyboardEvent, keycode: cint): bool =
  return keycode in event.heldKeys

proc isPressed*(event: KeyboardEvent, keycode: cint): bool =
  return keycode in event.pressedKeys

proc isReleased*(event: KeyboardEvent, keycode: cint): bool =
  return keycode in event.releasedKeys

proc new*(
    _: type MouseButtonEvent,
    heldButtons, pressedButtons, releasedButtons: PackedSet[uint8],
    position: Vector
): MouseButtonEvent =
  return MouseButtonEvent(
    heldButtons: heldButtons,
    pressedButtons: pressedButtons,
    releasedButtons: releasedButtons,
    position: position
  )

proc position*(event: MouseButtonEvent): Vector =
  return event.position

proc isDown*(event: MouseButtonEvent, button: uint8): bool =
  return button in event.heldButtons or button in event.pressedButtons

proc isHeld*(event: MouseButtonEvent, button: uint8): bool =
  return button in event.heldButtons

proc isPressed*(event: MouseButtonEvent, button: uint8): bool =
  return button in event.pressedButtons

proc isReleased*(event: MouseButtonEvent, button: uint8): bool =
  return button in event.releasedButtons

export new


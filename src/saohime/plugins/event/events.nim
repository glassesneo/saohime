import
  std/[packedsets],
  pkg/ecslib,
  pkg/[seiryu],
  ../../core/[saohime_types]

type
  ApplicationEventType* = enum
    Quit

  ApplicationEvent* = object
    eventType*: ApplicationEventType

  KeyboardEvent* = object
    heldKeys*, pressedKeys*, releasedKeys*: PackedSet[cint]

  MouseButtonEvent* = object
    heldButtons*, pressedButtons*, releasedButtons*: PackedSet[uint8]
    position: Vector

proc new*(
    T: type ApplicationEvent,
    eventType: ApplicationEventType
): T {.construct.}

proc new*(
    T: type KeyboardEvent,
    heldKeys, pressedKeys, releasedKeys: PackedSet[cint]
): T {.construct.}

proc isDown*(event: KeyboardEvent, keycode: cint): bool =
  return keycode in event.heldKeys or keycode in event.pressedKeys

proc isHeld*(event: KeyboardEvent, keycode: cint): bool =
  return keycode in event.heldKeys

proc isPressed*(event: KeyboardEvent, keycode: cint): bool =
  return keycode in event.pressedKeys

proc isReleased*(event: KeyboardEvent, keycode: cint): bool =
  return keycode in event.releasedKeys

proc new*(
    T: type MouseButtonEvent,
    heldButtons, pressedButtons, releasedButtons: PackedSet[uint8],
    position: Vector
): T {.construct.}

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


import
  pkg/ecslib,
  pkg/[sdl2],
  pkg/[seiryu],
  ../../core/[saohime_types]

type
  ApplicationEventType* = enum
    Quit

  ApplicationEvent* = object
    eventType*: ApplicationEventType

  KeyboardEvent* = object
    heldKeys*, pressedKeys*, releasedKeys*: set[0..SDLNumScancodes.int]

  MouseButtonEvent* = object
    heldButtons*, pressedButtons*, releasedButtons*: set[uint8]
    position: Vector

proc new*(
    T: type ApplicationEvent,
    eventType: ApplicationEventType
): T {.construct.}

proc new*(
    T: type KeyboardEvent,
    heldKeys, pressedKeys, releasedKeys: set[0..SDLNumScancodes.int]
): T {.construct.}

proc isPressed*(event: KeyboardEvent, keycode: cint): bool =
  return keycode.int in event.pressedKeys

proc isHeld*(event: KeyboardEvent, keycode: cint): bool =
  return keycode.int in event.heldKeys

proc isDown*(event: KeyboardEvent, keycode: cint): bool =
  return event.isPressed(keycode) or event.isHeld(keycode)

proc isReleased*(event: KeyboardEvent, keycode: cint): bool =
  return keycode.int in event.releasedKeys

proc new*(
    T: type MouseButtonEvent,
    heldButtons, pressedButtons, releasedButtons: set[uint8],
    position: Vector
): T {.construct.}

proc position*(event: MouseButtonEvent): Vector =
  return event.position

proc isPressed*(event: MouseButtonEvent, button: uint8): bool =
  return button in event.pressedButtons

proc isHeld*(event: MouseButtonEvent, button: uint8): bool =
  return button in event.heldButtons

proc isDown*(event: MouseButtonEvent, button: uint8): bool =
  return event.isPressed(button) or event.isHeld(button)

proc isReleased*(event: MouseButtonEvent, button: uint8): bool =
  return button in event.releasedButtons

export new


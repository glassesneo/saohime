{.push raises: [].}

import
  pkg/[ecslib, sdl2],
  ../../core/saohime_types

type
  EventListener* = ref object
    event*: sdl2.Event
    keyState*: ptr array[0..SdlNumScancodes.int, uint8]

  MouseInput* = ref object
    x, y: cint

proc new*(_: type EventListener): EventListener =
  return EventListener(event: defaultEvent, keyState: getKeyboardState())

proc pollEvent*(listener: EventListener): bool =
  return sdl2.pollEvent(listener.event)

proc new*(_: type MouseInput): MouseInput =
  return MouseInput()

proc getMouseState*(input: MouseInput): uint8 =
  return getMouseState(addr input.x, addr input.y)

proc position*(input: MouseInput): Vector =
  return Vector.new(input.x.float, input.y.float)

export new


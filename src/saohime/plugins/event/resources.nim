{.push raises: [].}

import
  pkg/[ecslib, sdl2]

type EventListener* = ref object
  event*: sdl2.Event
  keyState*: ptr array[0..SdlNumScancodes.int, uint8]

proc new*(_: type EventListener): EventListener =
  return EventListener(event: defaultEvent, keyState: getKeyboardState())

proc pollEvent*(listener: EventListener): bool =
  return sdl2.pollEvent(listener.event)

export new


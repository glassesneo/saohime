{.push raises: [].}

import
  pkg/[ecslib, oolib, sdl2],
  ../../core/[contract]

class pub EventListener:
  var event*: sdl2.Event

  proc pollEvent*: bool =
    return sdl2.pollEvent(self.event)

  proc checkEvent*(eventType: EventType): bool =
    return self.event.kind == eventType

  proc currentKey*: cint =
    pre(self.checkEvent(KeyDown))

    return self.event.key.keysym.sym

  proc currentKeyName*: cstring =
    return self.currentKey.getKeyName()

  proc currentButton*: uint8 =
    return self.event.button.button

export new


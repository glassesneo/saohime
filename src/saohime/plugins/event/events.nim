import
  pkg/[oolib]
from pkg/sdl2 import Event

type
  ApplicationEventType* = enum
    Quit

  KeyboardEventType* = enum
    KeyDown
    KeyUp

  MouseEventType* = enum
    MouseMotion
    MouseButtonDown
    MouseButtonUp
    MouseWheel

class pub ApplicationEvent:
  var
    event: Event
    eventType*: ApplicationEventType

class pub KeyboardEvent:
  var
    event: Event
    eventType*: KeyboardEventType
    key*: cint

class pub MouseEvent:
  var
    event: Event
    eventType*: MouseEventType
    button*: uint8


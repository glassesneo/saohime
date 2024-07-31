import
  pkg/[ecslib, oolib],
  ../../core/[saohime_types]
import pkg/sdl2 except Event

type
  ApplicationEventType* = enum
    Quit

  KeyboardEventType* = enum
    KeyPressed
    KeyDown
    KeyReleased

  MouseEventType* = enum
    MouseMotion
    MouseButtonPressed
    MouseButtonDown
    MouseButtonReleased
    MouseWheel

class pub ApplicationEvent:
  var
    eventType*: ApplicationEventType

class pub KeyboardEvent:
  var
    eventType*: KeyboardEventType
    currentKey*: cint
    keyState: ptr array[0..SdlNumScancodes.int, uint8]

  proc isDown*(key: cint): bool =
    return self.keyState[key.getScancodeFromKey().int] == 1

  proc isPressed*(key: cint): bool =
    return self.eventType == KeyPressed and key == self.currentKey

  proc isUp*(key: cint): bool =
    return self.keyState[key.getScancodeFromKey().int] == 0

  proc isReleased*(key: cint): bool =
    return self.eventType == KeyReleased and key == self.currentKey

class pub MouseEvent:
  var
    eventType*: MouseEventType
    currentButton*: uint8
    position*: Vector
    mouseState: uint8

  proc `new`(eventType: MouseEventType, position: Vector, mouseState: uint8) =
    self.eventType = eventType
    self.position = position
    self.mouseState = mouseState

  proc isDown*(button: uint8): bool =
    return (self.mouseState and SdlButton(button)) == 1

  proc isPressed*(button: uint8): bool =
    return self.eventType == MouseButtonPressed and button == self.currentButton

  proc isUp*(button: uint8): bool =
    return (self.mouseState and SdlButton(button)) == 0

  proc isReleased*(button: uint8): bool =
    self.eventType == MouseButtonReleased and button == self.currentButton

export new


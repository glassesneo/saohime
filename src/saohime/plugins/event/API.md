# EventPlugin
This plugin implements several interfaces for handling SDL2 events. Either the resources or the events is available for dealing with user input.

## Resources
```nim
type EventListener* = ref object
  event*: sdl2.Event
```
An interface for SDL2 events. `event` contains all the event data.
Added to `World` by default.<br><br>

```nim
type KeyboardInput* = ref object
  keyState*: ptr array[0..SdlNumScancodes.int, uint8]
  downKeySet*, releasedKeySet*: PackedSet[int]
  heldFrameList*: seq[Natural]
```
An interface for keyboard input.

### fields
#### `keyState: ptr array[0..SdlNumScancodes.int, uint8]`
An array each element of which represents the state of a certain key. The indexes are each key's scancode. An element with a value of 1 means that the key is pressed and a value of 0 means that it is not.

#### `downKeySet: PackedSet[int]`
A set that contains scancodes of the keys currently pressed.

#### `releasedKeySet: PackedSet[int]`
A set that contains scancodes of the keys released in the current frame.

#### `heldFrameList: seq[Natural]`
A sequence each element of which represents how many frames the key is pressed.<br><br>

```nim
type MouseInput* = ref object
  downButtonSet*, releasedButtonSet*: PackedSet[uint8]
  heldFrameList*: seq[Natural]
  x*, y*: cint
  eventPosition*: Vector
```

### fields
#### `downButtonSet: PackedSet[uint8]`
A set that contains mouse button index(sdl2.BUTTON_XXX) of the mouse button currently pressed.

#### `releasedButtonSet: PackedSet[uint8]`
A set that contains mouse button index(sdl2.BUTTON_XXX) of the mouse button released in the current frame.

#### `heldFrameList: seq[Natural]`
A sequence each element of which represents how many frames the mouse button is clicked.

#### `x, y: cint`
The mouse position.

#### `eventPosition: Vector`
The position where mouse events occur. It points out the same position as above if there is no mouse event in a frame.

### procedures
```nim
proc getState*(input: MouseInput): uint8 =
```
Gets the state that represents which mouse button is clicked and update the mouse position. This procedure is called every frame by an internal system.

## Events
```nim
type
  ApplicationEvent* = object
    eventType*: ApplicationEventType

  ApplicationEventType* = enum
    Quit
```
ApplicationEvent is an event that handles the events about the entire application.<br><br>

```nim
type KeyboardEvent* = object
  heldKeys*, pressedKeys*, releasedKeys*: PackedSet[cint]
```
An event for notifying keyboard state. Please note that each field (`xxxKeys`) contains the keycodes, not scancodes.

### procedures
```nim
proc isDown*(event: KeyboardEvent, keycode: cint): bool
```
Returns whether the key `keycode` refers to is currently down.<br><br>

```nim
proc isHeld*(event: KeyboardEvent, keycode: cint): bool
```
Returns whether the key `keycode` refers to is currently held.<br><br>

```nim
proc isPressed*(event: KeyboardEvent, keycode: cint): bool
```
Returns whether the key `keycode` refers to is pressed in the current frame.<br><br>

```nim
proc isReleased*(event: KeyboardEvent, keycode: cint): bool
```
Returns whether the key `keycode` refers to is released in the current frame.<br><br>

```nim
type MouseButtonEvent* = object
  heldButtons*, pressedButtons*, releasedButtons*: PackedSet[uint8]
  position: Vector
```
An event for notifying mouse button state. `position` represents where the event occurs.

### procedures
```nim
proc isDown*(event: MouseButtonEvent, button: uint8): bool
```
Returns whether the mouse button `button` refers to is currently down.<br><br>

```nim
proc isHeld*(event: MouseButtonEvent, button: uint8): bool
```
Returns whether the mouse button `button` refers to is currently held.<br><br>

```nim
proc isPressed*(event: MouseButtonEvent, button: uint8): bool
```
Returns whether the mouse button `button` refers to is pressed in the current frame.<br><br>

```nim
proc isReleased*(event: MouseButtonEvent, button: uint8): bool
```
Returns whether the mouse button `button` refers to is released in the current frame.<br><br>


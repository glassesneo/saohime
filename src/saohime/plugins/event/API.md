# EventPlugin
This plugin implements several interfaces for handling SDL2 events. Either resources or events are available for dealing with user input.

## Resources
```nim
type EventListener* = ref object
  event*: sdl2.Event
```
An interface for SDL2 events. `event` contains all the event data.
<br><br>

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
<br><br>

#### `downKeySet: PackedSet[int]`
A set that contains scancodes of the keys currently pressed.
<br><br>

#### `releasedKeySet: PackedSet[int]`
A set that contains scancodes of the keys released in the current frame.
<br><br>

#### `heldFrameList: seq[Natural]`
A sequence each element of which represents how many frames the key is pressed.
<br><br>

```nim
type MouseInput* = ref object
  downButtonSet*, releasedButtonSet*: PackedSet[uint8]
  heldFrameList*: seq[Natural]
  x*, y*: cint
  eventPosition*: Vector
```

### fields
#### `downButtonSet: PackedSet[uint8]`
A set that contains indeces(sdl2.BUTTON_XXX) of the mouse buttons currently pressed.
<br><br>

#### `releasedButtonSet: PackedSet[uint8]`
A set that contains indeces(sdl2.BUTTON_XXX) of the mouse buttons released in the current frame.
<br><br>

#### `heldFrameList: seq[Natural]`
A sequence each element of which represents how many frames the mouse button is clicked.
<br><br>

#### `x, y: cint`
The mouse position.
<br><br>

#### `eventPosition: Vector`
The position where mouse events occur. It points out the same position as above if there is no mouse event in a frame.
<br><br>

### procedures
```nim
proc getState*(input: MouseInput): uint8 =
```
Gets the state that represents which mouse button is clicked and update the mouse position. This procedure is called every frame by an internal system.
<br><br>

```nim
type
  ControllerManager* = ref object
```

### procedures
```nim
proc register*(manager: ControllerManager, device: ControllerDevice)
```
Registers `device` to get the state of the controller.
<br><br>

```nim
proc unregister*(manager: ControllerManager, device: ControllerDevice)
```
Unregisters `device`.
<br><br>

```nim
proc `[]`*(manager: ControllerManager, device: ControllerDevice): ControllerInput
```
Gets `ControllerInput` which corresponds `device`.

## Components
```nim
type
  ControllerDevice* = ref object
    deadZone*: Natural
    input*: ControllerInput
```
Represents the controller itself.

### constructor
```nim
proc new*(T: type ControllerDevice, index: int, deadZone: Natural = 0): T
```

### fields
#### `deadZone: Natural`
Sets the dead zone where the input from the controller is ignored.
<br><br>

#### `input: ControllerInput`
Represents the state of the controller.

### procedures
```nim
proc controller*(device: ControllerDevice): GameControllerPtr
```
Returns `sdl2.GameControllerPtr`.
<br><br>

```nim
proc id*(device: ControllerDevice): JoystickID
```
Returns `sdl2.JoystickID`.

## Types
```nim
type
  ControllerInput* = ref object
    leftStickDirection*, rightStickDirection*: Vector
    leftStickMotion*, rightStickMotion*: Vector
    leftTrigger*, rightTrigger*: uint
    downButtonSet*, releasedButtonSet*: set[GameControllerButton]
    heldFrameList*: array[GameControllerButton, Natural]
```
The state of the controller.

### fields
#### `leftStickDirection, rightStickDirection: Vector`
Stands for the left/right stick's direction. A value of 1 means left in x axis and down in y axis, and a value of 0 means right in x axis and up in y axis. Affected by `ControllerDevice.deadZone`.
<br><br>

#### `leftStickMotion, rightStickMotion: Vector`
The concrete values of the analog sticks that takes a number between -32768 and 32767. Not affected by `ControllerDevice.deadZone`.
<br><br>

#### `leftTrigger, rightTrigger: uint`
The concrete values of the analog triggers that takes a number between 0 and 32767. Not affected by `ControllerDevice.deadZone`. Note that on some controllers like Nintendo Switch, the triggers are implemented as the digital buttons, which only takes a value of 0 or 32768.
<br><br>

#### `downButtonSet: PackedSet[uint8]`
A set that contains indeces(sdl2/gamecontroller.GameControllerButton) of the controller buttons currently pressed.
<br><br>

#### `releasedButtonSet: PackedSet[uint8]`
A set that contains indeces(sdl2/gamecontroller.GameControllerButton) of the controller buttons released in the current frame.
<br><br>

#### `heldFrameList: seq[Natural]`
A sequence each element of which represents how many frames the controller button is held.

## Events
```nim
type
  ApplicationEvent* = object
    eventType*: ApplicationEventType

  ApplicationEventType* = enum
    Quit
```
ApplicationEvent is an event that handles the events about the entire application.
<br><br>

```nim
type KeyboardEvent* = object
  heldKeys*, pressedKeys*, releasedKeys*: PackedSet[cint]
```
An event for notifying keyboard state. Please note that each field (`xxxKeys`) contains the keycodes, not scancodes.

### procedures
```nim
proc isDown*(event: KeyboardEvent, keycode: cint): bool
```
Returns whether the key `keycode` refers to is currently down.
<br><br>

```nim
proc isHeld*(event: KeyboardEvent, keycode: cint): bool
```
Returns whether the key `keycode` refers to is currently held.
<br><br>

```nim
proc isPressed*(event: KeyboardEvent, keycode: cint): bool
```
Returns whether the key `keycode` refers to is pressed in the current frame.
<br><br>

```nim
proc isReleased*(event: KeyboardEvent, keycode: cint): bool
```
Returns whether the key `keycode` refers to is released in the current frame.
<br><br>

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
Returns whether the mouse button `button` refers to is currently down.
<br><br>

```nim
proc isHeld*(event: MouseButtonEvent, button: uint8): bool
```
Returns whether the mouse button `button` refers to is currently held.
<br><br>

```nim
proc isPressed*(event: MouseButtonEvent, button: uint8): bool
```
Returns whether the mouse button `button` refers to is pressed in the current frame.
<br><br>

```nim
proc isReleased*(event: MouseButtonEvent, button: uint8): bool
```
Returns whether the mouse button `button` refers to is released in the current frame.
<br><br>


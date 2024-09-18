import
  pkg/[sdl2/joystick],
  pkg/seiryu

type
  JoystickController* = ref object
    joystick: JoystickPtr
    id: JoystickID

proc new*(
    T: type JoystickController,
    joystick: JoystickPtr,
    id: JoystickID
): T {.construct.}

proc joystick*(input: JoystickController): JoystickPtr {.getter.}

proc id*(input: JoystickController): JoystickID {.getter.}


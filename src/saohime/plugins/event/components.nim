import
  pkg/[sdl2/joystick, sdl2/gamecontroller],
  pkg/seiryu,
  ../../core/saohime_types,
  ../../core/sdl2_helpers

type
  ControllerInput* = ref object
    leftStickDirection*, rightStickDirection*: Vector
    leftStickMotion*, rightStickMotion*: Vector
    # leftTrigger*, rightTrigger*: uint
    downButtonSet*, releasedButtonSet*: set[GameControllerButton]
    heldFrameList*: array[GameControllerButton, Natural]

  ControllerDevice* = ref object
    controller: GameControllerPtr
    id: JoystickID
    deadZone*: Natural
    input*: ControllerInput

proc new*(T: type ControllerInput): T {.construct.} =
  result.leftStickDirection = ZeroVector
  result.rightStickDirection = ZeroVector
  result.leftStickMotion = ZeroVector
  result.rightStickMotion = ZeroVector

proc new*(
    T: type ControllerDevice,
    index: int,
    deadZone: Natural = 0
): T {.construct.} =
  result.controller = openController(index)
  result.id = result.controller.getJoystick().instanceID()
  result.deadZone = deadZone
  result.input = ControllerInput.new()

proc controller*(device: ControllerDevice): GameControllerPtr {.getter.}

proc id*(device: ControllerDevice): JoystickID {.getter.}


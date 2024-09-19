import
  std/[lenientops, packedsets],
  pkg/ecslib,
  pkg/[sdl2, sdl2/gamecontroller],
  ./components,
  ./events,
  ./resources

proc checkHeldInput*(
    keyboard: Resource[KeyboardInput],
    mouse: Resource[MouseInput],
    deviceQuery: [All[ControllerDevice]]
) {.system.} =
  for scancode in keyboard.downKeySet:
    if keyboard.keyState[scancode.int] == 1:
      keyboard.heldFrameList[scancode.int] += 1

  let mouseState = mouse.getState()
  mouse.eventPosition.x = mouse.x.float
  mouse.eventPosition.y = mouse.y.float
  for button in mouse.downButtonSet:
    if (mouseState and SdlButton(button)) == 1:
      mouse.heldFrameList[button] += 1

  for _, device in deviceQuery[ControllerDevice]:
    let input = device.input
    for button in input.downButtonSet:
      if device.controller.getButton(cast[GameControllerButton](button)) == 1:
        input.heldFrameList[button] += 1

proc readSDL2Events*(
    listener: Resource[EventListener],
    keyboard: Resource[KeyboardInput],
    mouse: Resource[MouseInput],
    controllerManager: Resource[ControllerManager]
) {.system.} =
  while listener.pollEvent():
    case listener.event.kind
    of sdl2.QuitEvent:
      commands.dispatchEvent(ApplicationEvent.new(
        eventType = ApplicationEventType.Quit
      ))

    of sdl2.KeyDown:
      let scancodeIndex = listener.event.key.keysym.scancode.ord()
      if not listener.event.key.repeat:
        keyboard.downKeySet.incl scancodeIndex
        keyboard.heldFrameList[scancodeIndex] = 1

    of sdl2.KeyUp:
      let scancodeIndex = listener.event.key.keysym.scancode.ord()
      keyboard.downKeySet.excl scancodeIndex
      keyboard.heldFrameList[scancodeIndex] = 0
      keyboard.releasedKeySet.incl scancodeIndex

    of sdl2.MouseButtonDown:
      let button = listener.event.button.button
      mouse.downButtonSet.incl button
      mouse.heldFrameList[button] = 1
      mouse.eventPosition.x = listener.event.button.x.float
      mouse.eventPosition.y = listener.event.button.y.float

    of sdl2.MouseButtonUp:
      let button = listener.event.button.button
      mouse.downButtonSet.excl button
      mouse.heldFrameList[button] = 0
      mouse.releasedButtonSet.incl button
      mouse.eventPosition.x = listener.event.button.x.float
      mouse.eventPosition.y = listener.event.button.y.float

    of sdl2.ControllerAxisMotion:
      let controllerAxis = listener.event.caxis
      let controllerInput = controllerManager.inputList[controllerAxis.which]

      case controllerAxis.axis
      of SDLControllerAxisLeftX:
        controllerInput.leftStickMotion.x = controllerAxis.value.float

        if controllerAxis.value > 0:
          controllerInput.leftStickDirection.x = 1
        elif controllerAxis.value < 0:
          controllerInput.leftStickDirection.x = -1
        else:
          controllerInput.leftStickDirection.x = 0

      of SDLControllerAxisLeftY:
        controllerInput.leftStickMotion.y = controllerAxis.value.float

        if controllerAxis.value > 0:
          controllerInput.leftStickDirection.y = 1
        elif controllerAxis.value < 0:
          controllerInput.leftStickDirection.y = -1
        else:
          controllerInput.leftStickDirection.y = 0

      of SDLControllerAxisRightX:
        controllerInput.rightStickMotion.x = controllerAxis.value.float

        if controllerAxis.value > 0:
          controllerInput.rightStickDirection.x = 1
        elif controllerAxis.value < 0:
          controllerInput.rightStickDirection.x = -1
        else:
          controllerInput.rightStickDirection.x = 0

      of SDLControllerAxisRightY:
        controllerInput.rightStickMotion.y = controllerAxis.value.float

        if controllerAxis.value > 0:
          controllerInput.rightStickDirection.y = 1
        elif controllerAxis.value < 0:
          controllerInput.rightStickDirection.y = -1
        else:
          controllerInput.rightStickDirection.y = 0

      else:
        discard

    of sdl2.ControllerButtonDown:
      let controllerButton = listener.event.cbutton
      let controllerInput = controllerManager.inputList[controllerButton.which]
      let button = controllerButton.button
      controllerInput.downButtonSet.incl button
      controllerInput.heldFrameList[button] = 1

    of sdl2.ControllerButtonUp:
      let controllerButton = listener.event.cbutton
      let controllerInput = controllerManager.inputList[controllerButton.which]
      let button = controllerButton.button
      controllerInput.downButtonSet.excl button
      controllerInput.heldFrameList[button] = 0
      controllerInput.releasedButtonSet.incl button

    else:
      discard

proc validateStickMotionDeadZone*(
    deviceQuery: [All[ControllerDevice]]
) {.system.} =
  for _, device in deviceQuery[ControllerDevice]:
    let input = device.input
    if input.leftStickMotion.x in -device.deadZone..device.deadZone:
      input.leftStickDirection.x = 0

    if input.leftStickMotion.y in -device.deadZone..device.deadZone:
      input.leftStickDirection.y = 0

    if input.rightStickMotion.x in -device.deadZone..device.deadZone:
      input.rightStickDirection.x = 0

    if input.rightStickMotion.y in -device.deadZone..device.deadZone:
      input.rightStickDirection.y = 0

proc dispatchKeyboardEvent*(keyboard: Resource[KeyboardInput]) {.system.} =
  if keyboard.downKeySet.len + keyboard.releasedKeySet.len == 0:
    return

  var heldKeys, pressedKeys, releasedKeys = initPackedSet[cint]()
  for scancode in keyboard.releasedKeySet:
    releasedKeys.incl getKeyFromScancode(cast[Scancode](scancode))

  for scancode in keyboard.downKeySet:
    if keyboard.heldFrameList[scancode] == 1:
      pressedKeys.incl getKeyFromScancode(cast[Scancode](scancode))
    else:
      heldKeys.incl getKeyFromScancode(cast[Scancode](scancode))

  let event = KeyboardEvent.new(
    heldKeys = heldKeys,
    pressedKeys = pressedKeys,
    releasedKeys = releasedKeys
  )
  keyboard.releasedKeySet.clear()

  commands.dispatchEvent(event)

proc dispatchMouseEvent*(mouse: Resource[MouseInput]) {.system.} =
  if mouse.downButtonSet.len + mouse.releasedButtonSet.len == 0:
    return

  var heldButtons, pressedButtons, releasedButtons = initPackedSet[uint8]()
  for button in mouse.releasedButtonSet:
    releasedButtons.incl button

  for button in mouse.downButtonSet:
    if mouse.heldFrameList[button] == 1:
      pressedButtons.incl button
    else:
      heldButtons.incl button

  let event = MouseButtonEvent.new(
    heldButtons = heldButtons,
    pressedButtons = pressedButtons,
    releasedButtons = releasedButtons,
    position = mouse.eventPosition
  )
  mouse.releasedButtonSet.clear()

  commands.dispatchEvent(event)


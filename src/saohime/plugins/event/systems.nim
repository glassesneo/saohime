import
  std/[packedsets],
  pkg/ecslib,
  pkg/[sdl2, sdl2/joystick],
  ./components,
  ./events,
  ./resources

proc readSDL2Events*(
    listener: Resource[EventListener],
    keyboard: Resource[KeyboardInput],
    mouse: Resource[MouseInput],
    joystickManager: Resource[JoystickManager],
    joystickControllerQuery: [All[JoystickController]]
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

  for _, controller in joystickControllerQuery[JoystickController]:
    let joystick = joystickManager[controller]
    for button in joystick.downButtonSet:
      if controller.joystick.getButton(button.cint) == 1:
        joystick.heldFrameList[button] += 1

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

    of sdl2.JoyAxisMotion:
      let joystickAxis = listener.event.jaxis
      let joystick = joystickManager.joystickList[joystickAxis.which]

      case joystickAxis.axis
      # X axis motion
      of 0:
        joystick.values.x = joystickAxis.value.float

        if joystickAxis.value in -joystick.deadZone..joystick.deadZone:
          joystick.direction.x = 0
          continue

        if joystickAxis.value > 0:
          joystick.direction.x = 1
        elif joystickAxis.value < 0:
          joystick.direction.x = -1
        else:
          joystick.direction.x = 0
      # Y axis motion
      of 1:
        joystick.values.y = joystickAxis.value.float

        if joystickAxis.value in -joystick.deadZone..joystick.deadZone:
          joystick.direction.y = 0
          continue

        if joystickAxis.value > 0:
          joystick.direction.y = 1
        elif joystickAxis.value < 0:
          joystick.direction.y = -1
        else:
          joystick.direction.y = 0

      else:
        discard

    of sdl2.JoyButtonDown:
      let joystickButton = listener.event.jbutton
      let joystick = joystickManager.joystickList[joystickButton.which]
      let button = joystickButton.button
      joystick.downButtonSet.incl button
      joystick.heldFrameList[button] = 1

    of sdl2.JoyButtonUp:
      let joystickButton = listener.event.jbutton
      let joystick = joystickManager.joystickList[joystickButton.which]
      let button = joystickButton.button
      joystick.downButtonSet.excl button
      joystick.heldFrameList[button] = 0
      joystick.releasedButtonSet.incl button

    else:
      discard

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

proc disconnectJoysticks*(
    manager: Resource[JoystickManager],
    joystickQuery: [All[JoystickController]]
) {.system.} =
  for _, joystick in joystickQuery[JoystickController]:
    manager.disconnect(joystick)


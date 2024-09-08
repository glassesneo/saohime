import
  std/[packedsets],
  pkg/[ecslib, sdl2],
  ./events,
  ./resources

proc readSDL2Events*(
    listener: Resource[EventListener],
    keyboard: Resource[KeyboardInput],
    mouse: Resource[MouseInput]
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


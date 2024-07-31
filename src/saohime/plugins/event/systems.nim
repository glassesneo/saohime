import
  pkg/[ecslib, sdl2],
  ./events,
  ./resources

proc dispatchSDL2Events*(
    listener: Resource[EventListener],
    mouseInput: Resource[MouseInput]
) {.system.} =
  let mouseState = mouseInput.getMouseState()

  var doneMouseButtonEvent = false

  while listener.pollEvent():
    case listener.event.kind
    of sdl2.QuitEvent:
      commands.dispatchEvent(ApplicationEvent.new(
        eventType = ApplicationEventType.Quit
      ))

    of sdl2.KeyDown:
      commands.dispatchEvent(KeyboardEvent.new(
        eventType = KeyboardEventType.KeyPressed,
        currentKey = listener.event.key.keysym.sym,
        keyState = listener.keyState
      ))
    of sdl2.KeyUp:
      commands.dispatchEvent(KeyboardEvent.new(
        eventType = KeyboardEventType.KeyReleased,
        currentKey = listener.event.key.keysym.sym,
        keyState = listener.keyState
      ))

    of sdl2.MouseButtonDown:
      commands.dispatchEvent(MouseEvent.new(
        eventType = MouseEventType.MouseButtonPressed,
        currentButton = listener.event.button.button,
        position = mouseInput.position,
        mouseState = mouseState
      ))
      doneMouseButtonEvent = true
    of sdl2.MouseButtonUp:
      commands.dispatchEvent(MouseEvent.new(
        eventType = MouseEventType.MouseButtonReleased,
        currentButton = listener.event.button.button,
        position = mouseInput.position,
        mouseState = mouseState
      ))
      doneMouseButtonEvent = true
    else:
      discard

  if not doneMouseButtonEvent and mouseState != 0:
    commands.dispatchEvent(MouseEvent.new(
      eventType = MouseEventType.MouseButtonDown,
      position = mouseInput.position,
      mouseState = mouseState
    ))


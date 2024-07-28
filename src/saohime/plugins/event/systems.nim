import
  pkg/[ecslib, sdl2],
  ../../core/[saohime_types],
  ./events,
  ./resources

proc dispatchSDL2Events*(listener: Resource[EventListener]) {.system.} =
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
      var x, y: cint
      let mouseState = getMouseState(addr x, addr y)

      commands.dispatchEvent(MouseEvent.new(
        eventType = MouseEventType.MouseButtonPressed,
        currentButton = listener.event.button.button,
        position = Vector.new(x.float, y.float),
        mouseState = mouseState
      ))
    of sdl2.MouseButtonUp:
      var x, y: cint
      let mouseState = getMouseState(addr x, addr y)

      commands.dispatchEvent(MouseEvent.new(
        eventType = MouseEventType.MouseButtonReleased,
        currentButton = listener.event.button.button,
        position = Vector.new(x.float, y.float),
        mouseState = mouseState
      ))
    else:
      discard

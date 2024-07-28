import
  pkg/[ecslib, sdl2],
  ./events,
  ./resources

proc dispatchSDL2Events*(listener: Resource[EventListener]) {.system.} =
  while listener.pollEvent():
    case listener.event.kind
    of sdl2.QuitEvent:
      commands.dispatchEvent(ApplicationEvent.new(
        event = listener.event,
        eventType = ApplicationEventType.Quit
      ))
    of sdl2.KeyDown:
      commands.dispatchEvent(KeyboardEvent.new(
        event = listener.event,
        eventType = KeyboardEventType.KeyDown,
        key = listener.currentKey
      ))
    of sdl2.KeyUp:
      commands.dispatchEvent(KeyboardEvent.new(
        event = listener.event,
        eventType = KeyboardEventType.KeyUp,
        key = listener.currentKey
      ))
    of sdl2.MouseButtonDown:
      commands.dispatchEvent(MouseEvent.new(
        event = listener.event,
        eventType = MouseEventType.MouseButtonDown,
        button = listener.currentButton
      ))
    of sdl2.MouseButtonUp:
      commands.dispatchEvent(MouseEvent.new(
        event = listener.event,
        eventType = MouseEventType.MouseButtonUp,
        button = listener.currentButton
      ))
    else:
      discard

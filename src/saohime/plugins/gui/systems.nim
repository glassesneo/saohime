import
  pkg/[ecslib, sdl2],
  ../../core/[saohime_types],
  ../event/event,
  ../transform/transform,
  ./components,
  ./events

proc dispatchClickEvent*(
    All: [Button, Transform],
    mouseEvent: Event[MouseEvent]
) {.system.} =
  for e in mouseEvent:
    for button, transform in each(entities, [Button, Transform]):
      if not button.enabled:
        continue

      let
        position = transform.position
        size = button.size

      if position <= e.position and e.position <= position + size:
        if e.isPressed(ButtonLeft):
          button.pressed = true
          commands.dispatchEvent(ButtonEvent(
            entityId: entity.id,
            actionType: Pressed
          ))
        if e.isReleased(ButtonLeft):
          button.pressed = false
          commands.dispatchEvent(ButtonEvent(
            entityId: entity.id,
            actionType: Released
          ))
      elif button.pressed and e.isReleased(ButtonLeft):
        button.pressed = false
        commands.dispatchEvent(ButtonEvent(
          entityId: entity.id,
          actionType: Released
        ))

proc changeButtonColor*(
    All: [Button],
    buttonEvent: Event[ButtonEvent]
) {.system.} =
  for e in buttonEvent:
    case e.actionType
    of Pressed:
      let button = commands.getEntity(e.entityId).get(Button)
      button.currentColor = button.pressedColor
    of Released:
      let button = commands.getEntity(e.entityId).get(Button)
      button.currentColor = button.normalColor


import
  pkg/[ecslib, sdl2],
  ../../core/[saohime_types],
  ../event/event,
  ../transform/transform,
  ./components,
  ./events

proc dispatchClickEvent*(
    All: [Transform, Button],
    mouseEvent: Event[MouseEvent]
) {.system.} =
  for e in mouseEvent:
    if e.isPressed(ButtonLeft):
      for transform, button in each(entities, [Transform, Button]):
        let
          position = transform.position
          size = button.size

        if position <= e.position and e.position <= position + size:
          commands.dispatchEvent(ButtonEvent(
            entityId: entity.id,
            actionType: Click
          ))


import
  pkg/[ecslib]

type
  ActionType* = enum
    Pressed
    Released

  ButtonEvent* = ref object
    entityId*: EntityId
    actionType*: ActionType


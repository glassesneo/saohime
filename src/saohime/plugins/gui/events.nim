import
  pkg/[ecslib]

type
  ActionType* = enum
    Pressed
    Released

  ButtonEvent* = object
    entityId*: EntityId
    actionType*: ActionType


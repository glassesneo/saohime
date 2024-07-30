import
  pkg/[ecslib]

type
  ActionType* = enum
    Click
    RightClick

  ButtonEvent* = ref object
    entityId*: EntityId
    actionType*: ActionType


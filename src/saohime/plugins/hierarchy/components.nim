import pkg/[ecslib, seiryu]

type
  Parent* = ref object
    parentId: EntityId

  Children* = ref object
    childIdList: set[EntityId]

proc new*(T: type Parent, parent: Entity): T {.construct.} =
  result.parentId = parent.id

proc new*(T: type Children, children: seq[Entity]): T {.construct.} =
  for child in children:
    result.childIdList.incl child.id

proc ChildrenBundle*(entity: Entity, children: seq[Entity]): Entity =
  return entity.withBundle((Children.new(children),))

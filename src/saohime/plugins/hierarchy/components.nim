import
  pkg/ecslib,
  pkg/seiryu

type
  Parent* = ref object
    parentId: EntityId

  Children* = ref object
    childIdList: set[EntityId]

proc new*(T: Parent; parent: Entity): T {.construct.} =
  result.parentId = parent.id

proc new*(T: Children; children: varargs[Entity]): T {.construct.} =
  for child in children:
    result.childIdList.incl child

proc ChildrenBundle*(entity: Entity; children: varargs[Entity]): Entity =
  return entity.withBundle(Children.new(children))


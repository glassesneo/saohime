import
  pkg/[ecslib],
  ../../../src/saohime

type
  CollisionEvent* = ref object
    entityId1*, entityId2*: EntityId
    normal*: Vector


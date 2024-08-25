import
  pkg/[ecslib],
  ./components,
  ./events,
  ./resources,
  ./systems

type
  PhysicsPlugin* = ref object

proc build*(plugin: PhysicsPlugin, world: World) =
  world.addResource(Gravity.new())
  world.addEvent(CollisionEvent)
  world.registerSystems(addGravity, motion, checkCollision)

export
  components,
  events,
  resources,
  systems


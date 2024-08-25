import
  ../../../src/saohime

type
  Rigidbody* = ref object
    mass*: float
    velocity*, force*: Vector
    useGravity*: bool

  RectangleCollider* = ref object
    size*: Vector

proc new*(
    _: type Rigidbody,
    mass: float,
    velocity = ZeroVector,
    force = ZeroVector,
    useGravity = false
): Rigidbody =
  return Rigidbody(
    mass: mass,
    velocity: velocity,
    force: force,
    useGravity: useGravity
  )

proc acceleration*(rb: Rigidbody): Vector =
  return rb.force / rb.mass

proc addForce*(
    rb: Rigidbody,
    x: float = 0f,
    y: float = 0f
) =
  rb.force.x += x
  rb.force.y += y

proc new*(_: type RectangleCollider, size: Vector): RectangleCollider =
  return RectangleCollider(size: size)


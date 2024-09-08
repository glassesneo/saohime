import
  std/[colors, random, times],
  ../src/saohime,
  ../src/saohime/default_plugins

type
  RigidBody = ref object
    mass*: float
    velocity*: Vector

proc new*(_: type RigidBody, velocity: Vector): RigidBody =
  return RigidBody(velocity: velocity)

let time = cpuTime()
var count = 0

proc benchmark {.system.} =
  echo "Time taken: ", cpuTime() - time

proc generateObjects* {.system.} =
  block:
    let velX = rand(0f..150f)
    let velY = rand(0f..150f)
    let length = rand(5f..30f)
    commands.create()
      .attach(Circle.new(radius = length))
      .attach(Transform.new(x = rand(0f..50f), y = rand(0f..50f)))
      .attach(Material.new(fill = colWhite.toSaohimeColor()))
      .attach(Rigidbody.new(Vector.new(velX, velY)))

  block:
    let velX = rand(50f..150f)
    let velY = rand(50f..150f)
    let length = rand(5f..30f)
    commands.create()
      .attach(Rectangle.new(length, length))
      .attach(Transform.new(x = rand(0f..50f), y = rand(0f..50f)))
      .attach(Material.new(fill = colWhite.toSaohimeColor()))
      .attach(Rigidbody.new(Vector.new(velX, velY)))

  count += 1

  if count mod 10 == 0:
    echo count

  if count == 250:
    echo "Time taken: ", cpuTime() - time

  if count == 500:
    let app = commands.getResource(Application)
    app.terminate()

proc changeColor(entities: [All[Material]]) {.system.} =
  for material in each(entities, [Material]):
    material.fill.r = rand(255)
    material.fill.g = rand(255)
    material.fill.b = rand(255)

proc move(
    entities: [All[RigidBody, Transform]],
    fpsManager: Resource[FPSManager]
) {.system.} =
  let dt = fpsManager.deltaTime
  for rb, tf in each(entities, [Rigidbody, Transform]):
    tf.position += rb.velocity * dt

proc deleteObjects(
    entities: [All[Transform]],
    window: Resource[Window]
) {.system.} =
  let (w, h) = window.size
  let windowSize = Vector.new(w.float, h.float)
  for entity in entities:
    let tf = entity[Transform]
    if windowSize < tf.position:
      entity.delete()

let app = Application.new()

randomize()

app.loadPluginGroup(DefaultPlugins)


app.start:
  world.registerSystems(generateObjects, changeColor, move, deleteObjects)
  world.registerTerminateSystems(benchmark)
  world.updateResource(FPSManager(fps: 60))


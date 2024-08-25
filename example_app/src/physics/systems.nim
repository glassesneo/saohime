import
  std/[tables],
  pkg/[ecslib],
  ../../../src/saohime,
  ../../../src/saohime/default_plugins,
  ./components,
  ./events,
  ./resources

proc addGravity*(
    query: [All[Rigidbody]],
    gravity: Resource[Gravity]
) {.system.} =
  for entity in query:
    let rb = entity.get(Rigidbody)
    if not rb.useGravity:
      continue

    let w = rb.mass * gravity.g
    rb.addForce(y = w)

proc motion*(
    query: [All[Rigidbody, Transform]],
    fpsManager: Resource[FPSManager]
) {.system.} =
  let dt = fpsManager.deltaTime
  for rb, tf in each(query, [Rigidbody, Transform]):
    rb.velocity += rb.acceleration * dt
    tf.position += rb.velocity * dt

proc checkCollision*(
    query: [All[Rigidbody, Transform, RectangleCollider]],
) {.system.} =
  for i in 0..<query.len():
    let
      e1 = query[i]
      rect1 = e1.get(RectangleCollider)
      tf1 = e1.get(Transform)

    let
      left1 = tf1.position.x
      right1 = left1 + rect1.size.x
      top1 = tf1.position.y
      bottom1 = top1 + rect1.size.y

    for j in i+1..<query.len():
      let
        e2 = query[j]
        rect2 = e2.get(RectangleCollider)
        tf2 = e2.get(Transform)

      let
        left2 = tf2.position.x
        right2 = left2 + rect2.size.x
        top2 = tf2.position.y
        bottom2 = top2 + rect2.size.y
      if
        left1 <= right2 and
        left2 <= right1 and
        top1 <= bottom2 and
        top2 <= bottom1:
          let event = CollisionEvent(entityId1: e1.id, entityId2: e2.id)

          let
            boxCenter1 = tf1.position + rect1.size / 2
            boxCenter2 = tf2.position + rect2.size / 2
            delta = boxCenter2 - boxCenter1

          let
            diffX = min(abs(left1 - right2), abs(left2 - right1))
            diffY = min(abs(top1 - bottom2), abs(top2 - bottom1))

          let collisionNormal = if diffX < diffY:
            if delta.x > 0: Vector.new(1f, 0f)
            else: Vector.new(-1f, 0f)
          else:
            if delta.y > 0: Vector.new(0f, 1f)
            else: Vector.new(0f, -1f)

          event.normal = collisionNormal
          commands.dispatchEvent(event)


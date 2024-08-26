import
  std/[sugar],
  pkg/[ecslib],
  ../../core/saohime_types,
  ../render/render,
  ../transform/transform,
  ../window/window,
  ./components

proc initializeCamera*(
    window: Resource[Window]
) {.system.} =
  let size = window.size()
  commands.create()
    .CameraBundle(
      size = size.toVector(),
      isActive = true
    )

proc setViewport*(
    cameraQuery: [All[Camera]],
    renderer: Resource[Renderer],
) {.system.} =
  for camera, transform in each(cameraQuery, [Camera, Transform]):
    let virtualCameraSize = map(
      camera.size, transform.scale,
      (a, b: float) => a / b
    )
    let diff = camera.size - virtualCameraSize
    let virtualCameraPosition = transform.position + diff / 2
    commands.updateResource(GlobalScale(scale: transform.scale))
    renderer.setViewport(-(virtualCameraPosition), transform.position + camera.size)


import
  std/[sugar],
  pkg/[ecslib],
  ../../core/saohime_types,
  ../render/render,
  ../transform/transform,
  ../window/window,
  ./resources

proc initializeCamera*(
    camera: Resource[Camera],
    window: Resource[Window]
) {.system.} =
  let size = window.size()
  camera.size = Vector.new(size.x.float, size.y.float)

proc setViewport*(
    camera: Resource[Camera],
    renderer: Resource[Renderer],
) {.system.} =
  let virtualCameraSize = map(
    camera.size, camera.zoom,
    (a, b: float) => a / b
  )
  let diff = camera.size - virtualCameraSize
  let virtualCameraPosition = camera.position + diff / 2
  commands.updateResource(GlobalScale(scale: camera.zoom))
  renderer.setViewport(-(virtualCameraPosition), camera.position + camera.size)


import
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

proc setCamera*(
    camera: Resource[Camera],
    renderer: Resource[Renderer],
) {.system.} =
  renderer.setViewport(-camera.position, camera.position + camera.size)
  commands.updateResource(GlobalScale(scale: camera.zoom))


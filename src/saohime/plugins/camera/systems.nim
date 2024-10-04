import std/sugar
import pkg/ecslib
import ../../core/saohime_types
import ../render/render, ../transform/transform, ../window/window
import ./components

proc initializeCamera*(window: Resource[Window]) {.system.} =
  let camera = commands.create()
  camera.CameraBundle(size = window.getSize(), isActive = true)

proc setViewport*(cameraQuery: [All[Camera]], renderer: Resource[Renderer]) {.system.} =
  for _, camera, transform in cameraQuery[Camera, Transform]:
    let virtualCameraSize = map(camera.size, transform.scale, (a, b: float) => a / b)
    let diff = camera.size - virtualCameraSize
    let virtualCameraPosition = transform.position + diff / 2
    commands.updateResource(GlobalScale(scale: transform.scale))
    renderer.setViewport(-(virtualCameraPosition), transform.position + camera.size)

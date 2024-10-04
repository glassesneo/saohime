import pkg/ecslib
import ../../core/sdl2_helpers
import ./resources

proc createSaohimeWindow*(args: Resource[WindowArgs]) {.system.} =
  let window = Window.new(
    createWindow(
      title = args.title,
      x = args.position.x,
      y = args.position.y,
      width = args.size.x,
      height = args.size.y,
      flags = args.flags,
    )
  )
  commands.addResource(window)
  commands.deleteResource(WindowArgs)

proc destroyWindow*(window: Resource[Window]) {.system.} =
  window.destroy()

import
  std/[importutils],
  pkg/[ecslib, sdl2],
  ../../core/application,
  ./resources

proc createWindow* {.system.} =
  let window = commands.getResource(Window)
  if commands.hasResource(WindowSettings):
    let settings = commands.getResource(WindowSettings)
    window.create(
      title = settings.title,
      x = settings.x,
      y = settings.y,
      width = settings.width,
      height = settings.height,
      flags = settings.flags
    )
  else:
    privateAccess(Application)
    let app = commands.getResource(Application)
    window.create(
      title = app.title,
      width = 640,
      height = 480,
      flags = SdlWindowResizable or SdlWindowShown
    )

proc destroyWindow* {.system.} =
  let window = commands.getResource(Window)
  window.destroy()


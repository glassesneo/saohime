import
  ./core/[application],
  ./plugins/asset/asset,
  ./plugins/camera/camera,
  ./plugins/event/event,
  ./plugins/graphics/graphics,
  ./plugins/hierarchy/hierarchy,
  ./plugins/render/render,
  ./plugins/sdl2/sdl2,
  ./plugins/times/times,
  ./plugins/transform/transform,
  ./plugins/window/window

type DefaultPlugins* = ref object

proc build*(group: DefaultPlugins, app: Application) =
  app.loadPlugin AssetPlugin
  app.loadPlugin SDL2Plugin
  app.loadPlugin WindowPlugin
  app.loadPlugin HierarchyPlugin
  app.loadPlugin GraphicsPlugin
  app.loadPlugin RenderPlugin
  app.loadPlugin CameraPlugin
  app.loadPlugin TimesPlugin
  app.loadPlugin EventPlugin
  app.loadPlugin TransformPlugin

export
  asset,
  camera,
  event,
  graphics,
  hierarchy,
  render,
  sdl2,
  times,
  transform,
  window


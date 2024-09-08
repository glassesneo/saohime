import
  ./core/[application],
  ./plugins/asset/asset,
  ./plugins/audio/audio,
  ./plugins/camera/camera,
  ./plugins/event/event,
  ./plugins/graphics/graphics,
  ./plugins/gui/gui,
  ./plugins/hierarchy/hierarchy,
  ./plugins/lua/lua,
  ./plugins/render/render,
  ./plugins/sdl2/sdl2,
  ./plugins/times/times,
  ./plugins/transform/transform,
  ./plugins/window/window

type DefaultPlugins* = ref object

proc build*(group: DefaultPlugins, app: Application) =
  app.loadPlugin SDL2Plugin
  app.loadPlugin WindowPlugin
  app.loadPlugin AudioPlugin
  app.loadPlugin HierarchyPlugin
  app.loadPlugin GraphicsPlugin
  app.loadPlugin RenderPlugin
  app.loadPlugin CameraPlugin
  app.loadPlugin AssetPlugin
  app.loadPlugin TimesPlugin
  app.loadPlugin EventPlugin
  app.loadPlugin TransformPlugin
  app.loadPlugin LuaPlugin
  app.loadPlugin GUIPlugin

export
  asset,
  audio,
  camera,
  event,
  graphics,
  gui,
  hierarchy,
  lua,
  render,
  sdl2,
  times,
  transform,
  window


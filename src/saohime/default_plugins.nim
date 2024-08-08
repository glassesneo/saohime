import
  pkg/[ecslib],
  ./core/[plugin],
  ./plugins/asset/asset,
  ./plugins/event/event,
  ./plugins/graphics/graphics,
  ./plugins/gui/gui,
  ./plugins/render/render,
  ./plugins/sdl2/sdl2,
  ./plugins/times/times,
  ./plugins/transform/transform,
  ./plugins/window/window

type DefaultPlugins* = ref object
  plugins*: seq[PluginTuple]

proc build*(group: DefaultPlugins) =
  group.add(SDL2Plugin.new())
  group.add(WindowPlugin.new())
  group.add(GraphicsPlugin.new())
  group.add(RenderPlugin.new())
  group.add(AssetPlugin.new())
  group.add(TimesPlugin.new())
  group.add(EventPlugin.new())
  group.add(TransformPlugin.new())
  group.add(GUIPlugin.new())

export
  asset,
  event,
  graphics,
  gui,
  render,
  sdl2,
  times,
  transform,
  window


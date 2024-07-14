import
  pkg/[ecslib],
  ./core/[plugin],
  ./plugins/event/event,
  ./plugins/render/render,
  ./plugins/sdl2/sdl2,
  ./plugins/transform/transform,
  ./plugins/window/window

type DefaultPlugins* = ref object
  group*: seq[PluginTuple]

proc build*(group: DefaultPlugins, world: World) =
  group.add(SDL2Plugin.new())
  group.add(WindowPlugin.new())
  group.add(RenderPlugin.new())
  group.add(EventPlugin.new())
  group.add(TransformPlugin.new())

export
  event,
  render,
  sdl2,
  transform,
  window

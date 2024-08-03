import
  std/[colors],
  pkg/[ecslib],
  ./core/[plugin, saohime_types],
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
  group.add(TimesPlugin.new())
  group.add(EventPlugin.new())
  group.add(TransformPlugin.new())
  group.add(GUIPlugin.new())

proc objectBundle*(
    entity: Entity;
    x, y: float;
    rotation: float = 0f;
    scale = Vector.new(1, 1);
    fill = colWhite.toSaohimeColor();
    stroke = SaohimeColor.new(colWhite, a = 0)
): Entity =
  return entity.withBundle((
    Transform.new(x, y, rotation, scale),
    Material.new(fill, stroke)
  ))

export
  event,
  graphics,
  gui,
  render,
  sdl2,
  times,
  transform,
  window


import
  std/[colors],
  pkg/[ecslib],
  ./core/[plugin],
  ./plugins/event/event,
  ./plugins/graphics/graphics,
  ./plugins/input/input,
  ./plugins/render/render,
  ./plugins/sdl2/sdl2,
  ./plugins/transform/transform,
  ./plugins/window/window

type DefaultPlugins* = ref object
  plugins*: seq[PluginTuple]

proc build*(group: DefaultPlugins) =
  group.add(SDL2Plugin.new())
  group.add(WindowPlugin.new())
  group.add(GraphicsPlugin.new())
  group.add(RenderPlugin.new())
  group.add(EventPlugin.new())
  group.add(InputPlugin.new())
  group.add(TransformPlugin.new())

proc objectBundle*(
    entity: Entity;
    x, y: float;
    rotation: float = 0f;
    scale = Vector.new(0, 0);
    color = colWhite;
    filled = true
): Entity =
  return entity.withBundle((
    Transform.new(x, y, rotation, scale),
    Material.new(color = color, filled = filled)
  ))

export
  event,
  graphics,
  input,
  render,
  sdl2,
  transform,
  window


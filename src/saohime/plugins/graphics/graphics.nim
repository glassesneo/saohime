import
  pkg/[ecslib],
  ./components,
  ./systems

type
  GraphicsPlugin* = ref object

proc build*(plugin: GraphicsPlugin, world: World) =
  world.registerSystemsAt("draw",
    renderPoint,
    renderLine,
    renderRectangleBackground, renderRectangleBorder,
    renderCircleBackground, renderCircleBorder
  )

export
  components


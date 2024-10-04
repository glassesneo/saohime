import pkg/[ecslib]
import ./[components, systems]

type GraphicsPlugin* = ref object

proc build*(plugin: GraphicsPlugin, world: World) =
  world.registerSystemsAt(
    "draw", renderPoint, renderLine, renderRectangleBackground, renderRectangleBorder,
    renderCircleBackground, renderCircleBorder,
  )
  world.registerSystemsAt("draw", renderPoint, renderLine)
  world.registerSystemsAt("draw", renderRectangleBackground, renderRectangleBorder)
  world.registerSystemsAt("draw", renderCircleBackground, renderCircleBorder)

export components

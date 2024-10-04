import std/sugar
import pkg/ecslib
import ../../core/saohime_types
import ../render/resources, ../transform/transform
import ./components

proc renderPoint*(
    points: [All[Point, Transform, Fill]],
    renderer: Resource[Renderer],
    globalScale: Resource[GlobalScale],
) {.system.} =
  for _, tf, fill in points[Transform, Fill]:
    let scale = map(globalScale.scale, tf.scale, (a, b: float) => a * b)
    renderer.setScale scale
    renderer.setColor fill.color
    renderer.drawPoint tf.position

proc renderLine*(
    lines: [All[Line, Transform, Fill]],
    renderer: Resource[Renderer],
    globalScale: Resource[GlobalScale],
) {.system.} =
  for _, line, tf, fill in lines[Line, Transform, Fill]:
    let position = tf.renderedPosition
    let scale = map(globalScale.scale, tf.scale, (a, b: float) => a * b)
    renderer.setScale scale
    renderer.setColor fill.color
    renderer.drawLine position, position + line.vector

proc renderRectangleBackground*(
    rectangles: [All[Rectangle, Transform, Fill]],
    renderer: Resource[Renderer],
    globalScale: Resource[GlobalScale],
) {.system.} =
  for _, rectangle, tf, fill in rectangles[Rectangle, Transform, Fill]:
    let scale = map(globalScale.scale, tf.scale, (a, b: float) => a * b)
    renderer.setScale scale
    renderer.setColor fill.color
    renderer.fillRectangle tf.renderedPosition, rectangle.size

proc renderRectangleBorder*(
    rectangles: [All[Rectangle, Transform, Border]],
    renderer: Resource[Renderer],
    globalScale: Resource[GlobalScale],
) {.system.} =
  for _, rectangle, tf, border in rectangles[Rectangle, Transform, Border]:
    let scale = map(globalScale.scale, tf.scale, (a, b: float) => a * b)
    renderer.setScale scale
    renderer.setColor border.color
    renderer.drawRectangle tf.renderedPosition, rectangle.size

proc renderCircleBackground*(
    circles: [All[Circle, Transform, Fill]],
    renderer: Resource[Renderer],
    globalScale: Resource[GlobalScale],
) {.system.} =
  for _, circle, tf, fill in circles[Circle, Transform, Fill]:
    let scale = map(globalScale.scale, tf.scale, (a, b: float) => a * b)
    renderer.setScale scale
    renderer.setColor fill.color
    renderer.fillCircle tf.renderedPosition, circle.radius

proc renderCircleBorder*(
    circles: [All[Circle, Transform, Border]],
    renderer: Resource[Renderer],
    globalScale: Resource[GlobalScale],
) {.system.} =
  for _, circle, tf, border in circles[Circle, Transform, Border]:
    let scale = map(globalScale.scale, tf.scale, (a, b: float) => a * b)
    renderer.setScale scale
    renderer.setColor border.color
    renderer.drawCircle tf.renderedPosition, circle.radius

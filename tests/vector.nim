discard """
  action: "run"
"""

import
  std/[math, unittest],
  ../src/saohime/core/saohime_types
let
  a = Vector.new(30, 30)
  b = Vector.new(10, 0)

let rad = a.heading()

check almostEqual(rad, arccos((a * b) / (a.len * b.len)))
check almostEqual(rad, arccos(a.normalized() * b.normalized()))


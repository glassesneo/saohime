discard """
  action: "run"
"""

import
  ../src/saohime

let app = App.new()

app.setup(
  title = "sample",
  width = 640,
  height = 480,
)

app.start:
  discard

discard """
  action: "run"
"""

import
  ../src/saohime

proc pollEvent {.system.} =
  let listener = command.getResource(EventListener)
  while listener.pollEvent:
    listener.checkQuitEvent()

let app = App.new()

app.setup(
  title = "sample",
  width = 640,
  height = 480,
)

app.start:
  world.registerSystems(pollEvent)

discard """
  action: "run"
"""

import
  ../src/saohime

proc pollQuitEvent {.system.} =
  let listener = command.getResource(EventListener)
  if listener.checkQuitEvent:
    sdl2Quit()

let app = App.new()

app.setup(
  title = "sample",
  width = 640,
  height = 480,
)

app.start:
  world.registerSystem(pollQuitEvent)

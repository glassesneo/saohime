discard """
  action: "run"
"""

import
  ../src/saohime

proc pollEvent {.system.} =
  let listener = commands.getResource(EventListener)
  while listener.pollEvent():
    if listener.checkQuitEvent():
      let appState = commands.getResource(AppState)
      appState.deactivateMainLoop()

let app = App.new()

app.setup(
  title = "sample",
  width = 640,
  height = 480,
)

app.start:
  world.registerSystems(pollEvent)

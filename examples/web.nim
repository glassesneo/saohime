import
  pkg/jsbind/emscripten,
  ../src/saohime

# let app = Application.new(title = "sample")

# proc hello {.system.} =
#   echo "Hello!"

# app.world.registerStartupSystems(hello)

# app.world.runStartupSystems()

var isFisrt = true
  # let handler = SDL2Handler.new()
  # handler.init()

proc mainLoop {.cdecl.} =
  # app.world.runSystems()
  if isFisrt:
    isFisrt = false
    echo "Hello"

emscripten_set_main_loop(mainLoop, 0, 1)


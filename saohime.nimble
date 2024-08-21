# Package

version = "0.1.0"
author = "glassesneo"
description = "An extensible 2D game engine for Nim"
license = "MIT"
srcDir = "src"
binDir = "bin"
installExt = @["nim"]
bin = @["saohime"]


# Dependencies

requires "nim >= 2.0.4"
requires "ecslib#head"
requires "sdl2#head"
requires "oolib"
requires "jsbind"
requires "slappy"

task tests, "Run all tests":
  exec "testament p 'tests/**.nim'"

task show, "Show testresults":
  exec "testament html"
  exec "open testresults.html"

task runExampleApp, "Run example_app":
  withDir "example_app":
    exec "nim c -r -o:bin/main src/main.nim"


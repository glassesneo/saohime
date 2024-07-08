# Package

version = "0.1.0"
author = "glassesneo"
description = "A nimble package for 2D game development"
license = "MIT"
srcDir = "src"
binDir = "bin"
installExt = @["nim"]
bin = @["saohime"]


# Dependencies

requires "nim >= 2.0.4"
requires "ecslib"
requires "sdl2"

task tests, "Run all tests":
  exec "testament p 'tests/**.nim'"

task show, "Show testresults":
  exec "testament html"
  exec "open testresults.html"

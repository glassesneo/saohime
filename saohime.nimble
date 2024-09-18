# Package

version = "0.1.0"
author = "glassesneo"
description = "An extensible 2D game engine for Nim"
license = "MIT"
srcDir = "src"
namedBin = {"saohime/cli/haru": "haru"}.toTable
binDir = "bin"
installExt = @["nim"]
bin = @["saohime"]
skipDirs = @["saohime/cli"]

# Dependencies

requires "nim >= 2.0.4"
requires "cligen"
requires "ecslib#head"
requires "sdl2#head"
requires "seiryu"
requires "slappy"
requires "results"



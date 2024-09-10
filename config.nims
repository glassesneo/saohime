task tests, "Run all tests":
  exec "testament p 'tests/**.nim'"

task runExampleApp, "Run example_app":
  withDir "example_app":
    exec "nim c -r -o:bin/main src/main.nim"


import
  pkg/[ecslib, slappy]

proc initAudio* {.system.} =
  slappyInit()


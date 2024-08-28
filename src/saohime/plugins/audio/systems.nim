import
  pkg/[ecslib, slappy]

proc initAudio* {.system.} =
  slappyInit()

proc quitAudio* {.system.} =
  slappyClose()


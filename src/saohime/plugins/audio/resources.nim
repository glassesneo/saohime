import
  pkg/[slappy]

type
  Audio* = ref object
    listener: Listener

proc new*(_: type Audio): Audio =
  return Audio(listener: slappy.listener)

proc gain*(audio: Audio): float =
  return audio.listener.gain

proc `gain=`*(audio: Audio, value: float) =
  audio.listener.gain = value


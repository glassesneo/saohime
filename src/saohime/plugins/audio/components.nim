import
  pkg/[seiryu],
  pkg/[slappy]

type
  SoundSpeaker* = ref object
    sound: Sound

proc new*(_: type SoundSpeaker, sound: Sound): SoundSpeaker {.construct.}

proc play*(speaker: SoundSpeaker) =
  discard speaker.sound.play()


import
  pkg/[slappy]

type
  SoundSpeaker* = ref object
    sound: Sound

proc new*(_: type SoundSpeaker, sound: Sound): SoundSpeaker =
  return SoundSpeaker(sound: sound)

proc play*(speaker: SoundSpeaker) =
  discard speaker.sound.play()


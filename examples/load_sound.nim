import
  std/[os],
  ../src/saohime,
  ../src/saohime/default_plugins

proc setup(audio: Resource[Audio]) {.system.} =
  audio.gain = 1
  let sound = newSound("./examples/assets/coin.wav")
  commands.create()
    .attach(SoundSpeaker.new(sound))

proc pollEvent(appEvent: Event[ApplicationEvent]) {.system.} =
  for e in appEvent:
    let app = commands.getResource(Application)
    app.terminate()

proc play(
    All: [SoundSpeaker],
    keyboardEvent: Event[KeyboardEvent],
) {.system.} =
  for e in keyboardEvent:
    if e.isPressed(K_Space):
      for speaker in each(entities, [SoundSpeaker]):
        speaker.play()

let app = Application.new()

app.loadPluginGroup(DefaultPlugins)


app.start:
  world.registerStartupSystems(setup)
  world.registerSystems(pollEvent, play)


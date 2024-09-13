import
  std/[os],
  ../src/saohime,
  ../src/saohime/default_plugins

proc setup(
    audio: Resource[Audio],
    manager: Resource[AssetManager]
) {.system.} =
  audio.gain = 1
  let sound = manager.loadSound("coin.wav")
  commands.create()
    .attach(SoundSpeaker.new(sound))

proc pollEvent(appEvent: Event[ApplicationEvent]) {.system.} =
  for e in appEvent:
    let app = commands.getResource(Application)
    app.terminate()

proc play(
    entities: [All[SoundSpeaker]],
    keyboardEvent: Event[KeyboardEvent],
) {.system.} =
  for e in keyboardEvent:
    if e.isPressed(K_Space):
      for _, speaker in entities[SoundSpeaker]:
        speaker.play()

let app = Application.new()

app.loadPluginGroup(DefaultPlugins)


app.start:
  world.registerStartupSystems(setup)
  world.registerSystems(pollEvent, play)


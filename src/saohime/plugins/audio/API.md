# AudioPlugin
This plugin implements a simple audio operations. Only `.wav` file is currently supported.

## Resources
```nim
type Audio* = ref object
```
A component to handle global audio settings.

### fields
```nim
proc gain*(audio: Audio): float
```
Returns global audio volume.<br><br>

```nim
proc `gain=`*(audio: Audio, value: float)
```
Sets global audio volume.

## Components
```nim
type SoundSpeaker* = ref object
```
A component which contains sound information.

### constructor
```nim
proc new*(_: type SoundSpeaker, sound: Sound): SoundSpeaker
```
`sound` is of type `slappy.Sound`.

### procedures
```nim
proc play*(speaker: SoundSpeaker)
```
Plays the sound.


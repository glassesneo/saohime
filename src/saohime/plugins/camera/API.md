# CameraPlugin
This plugin implements a camera operations integrated with SDL2 viewport.

## Components
```nim
type Camera* = ref object
  size*: Vector
  isActive*: bool
```
A 2D camera implementation. The default `size` is set to match the window size.

### constructor
```nim
proc new*(_: type Camera, size: Vector, isActive: bool): Camera
```

### procedures
```nim
proc centralSize*(camera: Camera): Vector
```

## Bundles
```nim
proc CameraBundle*(entity: Entity, x, y: float = 0, size: Vector, isActive = false): Entity {.discardable, raises: [KeyError].}
```
Attaches `Transform` and `Camera` to `entity` with the given arguments.


# TransformPlugin
This plugin defines the types for motion and scale of entities.

## Resources
```nim
type
  GlobalScale* = ref object
    scale*: Vector
```
`GlobalScale` represents the scale of all the textures. They all follow its changes when rendered. Default value is `Vector(1, 1)`.

## Components
```nim
type
  Transform* = ref object
    position*: Vector
    rotation*: float
    scale*: Vector
```
A component for managing `position`, `rotation` and `scale` of entities.

### constructors
```nim
proc new*(T: type Transform; position: Vector; rotation: float = 0f; scale = Vector.new(1, 1)): T
```

```nim
proc new*(T: type Transform; x: float = 0f; y: float = 0f; rotation: float = 0f; scale = Vector.new(1, 1)): T
```

### procedures
```nim
proc translate*(transform: Transform; x: float = 0f; y: float = 0f)
```
Adds `x` and `y` to `transform`.
Moves by `x` in the x-axis direction and by `y` in the y-axis direction.

```nim
proc rotate*(transform: Transform; radian: float)
```
Rotates by `radian`.

```nim
proc renderedPosition*(transform: Transform): Vector
```


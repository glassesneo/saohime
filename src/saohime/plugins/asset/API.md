# AssetPlugin
This plugin implements a simple asset management. Supported asset types are `Texture`, `Font`, and `Sound`.

```nim
proc load(assetManager: Resource[AssetManager]) {.system.} =
  let texture = assetManager.loadTexture("cat.jpg")

  let cat = commands.create()
    .ImageBundle(texture)
    .attach(Transform.new(
      x = 0, y = 0,
      scale = Vector.new(-0.2, -0.2),
      rotation = 0.5
    ))
```

## Resources
```nim
type AssetManager* = ref object
  assetPath*: string
```
An asset manager with cache. The default `assetPath` is `os.getAppDir()/"assets/"`.
Added to `World` by default.

### procedures
```nim
proc loadIcon*(manager: AssetManager; file: string)
```
Loads icon file `file` and set it as the application icon.<br><br>

```nim
proc loadTexture*(manager: AssetManager; file: string): Texture {.raises: [KeyError, SDL2TextureError].}
```
Loads image file `file`. Return type is `render.Texture`.<br><br>

```nim
proc loadFont*(manager: AssetManager; file: string; fontSize: int = 24): Font {.raises: [KeyError].}
```
Loads ttf file `file`. Return type is `render.Font`.<br><br>

```nim
proc loadSound*(manager: AssetManager; file: string): Sound {.raises: [KeyError, IOError, OSError, ValueError].}
```
Loads wav file `file`. Return type is `slappy.Sound`.<br><br>


# Application

## constructor
```nim
proc new*(_: type Application): Application {.raises: [OSError].}
```

## macros
```nim
macro loadPlugin*(app: Application, plugin: untyped): untyped
```
Loads `plugin`.<br><br>

```nim
macro loadPluginGroup*(app: Application, group: untyped): untyped
```
Loads `group`.<br><br>

## templates
```nim
template start*(app: Application, body: untyped): untyped
```
Starts the application. In `body` block, you can use a special variable `world` and run the process that you have to do before the application starts.

### example
```nim
app.start:
  world.registerStartupSystems(myStartupSystem)
  world.registerSystems(mySystem1, mySystem2)
  world.registerTerminateSystems(myTerminateSystem)

  echo "Start the app!"
```

## procedures
```nim
proc terminate*(app: Application)
```
Quits the application. Used in `System`.

# SaohimeColor

## constructors
```nim
proc new*(_: type SaohimeColor, r, g, b: range[0..255], a: range[0..255] = 255): SaohimeColor
```
<br>

```nim
proc new*(_: type SaohimeColor, color: Color = colWhite, a: range[0..255] = 255): SaohimeColor
```
Initializes `SaohimeColor` by specifying its `color`, where `color` is of type `colors.Color`.

## fields
```nim
proc r*(color: SaohimeColor): range[0..255]
```
Returns `r` value of RGBA.

```nim
proc `r=`*(color: SaohimeColor, value: int)
```
Assigns value to `color.r`. `r` is set to 0 or 255 when `value` is out of `0..255`.

```nim
proc g*(color: SaohimeColor): range[0..255]
```
Returns `g` value of RGBA.

```nim
proc `g=`*(color: SaohimeColor, value: int)
```
Assigns value to `color.g`. `g` is set to 0 or 255 when `value` is out of `0..255`.

```nim
proc b*(color: SaohimeColor): range[0..255]
```
Returns `b` value of RGBA.

```nim
proc `b=`*(color: SaohimeColor, value: int)
```
Assigns value to `color.b`. `b` is set to 0 or 255 when `value` is out of `0..255`.

```nim
proc a*(color: SaohimeColor): range[0..255]
```
Returns `a` value of RGBA.

```nim
proc `a=`*(color: SaohimeColor, value: int)
```
Assigns value to `color.a`. `a` is set to 0 or 255 when `value` is out of `0..255`.

## procedures
```nim
proc toSaohimeColor*(color: Color): SaohimeColor
```
Converts `colors.color` into `SaohimeColor`.

```nim
proc extractRGBA*(color: SaohimeColor): tuple[r, g, b, a: range[0..255]]
```

# Vector
## constructors
```nim
proc new*(_: type Vector; x: float = 0, y: float = 0): Vector
```
<br>

```nim
proc newWithPolarCoord*(_: type Vector; rad: float = 0f, len: float = 1f): Vector
```
Initializes `Vector` by specifying its `rad` and `len`.

## procedures
```nim
proc toVector*(vector: (int, int)): Vector
```
Converts `vector` into `Vector`.

```nim
proc toVector*(x, y: int): Vector
```
Converts `x`, `y` into `Vector`.


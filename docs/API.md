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


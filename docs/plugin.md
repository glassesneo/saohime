# The Plugin Architecture in Saohime
Every feature in Saohime is created as a plugin except for the core Entity Component System feature. This make Saohime flexible and extensible.<br>

## Default plugins
`src/saohime/default_plugins.nim` contains the plugins that Saohime need to create a game. Each plugin has its own API.md for documentation.

## How to create your own plugin
Let's create your first plugin, `HelloPlugin`.<br>
First we define the `Plugin Object` whose name starts with its plugin's name in the plugin's entry point.
```nim
type
  HelloPlugin* = object
```
There is no difference between `object` and `ref object` so please choose whichever you want.
<br>
Also, you need to create `build` procedure that takes `HelloPlugin` as the first argument and `World` as the second argument.
```nim
proc build*(plugin: HelloPlugin, world: World) =
  discard
```
Now you have created a minimal plugin for Saohime. However, there should be at least a feature or two in `HelloPlugin`. Let's make a `helloSystem` that prints `"Hello World"`.
```nim
proc helloSystem {.system.} =
  echo "Hello World"
```
Don't forget to register the systems you defined to the world in `build` procedure.
```diff
proc build*(plugin: HelloPlugin, world: World) =
- discard
+ world.registerStartupSystems(helloSystem)
```
Finally we can release the plugin and load it in your project. You can confirm that `"Hello World"` is printed when the app starts.
```nim
app.loadPlugin(HelloPlugin)
```


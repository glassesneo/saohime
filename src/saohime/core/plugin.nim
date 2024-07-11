{.push raises: [].}

import
  pkg/[ecslib]

type
  Plugin* = concept p
    p.build(World)

  PluginTuple* = tuple[build: proc(world: World)]

proc toTuple*(p: Plugin): PluginTuple =
  return (build: proc(world: World) = p.build(world))

proc loadPlugins*(world: World, plugins: varargs[PluginTuple, toTuple]) =
  for plugin in plugins:
    plugin.build(world)


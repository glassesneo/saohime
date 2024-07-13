{.push raises: [].}

import
  pkg/[ecslib]

type
  Plugin* = concept p
    p.name is string
    p.build(World)

  PluginTuple* = tuple[name: string, build: proc(world: World)]

  PluginGroup* = ref object
    group: seq[PluginTuple]

proc toTuple*(p: Plugin): PluginTuple =
  return (name: p.name, build: proc(world: World) = p.build(world))

proc new*(
    _: type PluginGroup,
    plugins: varargs[PluginTuple, toTuple]
): PluginGroup =
  result = PluginGroup()
  for plugin in plugins:
    result.group.add plugin

proc group*(pluginGroup: PluginGroup): seq[PluginTuple] =
  return pluginGroup.group

export new


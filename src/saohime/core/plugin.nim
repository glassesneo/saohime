import
  pkg/[ecslib]

type
  Plugin* = concept p
    p.name is string
    p.build(World)

  PluginTuple* = tuple[name: string, build: proc(world: World)]

  PluginGroup* = concept p
    p.plugins is seq[PluginTuple]
    p.build()

proc add*(group: PluginGroup, plugin: Plugin) =
  group.plugins.add plugin.toTuple()

proc toTuple*(p: Plugin): PluginTuple =
  return (name: p.name, build: proc(world: World) = p.build(world))


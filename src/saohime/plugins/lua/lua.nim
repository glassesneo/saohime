import
  std/os,
  pkg/ecslib,
  pkg/spellua

type
  LuaPlugin* = ref object

proc build*(plugin: LuaPlugin, world: World) =
  world.addResource(LuaDriver.new())

export
  spellua


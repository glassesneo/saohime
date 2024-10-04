import pkg/ecslib
import ./[resources, systems]

type AssetPlugin* = ref object

proc build*(plugin: AssetPlugin, world: World) =
  world.registerStartupSystems(initAssetManager)

export resources, systems

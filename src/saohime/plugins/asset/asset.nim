{.push raises: [].}

import
  pkg/[ecslib],
  ./resources,
  ./systems

type
  AssetPlugin* = ref object
    name*: string

proc new*(_: type AssetPlugin): AssetPlugin =
  return AssetPlugin(name: "AssetPlugin")

proc build*(plugin: AssetPlugin, world: World) =
  world.addResource(AssetManager.new())
  world.registerStartupSystems(initializeAssetManager)

export new
export
  resources,
  systems


import std/os
import pkg/ecslib
import ../../core/application
import ./resources

proc initAssetManager*(app: Resource[Application]) {.system.} =
  let assetManager = AssetManager.new(app.appPath / "assets")

  commands.addResource(assetManager)

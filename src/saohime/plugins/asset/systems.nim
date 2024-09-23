import
  std/os,
  pkg/ecslib,
  ../../core/application,
  ./resources

proc initAssetManager*(
    app: Resource[Application],
) {.system.} =
  let assetManager = AssetManager.new(
    app.appPath/"assets"
  )

  commands.addResource(assetManager)


import
  std/os,
  pkg/ecslib,
  ../../core/application,
  ../render/resources,
  ./resources

proc initAssetManager*(
    app: Resource[Application],
    renderer: Resource[Renderer]
) {.system.} =
  let assetManager = AssetManager.new(
    renderer, app.appPath/"assets"
  )

  commands.addResource(assetManager)


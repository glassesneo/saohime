import
  std/[os],
  pkg/[ecslib],
  ../../core/application,
  ../render/render,
  ./resources

proc initializeAssetManager*(
    app: Resource[Application];
    renderer: Resource[Renderer];
    assetManager: Resource[AssetManager]
) {.system.} =
  assetManager.initialize(renderer, app.appPath/"assets")


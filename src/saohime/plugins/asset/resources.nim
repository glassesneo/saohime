{.push raises: [].}

import
  std/[os, tables],
  pkg/[sdl2/ttf],
  ../../core/[contract, exceptions],
  ../render/render

type
  AssetType = enum
    Image
    SpriteTexture
    Font

  Asset = ref object
    case assetType: AssetType
    of Image: image: Texture
    of SpriteTexture: spriteSheet: SpriteSheet
    of Font: font: Font

  AssetManager* = ref object
    assetTable: Table[string, Asset]
    renderer: Renderer
    assetPath*: string

proc new*(
    _: type AssetManager;
    renderer: Renderer;
    assetPath: string
): AssetManager =
  return AssetManager(renderer: renderer, assetPath: assetPath)

proc initialize*(
    manager: AssetManager;
) =
  discard

proc loadImage*(
    manager: AssetManager;
    file: string
): Texture {.raises: [KeyError, SDL2TextureError].} =
  pre(manager.renderer != nil)
  pre(fileExists(manager.assetPath/file))

  if file in manager.assetTable:
    return manager.assetTable[file].image

  result = manager.renderer.loadTexture(manager.assetPath/file)
  manager.assetTable[file] = Asset(assetType: Image, image: result)

proc loadSpriteSheet*(
    manager: AssetManager;
    file: string;
    columnLen, rowLen: Natural
): SpriteSheet {.raises: [KeyError, SDL2TextureError].} =
  pre(manager.renderer != nil)
  pre(fileExists(manager.assetPath/file))

  let key = file & $columnLen & "x" & $rowLen

  if file in manager.assetTable:
    return manager.assetTable[key].spriteSheet

  result = manager.renderer.loadSpriteSheet(
    manager.assetPath/file,
    columnLen, rowLen
  )
  manager.assetTable[key] = Asset(
    assetType: SpriteTexture,
    spriteSheet: result
  )

proc loadFont*(
    manager: AssetManager;
    file: string;
    fontSize: int = 24
): Font {.raises: [KeyError].} =
  pre(fileExists(manager.assetPath/file))

  if file in manager.assetTable:
    return manager.assetTable[file].font

  result = render.Font.new(openFont(
    cstring manager.assetPath/file,
    fontSize.cint
  ))
  manager.assetTable[file] = Asset(assetType: Font, font: result)

export new


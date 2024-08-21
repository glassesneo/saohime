{.push raises: [].}

import
  std/[os, tables],
  pkg/[sdl2/image, sdl2/ttf, slappy],
  ../../core/[contract, exceptions],
  ../render/render,
  ../window/window
import sdl2 except Surface

type
  AssetType = enum
    TypeTexture
    TypeFont
    TypeSound

  Asset = ref object
    case assetType: AssetType
    of TypeTexture: texture: Texture
    of TypeFont: font: Font
    of TypeSound: sound: Sound

  AssetManager* = ref object
    assetTable: Table[string, Asset]
    window: Window
    renderer: Renderer
    assetPath*: string

proc new*(
    _: type AssetManager;
    window: Window;
    renderer: Renderer;
    assetPath: string
): AssetManager =
  return AssetManager(window: window, renderer: renderer, assetPath: assetPath)

proc loadIcon*(
    manager: AssetManager;
    file: string
) =
  pre(manager.window != nil)
  pre(fileExists(manager.assetPath/file))

  let surface = load(cstring manager.assetPath/file)
  manager.window.setIcon(surface)
  freeSurface(surface)

proc loadTexture*(
    manager: AssetManager;
    file: string
): Texture {.raises: [KeyError, SDL2TextureError].} =
  pre(manager.renderer != nil)
  pre(fileExists(manager.assetPath/file))

  if file in manager.assetTable:
    return manager.assetTable[file].texture

  result = manager.renderer.loadTexture(manager.assetPath/file)
  manager.assetTable[file] = Asset(assetType: TypeTexture, texture: result)

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
  manager.assetTable[file] = Asset(assetType: TypeFont, font: result)

proc loadSound*(
    manager: AssetManager;
    file: string
): Sound {.raises: [KeyError, IOError, OSError, ValueError].} =
  pre(fileExists(manager.assetPath/file))

  if file in manager.assetTable:
    return manager.assetTable[file].sound

  result = newSound(manager.assetPath/file)

  manager.assetTable[file] = Asset(assetType: TypeSound, sound: result)

export new


{.push raises: [].}
import
  std/os,
  std/tables,
  pkg/[sdl2/image, sdl2/ttf],
  pkg/[seiryu, seiryu/dbc],
  pkg/[slappy],
  ../../core/[exceptions],
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
    T: type AssetManager;
    window: Window;
    renderer: Renderer;
    assetPath: string
): T {.construct.}

proc loadIcon*(
    manager: AssetManager;
    file: string
) {.raises: [ValueError].} =
  precondition:
    manager.window != nil
    output manager.assetPath/file & " does not exist"
    fileExists(manager.assetPath/file)

  let surface = load(cstring manager.assetPath/file)
  manager.window.setIcon(surface)
  freeSurface(surface)

proc loadTexture*(
    manager: AssetManager;
    file: string
): Texture {.raises: [KeyError, ValueError, SDL2TextureError].} =
  precondition:
    manager.renderer != nil
    output manager.assetPath/file & " does not exist"
    fileExists(manager.assetPath/file)

  if file in manager.assetTable:
    return manager.assetTable[file].texture

  result = manager.renderer.loadTexture(manager.assetPath/file)
  manager.assetTable[file] = Asset(assetType: TypeTexture, texture: result)

proc loadFont*(
    manager: AssetManager;
    file: string;
    fontSize: int = 24
): Font {.raises: [KeyError, ValueError].} =
  precondition:
    output manager.assetPath/file & " does not exist"
    fileExists(manager.assetPath/file)

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
): Sound {.raises: [IOError, KeyError, OSError, ValueError].} =
  precondition:
    output manager.assetPath/file & " does not exist"
    fileExists(manager.assetPath/file)

  if file in manager.assetTable:
    return manager.assetTable[file].sound

  result = newSound(manager.assetPath/file)

  manager.assetTable[file] = Asset(assetType: TypeSound, sound: result)

export new


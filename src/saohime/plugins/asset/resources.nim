import
  std/tables,
  std/typetraits,
  pkg/seiryu

type
  AbstractAssetContainer* = ref object of RootObj
    assetManager: AssetManager

  AssetContainer*[T] = ref object of AbstractAssetContainer
    assetTable: Table[string, T]

  AssetManager* = ref object
    assetContainerTable: Table[string, AbstractAssetContainer]
    assetPath*: string

proc new*(T: type AssetManager; assetPath: string): T {.construct.}

proc has*(manager: AssetManager; T: typedesc): bool =
  return typetraits.name(T) in manager.assetContainerTable

proc containerOf*(manager: AssetManager; T: typedesc): AssetContainer[T] =
  return cast[AssetContainer[T]](manager.assetContainerTable[typetraits.name(T)])

proc `[]`*(manager: AssetManager; T: typedesc): AssetContainer[T] =
  if manager.has(T):
    return manager.containerOf(T)

  result = AssetContainer[T](assetManager: manager)
  manager.assetContainerTable[typetraits.name(T)] = result

proc contains*[T](container: AssetContainer[T]; fileName: string): bool =
  return fileName in container.assetTable

proc `[]`*[T](container: AssetContainer[T]; fileName: string): T =
  return container.assetTable[fileName]

proc `[]=`*[T](container: AssetContainer[T]; fileName: string; value: T) =
  container.assetTable[fileName] = value

proc assetPath*(container: AbstractAssetContainer): string =
  container.assetManager.assetPath

proc assetTable*[T](container: AssetContainer[T]): Table[string, T] =
  return container.assetTable

# proc loadFont*(
#     manager: AssetManager;
#     file: string;
#     fontSize: int = 24
# ): Font {.raises: [KeyError].} =
#   precondition:
#     output manager.assetPath/file & " does not exist"
#     fileExists(manager.assetPath/file)
#
#   if file in manager.assetTable:
#     return manager.assetTable[file].font
#
#   result = render.Font.new(openFont(
#     cstring manager.assetPath/file,
#     fontSize.cint
#   ))
#   manager.assetTable[file] = Asset(assetType: TypeFont, font: result)

export new


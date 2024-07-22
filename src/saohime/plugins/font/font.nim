{.push raises: [].}

import
  std/[tables],
  pkg/[ecslib],
  ../../core/[exceptions, sdl2_helpers],
  ./components

type
  FontManager* = ref object
    fontTable: Table[string, Font]
    defaultFontSize*: int

  FontPlugin* = ref object
    name*: string

proc new*(_: type FontManager): FontManager =
  return FontManager(
    defaultFontSize: 24
  )

proc registerFont*(
    manager: FontManager,
    name, path: string,
    fontSize = manager.defaultFontSize
) {.raises: [SDL2FontError].} =
  let font = Font.new(openFont(path, fontSize), fontSize)
  manager.fontTable[name] = font

proc loadFont*(
    manager: FontManager,
    name, path: string,
    fontSize = manager.defaultFontSize
): Font {.raises: [KeyError, SDL2FontError].} =
  manager.registerFont(name, path, fontSize)
  return manager.fontTable[name]

proc getFont*(manager: FontManager, name: string): Font {.raises: [KeyError].} =
  return manager.fontTable[name]

proc `[]`*(manager: FontManager, name: string): Font {.raises: [KeyError].} =
  return manager.getFont(name)

proc new*(_: type FontPlugin): FontPlugin =
  return FontPlugin(name: "FontPlugin")

proc build*(plugin: FontPlugin, world: World) =
  world.addResource(FontManager.new())

export new
export
  components


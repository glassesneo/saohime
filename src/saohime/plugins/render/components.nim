import
  pkg/[sdl2],
  ../../core/[saohime_types, sdl2_helpers]

type
  Texture* = ref object
    texture*: TexturePtr

proc new*(_: type Texture, texture: TexturePtr): Texture =
  return Texture(texture: texture)

proc getSize*(texture: Texture): Vector =
  return texture.texture.getSize()


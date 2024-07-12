import
  pkg/[sdl2]

type
  SaohimeError = object of CatchableError

  SDL2InitError* = object of SaohimeError

  SDL2WindowError* = object of SaohimeError

  SDL2RendererError* = object of SaohimeError

  SDL2TextureError* = object of SDL2RendererError


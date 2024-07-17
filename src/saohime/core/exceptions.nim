type
  SaohimeError = object of CatchableError

  SDL2InitError* = object of SaohimeError

  SDL2WindowError* = object of SaohimeError

  SDL2RendererError* = object of SaohimeError

  SDL2DrawError* = object of SDL2RendererError

  SDL2TextureError* = object of SDL2RendererError


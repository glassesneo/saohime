type
  SaohimeError = object of CatchableError

  SDL2InitError* = object of SaohimeError

  SDL2WindowError* = object of SaohimeError

  SDL2RendererError* = object of SaohimeError

  SDL2FontError* = object of SaohimeError

  SDL2SurfaceError* = object of SDL2RendererError

  SDL2DrawError* = object of SDL2RendererError

  SDL2TextureError* = object of SDL2RendererError

  PluginError* = object of SaohimeError


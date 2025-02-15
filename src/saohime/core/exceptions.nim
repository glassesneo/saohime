type
  SaohimeError = object of CatchableError

  SDL2InitError* = object of SaohimeError

  SDL2WindowError* = object of SaohimeError

  SDL2RendererError* = object of SaohimeError

  SDL2FontError* = object of SaohimeError

  SDL2SurfaceError* = object of SDL2RendererError

  SDL2DrawError* = object of SDL2RendererError

  SDL2TextureError* = object of SDL2RendererError

  SDL2InputError* = object of SaohimeError

  PluginError* = object of SaohimeError

template raiseError*(condition, body) =
  when not defined(emscripten):
    if condition:
      body

# RenderPlugin
This plugin implements a basic 2D rendering API. Either the resources or events is available for dealing with user input.

## Resources
```nim
type Renderer* = ref object
  index*: int
  flags*: cint
```
A renderer for SDL2. Every rendering operation is handled via this resource.


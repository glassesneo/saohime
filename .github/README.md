<div align='center'>

<img src='./assets/header.png' alt='header'>

</div>

<br />

<div align='center'>

Saohime Engine is a 2D game engine for Nim Programming Language.

</div>

> [!NOTE]
> Saohime Engine is currently work in progress and is **NOT** a practical project. Some features have not yet been implemented. See [Roadmap](#Features/Roadmap) for more details.

## Requirement
- SDL, SDL_image, SDL_ttf (2.x)
- OpenAL (2.x)

## Install
```sh
nimble install https://github.com/glassesneo/saohime
```

## Features/Roadmap
### Basic features
- [x] Entity Component System integration with [ecslib](https://github.com/glassesneo/ecslib)
- [x] GPU rendering with SDL2
- [x] Flexible API for image and sprite
- [x] 2D camera implementation
- [x] 3D Audio operations with OpenAL
- [x] Efficient asset management
- [x] Event queue implementation well-integrated with ECS
- [x] General input device support
- [x] Simple FPS management
- [ ] Hierarchical structure between entities
- [ ] Particle implementation
- [ ] Simple GUI built on ECS
- [ ] Timer implementation
- [ ] Command line tool
- [ ] Save/Load implementation

### Extra features
- [x] Extensible plugin architecture
- [ ] Resource embedding
- [ ] WebAssembly support
- [ ] Lua integration
- [ ] cairo integration
- [ ] Hot reload

## License
Saohime Engine is licensed under the MIT license. See COPYING for details.

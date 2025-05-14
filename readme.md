# Eclipse

An experimental game engine written in Nim. Not ready for official use.

I wrote this primarily because other game engines had too many problems ranging from:
- little to no documentation / outdated documentation _(or just generally useless documentation)_
- unneccesary complication in simple tasks _(it should not take 200+ lines for a simple window)_
- outdated _(well **SDL2** isn't THAT outdated..)_
- etc

It is essentially like an easier utility for SDL2 (in my opinion)

## Requirements

- Nim (ver 2.2.2+ recommended because thats what I use)
- Nim SDL2 library - `nimble install sdl2` (yes the one by [nim-lang/sdl2](https://github.com/nim-lang/sdl2) )
- SDL2 file(s) in your Path / local directory (currently just SDL2)
  - the **SDL_image** version is `2.0.1`
  - the **SDL_ttf** version is `2.0.14`
  - the **SDL2** version is `2.0.5.0`

#### extra SDL dependencies:
  - `lib-freetype 6` _(bundled with SDL_ttf)_
  - `libjpeg-9`; `libpng-16-16`; `libtiff-5`; `libwebp-4` _(bundled with SDL_image)_
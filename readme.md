# Eclipse

An experimental game engine written in Nim. Not ready for official use.

I wrote this primarily because other game engines had too many problems ranging from:
- little to no documentation / outdated documentation (or just generally useless documentation)
- unneccesary complication in simple tasks (it should not take 200+ lines for a simple window)
- outdated
- etc

It is essentially like an easier frontend for SDL2, with hopefully better object management, utilities and other features compared to just using SDL2 on its own.

## Requirements

- Nim programming language (ver 2.2.2+ recommended because thats what I use)
- Nim sdl2 library - `nimble install sdl2` (yes the one by [nim-lang/sdl2](https://github.com/nim-lang/sdl2) )
- SDL2 file(s) in your Path / local directory (currently just SDL2)
  - in addition, `lib-freetype-6` should also be available (for SDL2_ttf)
  - the SDL2_ttf version is 2.0.14
  - the SDL2 version is 2.0.5.0
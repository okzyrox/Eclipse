# Eclipse

An experimental primarily 2D game engine written in Nim. Not ready for official use.

I wrote this primarily because other game engines had too many problems ranging from:
- little to no documentation / outdated documentation
- unneccesary complication in simple tasks
- outdated
- etc

## Requirements

- Nim programming language (ver 2.0.0 recommended because thats what I use)
- Nim sdl2 library (`nimble install sdl2`)
- SDL2 lib files in your Path (or local directory) (SDL2, SDL2-TTF, SDL2-MIXER, SDL2-IMAGE)

## The design

Eclipse uses the following Architecture for games:

### Game

Every Game has a `Game` object. This object houses the basics:

- Whether the game should be running (`running`)
- A list of `Scenes`
- The current `Scene`

And also the SDL2 `Window` and `Renderer`

### Scenes

Every `Game` needs a `Scene`, or a list of `Scenes`, which are used to know what should be updated, rendered, drawn, etc.

A `Scene` has the following properties:
- `id`: The scene is referred to by this ID for simplicitys sake (i.e. "main_scene", "tutorial_scene", etc)

### Entities

`Entities` are members of a `Scene`, which (usually) are drawn in accordance to their position, scale, sprite, etc.

A `Entity` has the following properties:
- `id`: Similar to before with Scene, used to easily refer to an entity. 
- `position`: A `Vec2` for its X and Y coordinate positions
- `scale`: A `Vec2` for a Width and Height scaling of its `Rect`.
- `rotation`: A `float` for deciding the rotation of an entity in a scene.




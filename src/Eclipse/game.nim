#-- Eclipse Engine -- 
# Author: ZyroX

## Game
## 
## Game houses all the scenes, and handles the game loop

import sdl2
import sdl2/ttf

import common, window, scene, entity, inputs, ui, events

type GameData* = object
    id: string
    value: (int, float, string) 

type EclipseGame = object
    running*: bool #

    scenes: seq[Scene]
    currentScene*: Scene
    inputManager*: InputManager
    fontManager*: FontManager

    delta_time_count: uint64
    delta_time_count_prev: uint64
    delta_time*: float32
    #data: seq[GameData]
    evt: Event

type Game* = ref EclipseGame

proc newGame*(): Game = 
    discard sdl2.init(INIT_EVERYTHING) # Init everything doesnt actually include external modules
    # like ttf
    if not ttfInit():
        echo "Failed to initialize SDL2-TTF"
    result = Game(
        running: true,

        delta_time_count: getPerformanceCounter()
    )

proc is_running*(game: Game): bool = game.running

proc get_dt*(game: Game): float32 = game.delta_time

proc add*(game: var Game, scene: Scene) = 
    game.scenes.add(scene)
    #if game.currentScene == nil:
    game.currentScene = scene

# shorthand for adding an tntity to the current scene
# kinda weird but who cares
proc add*(game: var Game, entity: Entity) =
    game.currentScene.add(entity)

proc remove*(game: var Game, entity: Entity) =
    game.currentScene.remove(entity)

proc switch_scene*(game: var Game, scene: Scene) =
    if game.currentScene == scene:
        echo "Already on that scene"
        return
    elif game.currentScene notin game.scenes:
        echo "Scene not found"
        return
    else:
        game.currentScene = scene

proc switch_scene*(game: var Game, id: string) =
    for scene in game.scenes:
        if scene.id == id:
            game.switch_scene(scene)
        

proc update*(game: var Game) = 
    var previousCounter = game.delta_time_count
    game.delta_time_count = getPerformanceCounter()

    game.delta_time = (game.delta_time_count - previousCounter).float / getPerformanceFrequency().float
    #game.currentScene.update()

proc draw*(renderer: WindowRenderer, entity: Entity) =
    #echo "Drawing entity: ", entity.id
    renderer.get_sdl2_renderer().setDrawColor(entity.color.r, entity.color.g, entity.color.b, entity.color.a)
    var r = rect(
        cint(entity.position.x), cint(entity.position.y),
        cint(2 * entity.scale.x), cint(2 * entity.scale.y)
    )
    renderer.get_sdl2_renderer().fillRect(r)

proc draw*(renderer: WindowRenderer, scene: var Scene) =
    echo "Drawing scene"
    for entity in scene.entities:
        draw(renderer, entity)

proc draw*(renderer: WindowRenderer, game: var Game) =
    draw(renderer, game.currentScene)


## UI

proc draw*(renderer: WindowRenderer, ui_element: TextUIElement) =
    var 
        text_color = ui_element.fore_color
        back_color = ui_element.back_color
    let 
        text_col = color(text_color.r, text_color.g, text_color.b, text_color.a)
        back_col = color(back_color.r, back_color.g, back_color.b, back_color.a)
        surface = ttf.renderTextSolid(ui_element.font, cstring ui_element.text, text_col)
        texture = renderer.get_sdl2_renderer().createTextureFromSurface(surface)

    surface.freeSurface()
    defer: texture.destroy
    var r = rect(
        ui_element.position.x.cint,
        ui_element.position.y.cint,
        ui_element.scale.x.cint,
        ui_element.scale.y.cint
    )
    renderer.get_sdl2_renderer().copy(texture, nil, addr r)
    renderer.get_sdl2_renderer().fillRect(r)      
  
    
proc draw_ui*(game: var Game, renderer: WindowRenderer, scene: var Scene) =
    for element in scene.ui.elements:
        if element of TextUIElement:
            echo "Drawing text element"
            # in hindsight this code looks awful
            var text_element = cast[TextUIElement](element)
            text_element.font = game.fontManager.getFont(text_element.font_id)
            draw(renderer, text_element)
        else:
            echo "unfinished ui type"

## Fonts


proc addFont*(game: var Game, id: string, path: string): bool =
    return game.fontManager.addFont(id, path)
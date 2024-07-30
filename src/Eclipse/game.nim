#-- Eclipse Engine -- 
# Author: ZyroX

## Game
## 
## Game houses all the scenes, and handles the game loop

import std/[logging]

import sdl2
import sdl2/ttf

import common, window, scene, entity, inputs, ui, events

var EngineReadyEvent* = newEvent()

type GameData* = object
    id: string
    value: (int, float, string) 

type EclipseGame = object
    running*: bool #

    scenes: seq[Scene]
    currentScene*: Scene
    inputManager*: InputManager
    fontManager*: FontManager

    deltaTimeCount: uint64
    deltaTimeCountPrev: uint64
    deltaTime*: float32
    #data: seq[GameData]
    evt: Event

type Game* = ref EclipseGame

proc `$`*(game: Game): string = 
    "<Game: " & "running: " & $game.running & ">"

proc newGame*(): Game = 
    discard sdl2.init(INIT_EVERYTHING) # Init everything doesnt actually include external modules
    # like ttf
    if not ttfInit():
        echo "Failed to initialize SDL2-TTF"
    
    EngineReadyEvent.FireAll()
    result = Game(
        running: true,
        deltaTimeCount: getPerformanceCounter()
    )

proc is_running*(game: Game): bool = game.running

proc get_dt*(game: Game): float32 = game.deltaTime

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
    var previousCounter = game.deltaTimeCount
    game.deltaTimeCount = getPerformanceCounter()

    game.deltaTime = (game.deltaTimeCount - previousCounter).float / getPerformanceFrequency().float
    game.currentScene.update()

proc draw*(renderer: WindowRenderer, entity: Entity) =
    renderer.get_sdl2_renderer().setDrawColor(entity.color.r, entity.color.g, entity.color.b, entity.color.a)
    var r = rect(
        cint(entity.position.x), cint(entity.position.y),
        cint(2 * entity.scale.x), cint(2 * entity.scale.y)
    )
    renderer.get_sdl2_renderer().fillRect(r)

proc draw*(renderer: WindowRenderer, scene: var Scene) =
    #echo "Drawing scene"
    for entity in scene.entities:
        draw(renderer, entity)

proc draw*(renderer: WindowRenderer, game: var Game) =
   # draw(renderer, game.currentScene)
    draw(renderer.get_sdl2_renderer(), game.currentScene)


## UI

proc draw*(renderer: WindowRenderer, ui_element: UIElement) =
    case ui_element.ui_type:
    of UIType.uitText:
        assert ui_element.t_font != nil, "No font set for text element"
        echo "Drawing text: ", ui_element.t_text
        var 
            text_color = ui_element.fore_color
            back_color = ui_element.back_color
        let 
            text_col = color(text_color.r, text_color.g, text_color.b, text_color.a)
            back_col = color(back_color.r, back_color.g, back_color.b, back_color.a)
            surface = ttf.renderTextSolid(ui_element.t_font, cstring ui_element.t_text, text_col)
            texture = renderer.get_sdl2_renderer().createTextureFromSurface(surface)

        surface.freeSurface()
        defer: texture.destroy
        var r = rect(
            ui_element.position.x.cint,
            ui_element.position.y.cint,
            ui_element.scale.x.cint,
            ui_element.scale.y.cint
        )
        if EclipseDebugging:
            echo "surface: ", surface.isNil
            echo "texture: ", texture.isNil
            echo "rect: ", r
        renderer.get_sdl2_renderer().copy(texture, nil, addr r)
        renderer.get_sdl2_renderer().fillRect(r)    
    of UIType.uitButton:
        discard

proc draw_ui*(renderer: WindowRenderer, scene: var Scene) =
    for element in scene.ui.elements:
        draw(renderer, element)

proc draw_ui*(renderer: WindowRenderer, game: var Game) =
    draw_ui(renderer, game.currentScene)

## Fonts


proc addFont*(game: var Game, id: string, path: string): bool =
    return game.fontManager.addFont(id, path)

proc getFont*(game: var Game, id: string): FontPtr =
    return game.fontManager.getFont(id)


## Input


proc updateInputs*(game: var Game, inputManager: var InputManager) =
    inputManager.keys_pressed = {}
    inputManager.keys_held = {}
    inputManager.keys_just_released = {}
    inputManager.mouse_pos = Vec2(x: 0, y: 0)
    inputManager.mouse_pressed = {}
    inputManager.mouse_held = {}
    inputManager.mouse_just_released = {}

    var evt = sdl2.defaultEvent
    while pollEvent(evt):
        case evt.kind
        of QuitEvent:
            game.running = false
            break
        of KeyDown:
            if EclipseDebugging:
                log(lvlDebug, "Key pressed: ", evt.key.keysym.scancode.toKey())
            inputManager.keys_pressed.incl(evt.key.keysym.scancode.toKey())
            inputManager.keys_held.incl(evt.key.keysym.scancode.toKey())
            break
        of KeyUp:
            inputManager.keys_just_released.incl(evt.key.keysym.scancode.toKey())
            inputManager.keys_held.excl(evt.key.keysym.scancode.toKey())
            break
        else:
            #echo "Unimplemented input event"
            discard
        #[
        of MouseButtonDown:
            inputManager.mouse_pressed.incl(evt.button.button.toInputMouseKey())
            inputManager.mouse_held.incl(evt.button.button.toInputMouseKey())
        of MouseButtonUp:
            inputManager.mouse_just_released.incl(evt.button.button.toInputMouseKey())
            inputManager.mouse_held.excl(evt.button.button.toInputMouseKey())
        ]#

proc updateInputs*(game: var Game) =
    updateInputs(game, game.input_manager)

proc keyIsDown*(game: var Game, key: InputKey): bool =
    return key in game.input_manager.keys_pressed

proc keyIsHeld*(game: var Game, key: InputKey): bool =
    return key in game.input_manager.keys_held

proc keyIsReleased*(game: var Game, key: InputKey): bool =
    return key in game.input_manager.keys_just_released
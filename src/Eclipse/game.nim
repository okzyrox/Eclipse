#-- Eclipse Engine -- 
# Author: ZyroX

## Game
## 
## Game houses all the scenes, and handles the game loop

import sdl2

import window, scene

type GameData* = object
    id: string
    value: (int, float, string) 

type EclipseGame = object
    running*: bool #

    scenes: seq[Scene]
    currentScene: Scene

    delta_time_count: uint64
    delta_time_count_prev: uint64
    delta_time*: float32
    #data: seq[GameData]
    evt: Event

type Game* = ref EclipseGame

proc newGame*(): Game = 
    discard sdl2.init(INIT_EVERYTHING)
    result = Game(
        running: true,
        delta_time_count: getPerformanceCounter()
    )

proc is_running*(game: Game): bool = game.running

proc get_dt*(game: Game): float32 = game.delta_time

proc get_current_scene*(game: Game): Scene = game.currentScene

proc add*(game: var Game, scene: Scene) = 
    game.scenes.add(scene)
    #if game.currentScene == nil:
    game.currentScene = scene

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


proc draw*(renderer: RendererPtr, game: var Game) = 
    renderer.setDrawColor(0, 0, 0, 255)
    renderer.clear()
    renderer.present()
    #game.window.present()

    draw(renderer, game.currentScene)
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

    window: EclipseWindow
    scenes: seq[Scene]
    currentScene: Scene

    delta_time_count: uint64
    delta_time_count_prev: uint64
    delta_time*: float32
    currentEvent: Event
    #data: seq[GameData]

type Game* = ref EclipseGame

proc newGame*(): Game = 
    discard sdl2.init(INIT_EVERYTHING)
    result = Game(
        running: true,
        window: newWindow(800, 800, "Eclipse Engine"),
        delta_time_count: getPerformanceCounter(),
        currentEvent: defaultEvent
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

    while pollEvent(game.currentEvent):
        if game.currentEvent.kind == QuitEvent:
            game.running = false
            break
    #game.currentScene.update()

proc draw*(game: var Game) = 
    #var renderer = game.window.get_renderer()
    game.window.present()

    #draw(renderer, game.currentScene)

#-- Eclipse Engine -- 
# Author: ZyroX

## Game
## 
## Game houses all the scenes, and handles the game loop

import sdl2

import common, window, scene, entity, inputs

type GameData* = object
    id: string
    value: (int, float, string) 

type EclipseGame = object
    running*: bool #

    scenes: seq[Scene]
    currentScene*: Scene
    inputManager*: InputManager

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

proc add*(game: var Game, scene: Scene) = 
    game.scenes.add(scene)
    #if game.currentScene == nil:
    game.currentScene = scene

# shorthand for adding an tntity to the current scene
# kinda weird but who cares
proc add*(game: var Game, entity: Entity) =
    game.currentScene.add(entity)

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
    #echo "Drawing scene"
    for entity in scene.entities:
        draw(renderer, entity)

proc draw*(renderer: WindowRenderer, game: var Game) =
    #echo "Drawing game"
    renderer.clear()
    draw(renderer, game.currentScene)
    renderer.present()
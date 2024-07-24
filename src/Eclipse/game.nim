#-- Eclipse Engine -- 
# Author: ZyroX

## Game
## 
## Game houses all the scenes, and handles the game loop

import window, scene

type GameData* = object
    id: string
    value: (int, float, string) 

type EclipseGame = object
    running*: bool #

    window: EclipseWindow
    scenes: seq[Scene]
    currentScene: Scene

    data: seq[GameData]

type Game* = ref EclipseGame

proc newGame*(): Game = 
    Game(
        running: true,
        window: newWindow(800, 600, "Eclipse Engine"),
    )

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
    game.currentScene.update()

proc draw*(game: var Game) = 
    game.window.clear()

    var renderer = game.window.get_renderer()

    draw(renderer, game.currentScene)

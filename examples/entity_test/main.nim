# Entity test

import ../../src/Eclipse

# Init window and renderer
var (ew, window) = newEclipseWindow("Entity Test", 800, 600, false, @[])
var renderer = createWindowRenderer(window)

# Start game

var mainGame = newGame()
mainGame.add(newScene("main")) # Currently the newest scene added is the currentscene, need to change

var player = newEntity("player")
player.position = Vec2(x: 100, y: 100)
player.scale = Vec2(x: 50, y: 50)
mainGame.add(player)

var evt = sdl2.defaultEvent
    
while mainGame.running:
    renderer.draw(mainGame)
    mainGame.update()

    while pollEvent(evt):
        if evt.kind == QuitEvent:
            mainGame.running = false
            break
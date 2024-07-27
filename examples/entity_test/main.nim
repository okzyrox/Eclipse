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

# Now multiple entities with different colors

var enemy = newEntity("enemy")
enemy.color = DrawColor(r: 255, g: 0, b: 0, a: 255)
enemy.position = Vec2(x: 250, y: 100)
enemy.scale = Vec2(x: 50, y: 50)
mainGame.add(enemy)

var enemy2 = newEntity("enemy2")
enemy2.color = DrawColor(r: 0, g: 255, b: 0, a: 255)
enemy2.position = Vec2(x: 400, y: 100)
enemy2.scale = Vec2(x: 50, y: 50)
mainGame.add(enemy2)

var evt = sdl2.defaultEvent
    
while mainGame.running:
    renderer.clear()
    renderer.draw(mainGame)
    renderer.present()
    mainGame.update()

    while pollEvent(evt):
        if evt.kind == QuitEvent:
            mainGame.running = false
            break
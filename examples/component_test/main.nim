# Entity test

import ../../src/Eclipse

import random

# Init window and renderer
var (ew, window) = newEclipseWindow("Entity Test", 800, 600, false, @[])
var renderer = createWindowRenderer(window)

# Start game

var mainGame = newGame()
mainGame.add(newScene("main")) # Currently the newest scene added is the currentscene, need to change

var player = newEntity("player")
player.position = Vec2(x: 100, y: 100)
player.scale = Vec2(x: 50, y: 50)
player.color = DrawColor(r: 255, g: 0, b: 0, a: 255)

player.add(
    newScriptComponent(
        "rainbow", 
        proc(component: Component) = 
            randomize()
            player.color = DrawColor(r: rand(0..255).uint8, g: rand(0..255).uint8, b: rand(0..255).uint8, a: 255)
            
    )
)

var evt = sdl2.defaultEvent
    
while mainGame.running:
    player.update()
    renderer.clear() 
    renderer.draw(player)
    renderer.present()
    
    while pollEvent(evt):
        if evt.kind == QuitEvent:
            mainGame.running = false
            break
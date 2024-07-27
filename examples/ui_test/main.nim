# Entity test

import ../../src/Eclipse

import sdl2/ttf

# Init window and renderer
var (ew, window) = newEclipseWindow("UI Test", 800, 600, false, @[])
var renderer = createWindowRenderer(window)

# Start game

var mainGame = newGame()
mainGame.add(newScene("main")) # Currently the newest scene added is the currentscene, need to change

if not mainGame.addFont("test_font", "sans.ttf"):
    mainGame.running = false
    quit(1)

var text = newTextUIElement("hello_text", Vec2(x: 150, y: 150), Vec2(x: 128, y: 64), DrawColor(r: 255, g: 255, b: 255, a: 255), DrawColor(r: 0, g: 0, b: 0, a: 255), "test_font", "Hello World")

mainGame.currentScene.add(text)

var evt = sdl2.defaultEvent
    
while mainGame.running:
    ## draw everything before present is called, and within clear
    renderer.clear()

    renderer.draw(mainGame)
    mainGame.draw_ui(renderer, mainGame.currentScene)

    renderer.present()
    mainGame.update()

    while pollEvent(evt):
        if evt.kind == QuitEvent:
            mainGame.running = false
            break

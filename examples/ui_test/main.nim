# Entity test

import ../../src/Eclipse

import sdl2/ttf

# Init window and renderer
var (ew, window) = newEclipseWindow("UI Test", 800, 600, false, @[])
var renderer = createWindowRenderer(window)

# Start game

var mainGame = newGame()
WindowCloseEvent.Connect("window_close", (proc(ge: GameEvent) = mainGame.running = false))
#mainGame.add() # Currently the newest scene added is the currentscene, need to change
var mainScene = newScene("main")

if not mainGame.addFont("test_font", "sans.ttf"):
    mainGame.running = false
    quit(1)

var font = mainGame.getFont("test_font")

var text = newTextElement("hello_text", "Hello World", Vec2(x: 150, y: 150), Vec2(x: 128, y: 64), DrawColor(r: 255, g: 255, b: 255, a: 255), DrawColor(r: 0, g: 0, b: 0, a: 255))
text.setFont(font)

mainScene.add(text)

var evt = sdl2.defaultEvent
    
while mainGame.running:
    ## draw everything before present is called, and within clear
    renderer.clear()

    #renderer.draw(mainGame)
    renderer.draw_ui(mainScene)

    renderer.present()
    mainGame.update()

    updateInputs(mainGame)

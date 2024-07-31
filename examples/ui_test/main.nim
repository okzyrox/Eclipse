# Entity test

import ../../src/Eclipse

import sdl2/ttf

# Init window and renderer
var (ew, window) = newEclipseWindow("UI Test", 800, 600, false, @[])
var renderer = createWindowRenderer(window)
renderer.base_draw_color = DrawColor(r: 255, g: 255, b: 255, a: 255)

# Start game

var mainGame = newGame()
WindowCloseEvent.Connect("window_close", (proc(ge: GameEvent) = mainGame.running = false))
#mainGame.add() # Currently the newest scene added is the currentscene, need to change
var mainScene = newScene("main")

#[
if not mainGame.addFont("test_font", "sans.ttf"):
    mainGame.running = false
    quit(1)

var font = mainGame.getFont("test_font")
]#
var font = openFont("sans.ttf", 32)
var text = newTextElement(
    "hello_text", 
    "Hello World", 
    Vec2(x: 150, y: 150), 
    Vec2(x: 128, y: 64), 
    DrawColor(r: 0, g: 0, b: 0, a: 255),
    DrawColor(r: 0, g: 122, b: 122, a: 255),
    1
)
text.setFont(font)


var evt = sdl2.defaultEvent
    
while mainGame.running:
    ## draw everything before present is called, and within clear
    mainGame.update()
    renderer.clear()

    #renderer.draw(mainGame)
    #renderer.draw_ui(mainScene)
    renderer.draw(text)

    renderer.present()
    

    updateInputs(mainGame)

    if mainGame.keyIsDown(Key_B):
        renderer.base_draw_color = DrawColor(r: 0, g: 0, b: 0, a: 255)
    
    if mainGame.keyIsDown(Key_W):
        renderer.base_draw_color = DrawColor(r: 255, g: 255, b: 255, a: 255)

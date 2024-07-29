# Entity test

import ../../src/Eclipse

# Init window and renderer
var (ew, window) = newEclipseWindow("Input tests", 800, 600, false, @[])
var renderer = createWindowRenderer(window)

# Start game

var mainGame = newGame()
mainGame.add(newScene("main"))

var evt = sdl2.defaultEvent


while mainGame.running:
    renderer.clear()
    renderer.draw(mainGame)
    renderer.present()
    mainGame.update()

    updateInputs(mainGame)

    if mainGame.keyIsDown(Key_W):
        echo "W is pressed"
    if mainGame.keyIsDown(Key_S):
        echo "S is pressed"
    if mainGame.keyIsDown(Key_A):
        echo "A is pressed"
    if mainGame.keyIsDown(Key_D):
        echo "D is pressed"
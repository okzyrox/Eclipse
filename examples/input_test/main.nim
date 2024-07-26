# Entity test

import ../../src/Eclipse

# Init window and renderer
var (ew, window) = newEclipseWindow("Input tests", 800, 600, false, @[])
var renderer = createWindowRenderer(window)

# Start game

var mainGame = newGame()
mainGame.add(newScene("main"))

var evt = sdl2.defaultEvent

proc print_keys(game: var Game) =
    if game.input_manager.is_key_pressed(Key_W):
        echo "W is pressed"
    if game.input_manager.is_key_pressed(Key_S):
        echo "S is pressed"
    if game.input_manager.is_key_pressed(Key_A):
        echo "A is pressed"
    if game.input_manager.is_key_pressed(Key_D):
        echo "D is pressed"

while mainGame.running:
    renderer.draw(mainGame)
    mainGame.update()
    mainGame.print_keys()

    while pollEvent(evt):
        if evt.kind == QuitEvent:
            mainGame.running = false
            break
        if evt.kind == KeyDown:
            var key = evt.key.keysym.scancode.toKey()
            mainGame.input_manager.set_key_pressed(key, true)
            break
        if evt.kind == KeyUp:
            var key = evt.key.keysym.scancode.toKey()
            mainGame.inputManager.set_key_pressed(key, false)
            break
# Entity test

import ../../src/Eclipse
import ../../src/Eclipse/events

# Init window and renderer
var (ew, window) = newEclipseWindow("Input tests", 800, 600, false, @[])
var renderer = createWindowRenderer(window)

# Start game

var mainGame = newGame()
mainGame.add(newScene("main"))

var evt = sdl2.defaultEvent

var gameStartedEvent = newEvent()
var event_debounce = false

gameStartedEvent.addOnceListener((proc(ge: GameEvent) = echo "game started"))

while mainGame.running:
    gameStartedEvent.fireEvent()
    renderer.clear()
    renderer.draw(mainGame)
    renderer.present()
    mainGame.update()

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
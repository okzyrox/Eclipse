# Entity test

import ../../src/Eclipse
import ../../src/Eclipse/events

# Init window and renderer
var (ew, window) = newEclipseWindow("Input tests", 800, 600, false, @[])
var renderer = createWindowRenderer(window)

# Start game

var ePressedEvent = newEvent()
var fPressedEvent = newEvent()

var ep_debounce = false
var fp_debounce = false

# "Connect" events can be fired as many times as possible
# "Once" events only fire once, then they are disabled

# They have to be destroyed manually
fPressedEvent.Connect("f_pressed", (proc(ge: GameEvent) = echo "Pressed F")) # example use, dont do this for inputs tho!!!
ePressedEvent.Once("game_started", (proc(ge: GameEvent) = echo "Pressed E")) 

var mainGame = newGame()
mainGame.add(newScene("main"))

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
        if evt.kind == KeyDown:
            var key = evt.key.keysym.scancode.toKey()

            if key == Key_E and not ep_debounce:
                echo "Attempting to fire: e_pressed"
                ep_debounce = true
                ePressedEvent.FireAll() # Fires all the connections for an event
                # you can also use `gameStartedEvent.Fire("game_started")`, to fire the specific one

            if key == Key_F and not fp_debounce:
                echo "Attempting to fire: f_pressed"
                fp_debounce = true
                fPressedEvent.FireAll()
            break
        if evt.kind == KeyUp:
            var key = evt.key.keysym.scancode.toKey()

            if key == Key_E:
                ep_debounce = false

            if key == Key_F:
                fp_debounce = false
            break
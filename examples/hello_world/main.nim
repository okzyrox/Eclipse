# Hello world test
# just tests if windows work

import std/logging

import ../../src/Eclipse

var mainGame = newGame()

var (ew, window) = newEclipseWindow("Test Window", 800, 600, false, @[])

var renderer = createWindowRenderer(window)
var window_renderer = renderer.get_renderer()



var fl = newFileLogger("log.txt")
var cl = newConsoleLogger()

addHandler(fl)
addHandler(cl)

var running = true
var evt = sdl2.defaultEvent
while running:
    window_renderer.draw(mainGame)
    mainGame.update()
    while pollEvent(evt):
        if evt.kind == QuitEvent:
            running = false
            break
    

log(lvlDebug, "Done")
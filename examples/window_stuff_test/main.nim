# Entity test

import ../../src/Eclipse

import std/tables

# Init window and renderer
var (ew, window) = newEclipseWindow("Window Control test", 800, 600, false, @[])
var renderer = createWindowRenderer(window)

# Start game

var mainGame = newGame()
mainGame.add(newScene("main"))

var evt = sdl2.defaultEvent

WindowCloseEvent.Connect("before_close", (proc(ge: GameEvent) = echo "Window about to close"))
WindowCloseEvent.Connect("window_close", (proc(ge: GameEvent) = mainGame.running = false))

var fullscreen = false

while mainGame.running:
    renderer.clear()
    renderer.draw(mainGame)
    renderer.present()
    mainGame.update()

    updateInputs(mainGame)

    var window_size = window.getSize()
    var window_x, window_y: cint
    window.getPosition(window_x, window_y)

    if mainGame.keyIsDown(Key_W):
        window.setPosition(window_x, window_y - 10)
    if mainGame.keyIsDown(Key_S):
        window.setPosition(window_x, window_y + 10)
    if mainGame.keyIsDown(Key_A):
        window.setPosition(window_x - 10, window_y)
    if mainGame.keyIsDown(Key_D):
        window.setPosition(window_x + 10, window_y)
    
    if mainGame.keyIsDown(Key_F):
        # Note: Window should be resized to max resolution before fullscreen
        # to reduce issues of weird sizing in fullscreen and borders
        if not fullscreen: # TODO: add way to tell if window is fullscreen instead of developer manualy making a bool for this
            discard window.setFullscreen(1)
            fullscreen = true
        else:
            discard window.setFullscreen(0)
            fullscreen = false
    
    if mainGame.keyIsDown(Key_B):
        renderer.base_draw_color = DrawColor(r: 0, g: 0, b: 255, a: 255)
    
    if mainGame.keyIsDown(Key_G):
        renderer.base_draw_color = DrawColor(r: 0, g: 255, b: 0, a: 255)
    
    if mainGame.keyIsDown(Key_R):
        renderer.base_draw_color = DrawColor(r: 255, g: 0, b: 0, a: 255)
    
    if mainGame.keyIsDown(Key_Q):
        renderer.base_draw_color = DrawColor(r: 255, g: 255, b: 255, a: 255)
    
    if mainGame.keyIsDown(Key_E):
        renderer.base_draw_color = DrawColor(r: 0, g: 0, b: 0, a: 255)
    
    if mainGame.keyIsDown(Key_Up):
        window.setSize(window_size.x, window_size.y - 10)
    
    if mainGame.keyIsDown(Key_Down):
        window.setSize(window_size.x, window_size.y + 10)

    if mainGame.keyIsDown(Key_Left):
        window.setSize(window_size.x - 10, window_size.y)

    if mainGame.keyIsDown(Key_Right):
        window.setSize(window_size.x + 10, window_size.y)
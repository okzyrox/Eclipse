# Hello world test
# just tests if windows work

import std/logging

import ../../src/Eclipse

var mainGame = newGame()
mainGame.add(newScene("main"))

var mainScene = mainGame.get_current_scene()

var player = newEntity("player")
player.position = Vec2(x: 100, y: 100)
mainScene.add(player)

var fl = newFileLogger("log.txt")
var cl = newConsoleLogger()

addHandler(fl)
addHandler(cl)

#mainGame.switch_scene("main")
log(lvlDebug, "Running")
while mainGame.is_running():
    #mainGame.draw()
    mainGame.update()
    

log(lvlDebug, "Done")
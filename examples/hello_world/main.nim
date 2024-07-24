# Hello world test
# just tests if windows work

import ../../src/Eclipse

var mainGame = newGame()

mainGame.add(newScene("main"))

#mainGame.switch_scene("main")

while mainGame.running:
    mainGame.update()
    mainGame.draw()
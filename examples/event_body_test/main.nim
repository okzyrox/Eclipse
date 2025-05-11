# V2 - event body testing

import std/[strformat]

import ../../src/Eclipse

# Start game

var game = newGame() # the game and window are seperated
game.add(newScene("main")) # initialise a blank scene

# Init window
var window = newEclipseWindow("Eclipse - event body test", 800, 600, false, @[])

type 
  EvtBody = ref object of EventBody
    test: string

let evt = newEvent()

evt.connect("test", (
  proc(ge: GameEvent) = 
    if ge.body != nil:
      let body = EvtBody(ge.body)
      echo fmt"Received: {body.test}"
))

while game.running:
  # updates
  game.update()
  game.updateInputs()

  if game.keyIsReleased(Key_Escape):
    game.stop()
  
  if game.mouseIsReleased(Left):
    evt.fire("test", EvtBody(test: "hi"))
  
  # start drawing here
  window.clearScreen()
  window.draw(game)
  window.presentScreen()
  # end drawing here

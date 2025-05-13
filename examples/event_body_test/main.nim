# V2 - event body testing

import std/[strformat]

import ../../src/Eclipse

# Start game

var game: Game = newGame() # the game and window are seperated
type 
  EvtBody = ref object of EventBody
    test: string

proc main() =
  game = newGame()
  game.add(newScene("main")) # initialise a blank scene

  # Init window
  let window = newEclipseWindow("Eclipse - event body test", 800, 600, false)
  let evt = newEvent()

  evt.connect("test", (
    proc(ge: GameEvent) = 
      if ge.body != nil:
        let body = EvtBody(ge.body)
        echo fmt"Received: {body.test}"
  ))
  while game.running:
    game.beginFrame()
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
    game.endFrame()
  
when isMainModule:
  main()

# Entity test

import ../../src/Eclipse

# Start game

var game = newGame() # the game and window are seperated
game.add(newScene("main")) # initialise a blank scene

# Init window
var window = newEclipseWindow("V2 Window test", 800, 600, false, @[])

# connect to close event
game.onStop.connect("close1", (
  proc(ge: GameEvent) = 
    echo "I listen to when the Window is about to close; its closing right now!!"
))

while game.running:
  # updates
  game.update() # update the game (game objects, components, etc)
  game.updateInputs() # update inputs (keyboard and mouse)

  if game.keyIsReleased(Key_Escape): # key is released
    echo "esc released!!!"
    game.stop() # close the game using the built in stop func
    # clicking the `x` button will also call this
    # and will fire the onStop event
  
  if game.mouseIsDown(Left): # when the mouse is clicked (fires once)
    echo "left mouse button pressed"
  
  if game.mouseIsDown(Right):
    echo "right mouse button pressed"

  if game.mouseIsHeld(Left): # mouse button is held
    echo "holding left"
  
  if game.keyIsDown(Key_A): # key is down (follows typing mechanics with holding; for true hold use keyIsHeld)
    echo "Hi!!!"
  
  # start drawing here
  window.clearScreen()
  window.draw(game) # draw the game (draws the scene: game objects, ui, etc)
  window.presentScreen() # present the drawed stuff onto the window
  # end drawing here

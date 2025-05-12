import ../../src/Eclipse

# Start game

var game = newGame() # the game and window are seperated
game.add(newScene("main")) # initialise a blank scene

# Init window
var window = newEclipseWindow("Eclipse - Template", 800, 600, false)

while game.running:
  game.beginFrame() # start the "frame"
  # updates
  game.update()
  game.updateInputs()

  # start drawing here
  window.clearScreen()
  window.draw(game)
  window.presentScreen()
  # end drawing here 
  game.endFrame() # end the frame

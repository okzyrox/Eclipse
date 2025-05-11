# V2 testing

import std/[options, random]

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

var objBase = newObject("test")
objBase.addAttribute("color", drawcolor(255, 255, 255, 255))

proc movementScript(obj: var GameObjectInstance, cmp: Component) =
  if game.keyIsHeld(Key_Up):
    obj.position.y -= 0.1

  if game.keyIsHeld(Key_Down):
    obj.position.y += 0.1

  if game.keyIsHeld(Key_Left):
    obj.position.x -= 0.1

  if game.keyIsHeld(Key_Right):
    obj.position.x += 0.1

proc colorScript(obj: var GameObjectInstance, cmp: Component) =
  randomize()
  let r = rand(255).int
  let g = rand(255).int
  let b = rand(255).int
  let a = rand(255).int
  let newColor = drawcolor(
    r,
    g,
    b,
    a
  )
  discard obj.setAttribute("color", newColor)

  if game.keyIsReleased(Key_L):
    echo obj
    echo obj.components
    echo "position: ", obj.position
    let color = obj.getAttributeValue("color", DrawColor)
    echo "color: ", color.r, ", ", color.g, ", ", color.b, ", ", color.a

objBase.addComponent(movementScript)
objBase.addComponent(colorScript)

var objInstance = objBase.createObject()

while game.running:
  # updates
  game.update() # update the game (game objects, components, etc)
  game.updateInputs() # update inputs (keyboard and mouse)

  objInstance.update() # or add them to the scene, and do scene.update()

  if game.keyIsReleased(Key_Escape):
    game.stop() # close the game using the built in stop func
    # clicking the `x` button will also call this
    # and will fire the onStop event
  
  
  # start drawing here
  window.clearScreen()
  window.draw(game) # draw the game (draws the scene: game objects, ui, etc)
  let color = objInstance.getAttributeValue("color", DrawColor)
  window.drawRect(
    objInstance.position.x.int,
    objInstance.position.y.int,
    32,
    32,
    color
  )
  window.presentScreen() # present the drawed stuff onto the window
  # end drawing here

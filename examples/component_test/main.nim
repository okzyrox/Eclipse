# V2 - component testing

import std/[random, strformat, options]

import ../../src/Eclipse

# Start game

var game: Game


proc runOnce(objRef: var RootRef, cmp: Component) =
  var obj = GameObjectInstance(objRef)
  echo "I run once when the game object is created"
  echo fmt"Object ID: {obj.uid}"

# arrow keys movement
proc movementScript(objRef: var RootRef, cmp: Component) =
  # cast
  var obj = GameObjectInstance(objRef)

  if game.keyIsHeld(Key_Up):
    obj.position.y -= 10

  if game.keyIsHeld(Key_Down):
    obj.position.y += 10

  if game.keyIsHeld(Key_Left):
    obj.position.x -= 10

  if game.keyIsHeld(Key_Right):
    obj.position.x += 10

# scroll through colors in a rainbow
let cycleSpeed: uint8 = 1
proc colorScript(objRef: var RootRef, cmp: Component) =
  # cast
  var obj = GameObjectInstance(objRef)

  randomize()
  let oldColor = obj.getAttributeValue("color", DrawColor)
  var r = oldColor.r
  var g = oldColor.g
  var b = oldColor.b

  var colorState = obj.getAttributeValue("color_state", int)
  
  case colorState
  of 0: 
    g += cycleSpeed
    if g >= 255:
      g = 255
      colorState = 1
  of 1: 
    r -= cycleSpeed
    if r <= 0:
      r = 0
      colorState = 2
  of 2:
    b += cycleSpeed
    if b >= 255:
      b = 255
      colorState = 3
  of 3: 
    g -= cycleSpeed
    if g <= 0:
      g = 0
      colorState = 4
  of 4:
    r += cycleSpeed
    if r >= 255:
      r = 255
      colorState = 5
  of 5: 
    b -= cycleSpeed
    if b <= 0:
      b = 0
      colorState = 0
  else:
    r = 255
    g = 0
    b = 0
    colorState = 0
  
  r = max(0.uint8, min(r, 255))
  g = max(0.uint8, min(g, 255)) 
  b = max(0.uint8, min(b, 255))
  
  let newColor = drawcolor(
    r.uint8,
    g.uint8,
    b.uint8,
    255
  )
  discard obj.setAttribute("color", newColor)
  discard obj.setAttribute("color_state", colorState)

  if game.keyIsReleased(Key_L):
    echo obj
    echo obj.components
    echo "position: ", obj.position
    let color = obj.getAttributeValue("color", DrawColor)
    echo color


proc main() =
  game = newGame()
  game.add(newScene("main")) # initialise a blank scene

  # Init window
  let window = newEclipseWindow("Eclipse - Component test", 800, 600, false)

  var objBase = newObject("test")
  objBase.addAttribute("color", drawcolor(255, 255, 255, 255))
  objBase.addAttribute("color_state", 0)
  
  objBase.addComponent(runOnce, nil)
  objBase.addComponent(nil, movementScript)
  objBase.addComponent(nil, colorScript)

  var objInstance = objBase.createObject()
  var objInstance2 = objBase.createObject() # to showcase startScripts for components

  while game.running:
    game.beginFrame()
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
    game.endFrame()

when isMainModule:
  main()
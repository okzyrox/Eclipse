# V2 testing

import std/[options]

import ../../src/Eclipse

# Start game

var game: Game

proc main() =
  game = newGame() # the game and window are seperated
  game.add(newScene("main")) # initialise a blank scene

  # Init window
  let window = newEclipseWindow("Eclipse - example test", 800, 600, false)

  # connect to close event
  game.onStop.connect("close1", (
    proc(ge: GameEvent) = 
      echo "I listen to when the Window is about to close; its closing right now!!"
  ))

  var objBase = newObject("test")
  objBase.addAttribute("position", Vec2(x: 0, y: 0)) # there is honestly 0 reason to make an attribute for this
  # but its just a template so idrc
  var objInstance = objBase.createObject()
  var objInstance2 = objBase.createObject()

  while game.running:
    game.beginFrame()
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
    
    # controllable instances with WASD and arrow keys
    
    if game.keyIsHeld(Key_Up):
      let oldPos = objInstance.getAttribute("position").get().getAttributeValue(Vec2) 
      # not much we can do about this function hell
      # unless we implement `.get()` in getAttributeValue?
      # or implement both `.get()` and `.getAttributeValue()` in getAttribute?
      # depends on the use case, sometimes we may want to get the attribute, but dont want the value
      # maybe `GameObjectInstance.getAttribute("position")` and `GameObjectInstance.getAttributeValue("position")`?

      let newPos = oldPos + Vec2(x: 0, y: -15)
      discard objInstance.setAttribute("position", newPos)

    if game.keyIsHeld(Key_Down):
      let oldPos = objInstance.getAttribute("position").get().getAttributeValue(Vec2)
      let newPos = oldPos + Vec2(x: 0, y: 15)
      discard objInstance.setAttribute("position", newPos)

    if game.keyIsHeld(Key_Left):
      let oldPos = objInstance.getAttribute("position").get().getAttributeValue(Vec2)
      let newPos = oldPos + Vec2(x: -15, y: 0)
      discard objInstance.setAttribute("position", newPos)

    if game.keyIsHeld(Key_Right):
      let oldPos = objInstance.getAttribute("position").get().getAttributeValue(Vec2)
      let newPos = oldPos + Vec2(x: 15, y: 0)
      discard objInstance.setAttribute("position", newPos)

    # seperate instances

    if game.keyIsHeld(Key_W):
      let oldPos = objInstance2.getAttribute("position").get().getAttributeValue(Vec2)
      let newPos = oldPos + Vec2(x: 0, y: -15)
      discard objInstance2.setAttribute("position", newPos)

    if game.keyIsHeld(Key_S):
      let oldPos = objInstance2.getAttribute("position").get().getAttributeValue(Vec2)
      let newPos = oldPos + Vec2(x: 0, y: 15)
      discard objInstance2.setAttribute("position", newPos)

    if game.keyIsHeld(Key_A):
      let oldPos = objInstance2.getAttribute("position").get().getAttributeValue(Vec2)
      let newPos = oldPos + Vec2(x: -15, y: 0)
      discard objInstance2.setAttribute("position", newPos)

    if game.keyIsHeld(Key_D):
      let oldPos = objInstance2.getAttribute("position").get().getAttributeValue(Vec2)
      let newPos = oldPos + Vec2(x: 15, y: 0)
      discard objInstance2.setAttribute("position", newPos)
      
    
    # start drawing here
    window.clearScreen()
    window.draw(game) # draw the game (draws the scene: game objects, ui, etc)
    let pixelPos = objInstance.getAttribute("position").get().getAttributeValue(Vec2)
    window.drawRect(
      pixelPos.x.int,
      pixelPos.y.int,
      32,
      32,
      drawcolor(255, 0, 0, 255)
    )
    let pixelPos2 = objInstance2.getAttribute("position").get().getAttributeValue(Vec2)
    window.drawRect(
      pixelPos2.x.int,
      pixelPos2.y.int,
      32,
      32,
      drawcolor(0, 255, 0, 255)
    )
    window.presentScreen() # present the drawed stuff onto the window
    # end drawing here
    game.endFrame()

when isMainModule:
  main()
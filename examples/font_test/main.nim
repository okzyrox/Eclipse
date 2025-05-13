# Font stuff
import ../../src/Eclipse

# Start game
var game: Game

proc main() =
  game = newGame()
  game.setTargetFPS(120)
  game.add(newScene("main"))

  discard game.loadFont("main", "sans.ttf", 16)
  game.setDefaultFont("main")

  # Init window
  let window = newEclipseWindow("Eclipse - Template", 800, 600, false)

  var mainFont = game.getFont("main")
  mainFont.setStyle({Bold})
  let color = drawcolor(255, 0, 0, 255)
  let fpsColor = drawcolor(0, 0, 0, 255)

  while game.running:
    game.beginFrame()

    # updates
    game.update()
    game.updateInputs()

    if game.keyIsReleased(Key_Escape):
      game.stop()

    # Render
    window.clearScreen()
    window.draw(game)
    window.renderText("Test Text", 400, 50, mainFont, color, Center)
    let fpsText = "FPS: " & $int(game.getFPS())
    window.renderText(fpsText, 10, 10, mainFont, fpsColor)
    window.presentScreen()
    
    game.endFrame()
  
when isMainModule:
  main()
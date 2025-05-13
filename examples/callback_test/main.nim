# Alternative way of running the game; via callbacks
import ../../src/Eclipse

var game: Game
game = newGame()
game.add(newScene("main"))
let window = newEclipseWindow("Eclipse - Callbacks", 800, 600, false)

var mainFont: EclipseFont
var fps: int

proc initGame*(win: EclipseWindow, game: var Game) =
  echo "init game"
  mainFont = game.loadFont("main", "sans.ttf", 16)
  game.setDefaultFont("main")

proc updateGame*(win: EclipseWindow, game: var Game) =
  if game.keyIsReleased(Key_Escape):
    game.stop()
  if game.keyIsReleased(Key_W):
    echo "W released"
  if game.keyIsReleased(Key_A):
    echo "A released"
  if game.keyIsReleased(Key_S):
    echo "S released"
  if game.keyIsReleased(Key_D):
    echo "D released"
  
  fps = int(game.getFPS())

let color = drawcolor(255, 0, 0, 255)
proc drawGame*(win: EclipseWindow, game: var Game) =
  win.drawRect(0, 0, 800, 600, color)
  win.renderText("FPS: " & $fps, 10, 10, mainFont, drawcolor(255, 255, 255, 255))

game.init = initGame
game.update = updateGame
game.draw = drawGame

game.run(window)
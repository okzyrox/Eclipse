# Eclipse textures / sprite objects
import ../../src/Eclipse
import math

var game: Game
game = newGame()
game.add(newScene("main"))
let window = newEclipseWindow("Eclipse - Texture Test", 800, 600, false)

var 
  mainFont: EclipseFont
  playerSprite: SpriteObjectInstance
  angle: float32 = 0
  fps: int
  flipped: bool = false

proc playerUpdateCmp*(objRef: var RootRef, cmp: Component) =
  var sobj = SpriteObjectInstance(objRef)

  let speed = 200.0 * game.getDt()
  
  # Move
  if game.keyIsHeld(Key_Left):
    sobj.position.x -= speed
    sobj.flip = FlipHorizontal.int32
    flipped = true
  
  if game.keyIsHeld(Key_Right):
    sobj.position.x += speed
    sobj.flip = FlipNone.int32
    flipped = false
  
  if game.keyIsHeld(Key_Up):
    sobj.position.y -= speed
  
  if game.keyIsHeld(Key_Down):
    sobj.position.y += speed
  
  # Rotate
  if game.keyIsHeld(Key_A):
    angle -= 90.0 * game.getDt()
    angle = max(angle, 0.0)
  
  if game.keyIsHeld(Key_D):
    angle += 90.0 * game.getDt()
    angle = min(angle, 360.0)
  sobj.rotation = angle
  
  # Pulse
  if game.keyIsHeld(Key_Space):
    let pulse = (sin(getTicks().float / 200.0) + 1.0) / 2.0
    var color = sobj.spriteObject.texture.color
    color.r = uint8(255.0 * pulse)
    color.g = uint8(255.0 * pulse)
    color.b = uint8(255.0 * pulse)
    sobj.spriteObject.texture.setTextureColor(color)

proc initGame*(win: EclipseWindow, game: var Game) =
  mainFont = game.loadFont("main", "sans.ttf", 16)
  game.setDefaultFont("main")
  
  # Load textures
  var playerTexture = game.loadTexture(win, "blank.png", "player")
  # ID assigned as "player", 
    
  # Create SpriteObject; variant of GameObject with a texture attached
  var playerObj = newSpriteObject("player")
  # sprite specific component
  var spriteComponent = newSpriteComponent(nil, playerUpdateCmp)
  playerObj.addComponent(spriteComponent)
  playerObj.setTexture(playerTexture)
  
  playerObj.setPosition(
    (window.width - 32) div 2,
    (window.height - 32) div 2
  )
  
  playerSprite = createObject(playerObj)
  playerSprite.scale = Vec2(x: 2.0, y: 2.0)
  game.currentScene.add(playerSprite)

proc updateGame*(win: EclipseWindow, game: var Game) =
  if game.keyIsReleased(Key_Escape):
    game.stop()
  
  fps = int(game.getFPS())

let textColor = drawcolor(0, 0, 0, 255)
proc drawGame*(win: EclipseWindow, game: var Game) =
  # info
  win.renderText("FPS: " & $fps, 10, 10, mainFont, textColor)
  win.renderText("Arrow Keys: Move", 10, 30, mainFont, textColor)
  win.renderText("A/D: Spin", 10, 50, mainFont, textColor)
  win.renderText("Space: Pulse Texture", 10, 70, mainFont, textColor)
  win.renderText("ESC: Quit", 10, 90, mainFont, textColor)

  win.renderText(
    "Pos (x y): " & $playerSprite.position.x.int & " " & $playerSprite.position.y.int,
    10,
    140,
    mainFont,
    textColor
  )
  win.renderText(
    "Rotation: " & $playerSprite.rotation,
    10,
    160,
    mainFont,
    textColor
  )
  let flipText = if flipped: "Flipped" else: "Not Flipped"
  win.renderText(
    "Is flipped?: " & flipText,
    10,
    180,
    mainFont,
    textColor
  )

game.init = initGame
game.update = updateGame
game.draw = drawGame

game.run(window)
#-- Eclipse Engine -- 
# Author: ZyroX

## Game
##
## Game houses all the scenes, and handles the game loop

import std/[strformat]

import sdl2
import sdl2/[ttf]
import sdl2/image as sdl2img 
# only using a alias cause `init` and `quit` are common names with other system functions
# i know nim resolves them regardless, but its more readable like this

import ./[common, window, scene, font, inputs, events, texture]
import gameobject/[base]

type 
  GameProc = proc(window: EclipseWindow, game: var Game)
  EclipseGame = object
    running*: bool

    scenes: seq[Scene]
    currentScene*: Scene
    inputManager*: InputManager
    fontManager*: FontManager
    textureManager*: TextureManager
    evt: Event

    onStart*: GameEvent = newEvent()
    onStop*: GameEvent = newEvent()

    # delta / framerate
    deltaTimeCount: uint64
    deltaTimeCountPrev: uint64

    frameDelay*: uint32
    fpsUpdateTime: uint32
    frameStartTime: uint32
    targetFPS*: int
    frameCount: int

    deltaTime*: float32
    currentFPS*: float

    # optional procs
    initProc*: GameProc
    updateProc*: GameProc
    drawProc*: GameProc
  Game* = ref EclipseGame

proc newGame*(): Game =
  discard sdl2.init(INIT_EVERYTHING) # Init everything doesnt actually include external modules
  # like ttf
  if ttfInit() != SdlSuccess:
      echo "Failed to initialize SDL2-TTF"
      ttfQuit()
  if sdl2img.init(IMG_INIT_PNG) == 0:
    logEclipse "Failed to initialize SDL2_image"
    sdl2img.quit()
  let fpsCap = 60
  result = Game(
      running: true,
      deltaTimeCount: getPerformanceCounter(),
      inputManager: newInputManager(),
      fontManager: newFontManager(),
      textureManager: newTextureManager(),
      targetFPS: fpsCap,
      frameDelay: uint32(1000 div fpsCap),
      currentFPS: 0.0,
      frameCount: 0,
      fpsUpdateTime: getTicks()
  )
  result.onStart.fireAll()

proc getDt*(game: Game): float32 = game.deltaTime
proc getFPS*(game: Game): float = game.currentFPS
proc getFrameCount*(game: Game): int = game.frameCount

proc setTargetFPS*(game: var Game, targetFPS: int) =
  game.targetFPS = max(1, targetFPS) # lim
  game.frameDelay = uint32(1000 div game.targetFPS)

proc add*(game: var Game, scene: Scene) =
  game.scenes.add(scene)
  game.currentScene = scene

proc switchScene*(game: var Game, scene: Scene) =
  if game.currentScene == scene:
    logEclipse "Already on that scene"
    return
  elif game.currentScene notin game.scenes:
    logEclipse "Scene not found"
    return
  else:
    game.currentScene = scene

proc switchScene*(game: var Game, id: string) =
  for scene in game.scenes:
    if scene.id == id:
      game.switch_scene(scene)

proc update*(game: var Game) =
  var previousCounter = game.deltaTimeCount
  game.deltaTimeCount = getPerformanceCounter()

  game.deltaTime = (game.deltaTimeCount - previousCounter).float / getPerformanceFrequency().float
  game.currentScene.update()
  
  # fps
  inc game.frameCount
  let currentTime = getTicks()
  let timeElapsed = currentTime - game.fpsUpdateTime
  
  if timeElapsed >= 1000:
    game.currentFPS = game.frameCount.float * 1000.0 / timeElapsed.float
    game.frameCount = 0
    game.fpsUpdateTime = currentTime

proc draw*(ew: EclipseWindow, obj: GameObjectInstance) =
  discard

proc beginFrame*(game: var Game) =
  game.frameStartTime = getTicks()

proc endFrame*(game: var Game) =
  let frameTime = getTicks() - game.frameStartTime
  
  # delay if faster than target frametime
  if game.frameDelay > frameTime:
    let delayTime = game.frameDelay - frameTime
    delay(delayTime)

proc draw*(ew: EclipseWindow, scene: var Scene) =
  scene.draw(ew)

proc draw*(ew: EclipseWindow, game: var Game) =
  # draw(renderer, game.currentScene)
  draw(ew, game.currentScene)

## UI

# proc draw*(renderer: WindowRenderer, ui_element: UIElement) =
#     case ui_element.ui_type:
#     of UIType.uitText:
#         if ui_element.t_font.isNil:
#             echo "Font is nil"
#         let sdl2_renderer = renderer.sdl2_renderer
#         var
#             text_color = ui_element.fore_color
#             has_border = ui_element.t_border_size > 0

#         if has_border:
#             ui_element.t_font.setFontOutline(ui_element.t_border_size.cint)
#             var temp = cast[UIElement](ui_element)
#             temp.fore_color = ui_element.t_border_color
#             temp.t_border_size = 0
#             draw(renderer, temp)

#         let surface = ui_element.t_font.renderUtf8Blended(ui_element.t_text.cstring, (text_color.r, text_color.g, text_color.b, text_color.a))
#         if surface.isNil:
#             echo "Could not render text surface"

#         discard surface.setSurfaceAlphaMod(text_color.a)

#         var outline = if has_border: ui_element.t_border_size else: 0
#         var source = rect(0, 0, surface.w, surface.h)
#         var dest = rect(ui_element.position.x.cint - outline.cint, ui_element.position.y.cint - outline.cint, surface.w, surface.h)
#         let texture = sdl2_renderer.createTextureFromSurface(surface)

#         if texture.isNil:
#             echo "Could not create texture from rendered text"

#         surface.freeSurface()

#         sdl2_renderer.copyEx(texture, source, dest, angle = 0.0, center = nil,
#                         flip = SDL_FLIP_NONE)
#     of UIType.uitButton:
#         discard

# proc draw_ui*(renderer: WindowRenderer, scene: var Scene) =
#     for element in scene.ui.elements:
#         draw(renderer, element)

# proc draw_ui*(renderer: WindowRenderer, game: var Game) =
#     draw_ui(renderer, game.currentScene)

## Fonts

proc loadFont*(game: var Game, id: string, path: string, size: int = 16): EclipseFont =
  result = game.fontManager.load(id, path, size)

proc getFont*(game: Game, id: string): EclipseFont = # raises
  result = game.fontManager.get(id)

proc setDefaultFont*(game: var Game, id: string) =
  game.fontManager.setDefaultFont(id)

proc getDefaultFont*(game: Game): EclipseFont = # raises
  result = game.fontManager.getDefaultFont()


## Textures

proc loadTexture*(game: var Game, ew: EclipseWindow, path: string, id: string): EclipseTexture =
  if game.textureManager.hasTexture(id):
    logEclipse "Texture already loaded: ", id
    return game.textureManager.getTexture(id)
  
  var texture = ew.loadTexture(path) # raises
  game.textureManager.addTexture(texture, id)
  logEclipse fmt"Texture '{id}' loaded successfully from {path}"
  result = texture

proc stop*(game: var Game) =
  game.onStop.fireAll()
  game.textureManager.clearTextures()
  game.running = false
    

## Input

proc updateInputs*(game: var Game) =
  let state = updateInputs(game.input_manager)
  if state == WindowQuit:
      game.stop()
  else:
    if state == None:
      discard
    else:
      logEclipse "Event: ", $state
      discard

proc keyIsDown*(game: var Game, key: InputKey): bool =
  return game.inputManager.keyIsDown(key)

proc keyIsHeld*(game: var Game, key: InputKey): bool =
  return game.inputManager.keyIsHeld(key)

proc keyIsReleased*(game: var Game, key: InputKey): bool =
  return game.inputManager.keyIsReleased(key)

proc mouseIsDown*(game: var Game, button: MouseButton): bool =
  return game.inputManager.mouseIsDown(button)

proc mouseIsHeld*(game: var Game, button: MouseButton): bool =
  return game.inputManager.mouseIsHeld(button)

proc mouseIsReleased*(game: var Game, button: MouseButton): bool =
  return game.inputManager.mouseIsReleased(button)


## callback stuff

proc `init=`*(game: var Game, script: GameProc) =
  game.initProc = script

proc `update=`*(game: var Game, script: GameProc) =
  game.updateProc = script

proc `draw=`*(game: var Game, script: GameProc) =
  game.drawProc = script

# run with callbacks
proc run*(game: var Game, window: EclipseWindow) =
  game.onStart.fireAll()
  game.running = true
  game.initProc(window, game)
  while game.running:
    game.beginFrame()
    
    game.updateInputs()
    game.update()
    game.updateProc(window, game)

    window.clearScreen()
    window.draw(game)
    game.drawProc(window, game)
    window.presentScreen()

    game.endFrame()
  game.stop()
#-- Eclipse Engine -- 
# Author: ZyroX

## Game
##
## Game houses all the scenes, and handles the game loop

import sdl2

import ./[common, window, scene, inputs, events]
import gameobject/[base]

type GameData* = object
  id: string
  value: (int, float, string)

type EclipseGame = object
  running*: bool #

  scenes: seq[Scene]
  currentScene*: Scene
  inputManager*: InputManager
  fontManager*: FontManager

  deltaTimeCount: uint64
  deltaTimeCountPrev: uint64
  deltaTime*: float32
  #data: seq[GameData]
  evt: Event
  # game events

  onStart*: GameEvent = newEvent()
  onStop*: GameEvent = newEvent()

type Game* = ref EclipseGame

proc `$`*(game: Game): string =
  "<Game: " & "running: " & $game.running & ">"

proc newGame*(): Game =
  discard sdl2.init(INIT_EVERYTHING) # Init everything doesnt actually include external modules
  # like ttf
  # if not ttfInit():
  #     echo "Failed to initialize SDL2-TTF"
  #     ttfQuit()

  result = Game(
      running: true,
      deltaTimeCount: getPerformanceCounter()
  )
  result.onStart.fireAll()

proc getDt*(game: Game): float32 = game.deltaTime

proc add*(game: var Game, scene: Scene) =
  game.scenes.add(scene)
  game.currentScene = scene

# shorthand for adding an tntity to the current scene
# kinda weird but who cares

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

proc draw*(ew: EclipseWindow, obj: GameObjectInstance) =
  discard
  # renderer.get_sdl2_renderer().setDrawColor(entity.color.r, entity.color.g, entity.color.b, entity.color.a)
  # var r = rect(
  #     cint(entity.position.x), cint(entity.position.y),
  #     cint(2 * entity.scale.x), cint(2 * entity.scale.y)
  # )
  # renderer.get_sdl2_renderer().fillRect(r)

proc draw*(ew: EclipseWindow, scene: var Scene) =
  for obj in scene.objects:
    draw(ew, obj)

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

# ## Fonts


# proc addFont*(game: var Game, id: string, path: string): bool =
#     return game.fontManager.addFont(id, path)

# proc getFont*(game: var Game, id: string): FontPtr =
#     return game.fontManager.getFont(id)

proc stop*(game: var Game) =
  game.onStop.fireAll()
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
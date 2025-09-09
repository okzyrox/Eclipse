# spin

import ../../src/Eclipse
import math 

var game: Game
game = newGame()
game.add(newScene("main"))
let window = newEclipseWindow("Eclipse - WindowFx", 800, 600, false, true)

var mainFont: EclipseFont

var fps: int

# Ellipse
var angle: float = 0.0
var speed: float = 0.02
var centerX = 0.0
var centerY = 0.0
const radius = 350

# PulseScale
var pulseTime: float = 0.0
const pulseBaseW = 800
const pulseBaseH = 600
const pulseAmount = 60

# BeatEllipse
var beatAngle: float = 0.0
var beatTargetAngle: float = 0.0
var bpm: float = 100.0
var beatTimer: float = 0.0
var beatIncrementDeg: float = 30.0
const minBpm = 30.0
const maxBpm = 300.0
const minInc = 5.0
const maxInc = 90.0

# mode
type Mode = enum
  None, Ellipse, BeatEllipse, PulseScale 
proc `$`(m: Mode): string =
  case m:
  of Mode.None:       result = "None"
  of Mode.Ellipse:    result = "Ellipse"
  of Mode.BeatEllipse: result = "Beat-Ellipse"
  of Mode.PulseScale: result = "Pulse-Scale"
var currentMode = Mode.None

proc cycleMode() =
  case currentMode:
  of Mode.None:
    currentMode = Mode.Ellipse
  of Mode.Ellipse:
    currentMode = Mode.BeatEllipse
  of Mode.BeatEllipse:
    currentMode = Mode.PulseScale
  of Mode.PulseScale:
    currentMode = Mode.None
  
  window.setWindowTitle("Eclipse - " & "[" & $currentMode & "]")

proc initGame*(win: EclipseWindow, game: var Game) =
  mainFont = game.loadFont("main", "sans.ttf", 18)
  game.setDefaultFont("main")

  centerX = 1920 / 2
  centerY = 1080 / 2


proc updateGame*(win: EclipseWindow, game: var Game) =
  if game.keyIsReleased(Key_Escape):
    game.stop()

  if game.keyIsReleased(Key_K):
    cycleMode()

  case currentMode:
  of Mode.Ellipse:
    if game.keyIsDown(Key_Up):
      speed += 0.001
      speed = round(speed, 4)
    if game.keyIsDown(Key_Down):
      speed = max(0.001, speed - 0.001)
      speed = round(speed, 4)

    angle += speed
    if angle > 2 * PI:
      angle -= 2 * PI

    let winX = int(centerX + radius * cos(angle) - win.width.float / 2)
    let winY = int(centerY + radius * sin(angle) - win.height.float / 2)

    angle = round(angle, 6)
    win.setWindowPosition(winX, winY)

  of Mode.PulseScale:
    pulseTime += 0.025
    let scale = 1.0 - (sin(pulseTime) * 0.5 + 0.5) * (pulseAmount.float / pulseBaseW.float)
    let w = int(pulseBaseW.float * scale)
    let h = int(pulseBaseH.float * scale)
    let winX = int(centerX - w.float / 2)
    let winY = int(centerY - h.float / 2)

    pulseTime = round(pulseTime, 4)
    win.setWindowSize(w, h)
    win.setWindowPosition(winX, winY)

  of Mode.BeatEllipse:
    if game.keyIsDown(Key_Up):
      bpm = min(maxBpm, bpm + 1)
    if game.keyIsDown(Key_Down):
      bpm = max(minBpm, bpm - 1)
    if game.keyIsDown(Key_Right):
      beatIncrementDeg = min(maxInc, beatIncrementDeg + 5)
    if game.keyIsDown(Key_Left):
      beatIncrementDeg = max(minInc, beatIncrementDeg - 5)

    # Beat timer
    let beatInterval = 60.0 / bpm
    beatTimer += 1.0 / 60.0 #  ~60fps
    if beatTimer >= beatInterval:
      beatTimer -= beatInterval
      beatTargetAngle += degToRad(beatIncrementDeg)
      if beatTargetAngle > 2 * PI:
        beatTargetAngle -= 2 * PI

    # Smoothly ease beatAngle toward beatTargetAngle, handling wraparound
    let ease = 0.2
    var diff = beatTargetAngle - beatAngle
    # Normalize diff to [-PI, PI] for shortest path
    if diff > PI:
      diff -= 2 * PI
    elif diff < -PI:
      diff += 2 * PI
    if abs(diff) > 0.001:
      beatAngle += diff * ease
    else:
      beatAngle = beatTargetAngle
    # Keep beatAngle in [0, 2*PI]
    if beatAngle < 0:
      beatAngle += 2 * PI
    elif beatAngle > 2 * PI:
      beatAngle -= 2 * PI

    beatAngle = round(beatAngle, 6)
    beatTargetAngle = round(beatTargetAngle, 6)

    let winX = int(centerX + radius * cos(beatAngle) - win.width.float / 2)
    let winY = int(centerY + radius * sin(beatAngle) - win.height.float / 2)
    win.setWindowPosition(winX, winY)

  else:
    discard

  fps = int(game.getFPS())


let color = drawcolor(255, 0, 0, 255)
proc drawGame*(win: EclipseWindow, game: var Game) =
  let size = win.getWindowSize()
  let width = size.x.int
  let height = size.y.int
  win.drawRect(0, 0, width, height, color)
  win.renderText("FPS: " & $fps, 10, 10, mainFont, drawcolor(255, 255, 255, 255))
  win.renderText("Mode: " & $currentMode & " [K]", 10, 40, mainFont, drawcolor(255, 255, 255, 255))
  if currentMode == Mode.BeatEllipse:
    win.renderText("BPM: " & $bpm & " [↑ / ↓]", 10, 70, mainFont, drawcolor(255, 255, 255, 255))
    win.renderText("Inc: " & $beatIncrementDeg & " deg" & " [← / →]", 10, 100, mainFont, drawcolor(255, 255, 255, 255))
    win.renderText("Beat Angle: " & $beatAngle, 10, 130, mainFont, drawcolor(255, 255, 255, 255))
    win.renderText("Target Angle: " & $beatTargetAngle, 10, 160, mainFont, drawcolor(255, 255, 255, 255))
  elif currentMode == Mode.PulseScale:
    win.renderText("Pulse Time: " & $pulseTime, 10, 70, mainFont, drawcolor(255, 255, 255, 255))
  elif currentMode == Mode.Ellipse:
    win.renderText("Angle: " & $angle, 10, 70, mainFont, drawcolor(255, 255, 255, 255))
    win.renderText("Speed: " & $speed & " [↑ / ↓]", 10, 100, mainFont, drawcolor(255, 255, 255, 255))
  else:
    discard

game.init = initGame
game.update = updateGame
game.draw = drawGame

game.run(window)
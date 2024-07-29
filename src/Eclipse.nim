#-- Eclipse Engine -- 
# Author: ZyroX

## Eclipse Engine

import Eclipse/[
  game,
  window,
  entity,
  scene,
  inputs,
  ui,
  common
]

when defined(EclipseDebug):
  import std/logging
  var cl = newConsoleLogger(levelThreshold = lvlDebug)
  var fl = newFileLogger(levelThreshold = lvlDebug)
  addHandler(cl)
  addHandler(fl)

import sdl2

export game, window, entity, scene, inputs, common, ui, sdl2
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
  events,
  component,
  common
]

when defined(EclipseDebug):
  import std/logging
  var cl = newConsoleLogger(levelThreshold = lvlDebug)
  var fl = newFileLogger("eclipse_debug.log", levelThreshold = lvlDebug)
  addHandler(cl)
  addHandler(fl)

import sdl2

export game, window, entity, scene, inputs, ui, events, component, common, sdl2
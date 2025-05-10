#-- Eclipse Engine -- 
# Author: ZyroX

## Eclipse Engine

import Eclipse/[
  game,
  window,
  scene,
  inputs,
  #ui,
  events,
  common
]

when defined(EclipseDebug):
  import std/[logging, os]
  if fileExists("eclipse_debug.log"):
    removeFile("eclipse_debug.log")
  var cl = newConsoleLogger(levelThreshold = lvlDebug)
  var fl = newFileLogger("eclipse_debug.log", levelThreshold = lvlDebug)
  addHandler(cl)
  addHandler(fl)

import sdl2

export game, window, scene, inputs, events, common, sdl2
# ui,

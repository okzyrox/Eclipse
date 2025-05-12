#-- Eclipse Engine -- 
# Author: ZyroX

## Eclipse Engine

import Eclipse/[
  game,
  window,
  scene,
  inputs,
  font,
  events,
  common,
  attribute,
  utils
]

import Eclipse/gameobject/[
  base,
  drawable
]

when EclipseDebugging:
  import std/[logging, os]
  if fileExists("eclipse_debug.log"):
    removeFile("eclipse_debug.log")
  var cl = newConsoleLogger(levelThreshold = lvlDebug)
  var fl = newFileLogger("eclipse_debug.log", levelThreshold = lvlDebug)
  addHandler(cl)
  addHandler(fl)

import sdl2

export game, window, scene, inputs, font, events, common, attribute, utils, sdl2
export base, drawable
# ui,

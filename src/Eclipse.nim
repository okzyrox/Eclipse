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
  
  let format = "[$time] - $levelname: "
  var cl = newConsoleLogger(levelThreshold = lvlDebug, fmtStr = format)
  var fl = newFileLogger("eclipse_debug.log", levelThreshold = lvlDebug, fmtStr = format)
  addHandler(cl)
  addHandler(fl)

import sdl2

export game, window, scene, inputs, font, events, common, attribute, utils, sdl2
export base, drawable
# ui,

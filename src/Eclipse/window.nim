#-- Eclipse Engine -- 
# Author: ZyroX

## Window

import std/[options]

import sdl2, sdl2/[image, ttf]

import ./[common]

type EclipseWindow* = object
  width*: int
  height*: int
  title*: string
  fullscreen*: bool
  flags*: seq[cuint]

  window*: Option[WindowPtr] = none(WindowPtr)
  renderer*: Option[RendererPtr] = none(RendererPtr)

proc newWindowPtr(ew: EclipseWindow): WindowPtr =
  result = createWindow(
    ew.title.cstring,
    SDL_WINDOWPOS_CENTERED,
    SDL_WINDOWPOS_CENTERED,
    ew.width.cint,
    ew.height.cint,
    SDL_WINDOW_SHOWN or SDL_WINDOW_RESIZABLE
  )

proc newEclipseWindow*(title: string, width, height: int, fullscreen: bool, flags: seq[cuint]): EclipseWindow =
  var ew = EclipseWindow(
    width: width,
    height: height,
    title: title,
    fullscreen: fullscreen,
    flags: flags
  )

  let window = newWindowPtr(ew)
  if window == nil:
    logEclipse "Failed to create window"
    quit(1)
  ew.window = some(window)
  let renderer = createRenderer(window, -1, Renderer_Accelerated)
  if renderer == nil:
    logEclipse "Failed to create renderer"
    quit(1)
  ew.renderer = some(renderer)

  result = ew

proc clearScreen*(ew: EclipseWindow): void =
  if ew.renderer.isSome:
    var wr = ew.renderer.get()
    wr.setDrawColor(255, 255, 255, 255)
    wr.clear()
  
proc drawPixel*(ew: EclipseWindow, x, y: int, color: DrawColor): void =
  if ew.renderer.isSome:
    var wr = ew.renderer.get()
    wr.setDrawColor(color.r, color.g, color.b, color.a)
    wr.drawPoint(x.cint, y.cint)

proc drawRect*(ew: EclipseWindow, x, y, w, h: int, color: DrawColor, fill: bool = true): void =
  if ew.renderer.isSome:
    var wr = ew.renderer.get()
    wr.setDrawColor(color.r, color.g, color.b, color.a)
    var rec = rect(x.cint, y.cint, w.cint, h.cint)
    if fill:
      wr.fillRect(rec)
    else:
      wr.drawRect(rec)

proc presentScreen*(ew: EclipseWindow): void =
  if ew.renderer.isSome:
    var wr = ew.renderer.get()
    wr.present()
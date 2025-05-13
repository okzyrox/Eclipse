#-- Eclipse Engine -- 
# Author: ZyroX

## Window

import std/[options, strutils]

import sdl2

import ./[common, font]

type 
  EclipseWindow* = object
    width*: int
    height*: int
    title*: string
    fullscreen*: bool
    flags*: seq[RendererFlags]

    window*: Option[WindowPtr] = none(WindowPtr)
    renderer*: Option[RendererPtr] = none(RendererPtr)
    
  RendererFlags* = enum
    SoftwareRendering = Renderer_Software
    HardwareRendering = Renderer_Accelerated
    VsyncEnabled = Renderer_PresentVsync
    RendererTarget = Renderer_TargetTexture

proc `$`*(flag: RendererFlags): string =
  case flag:
    of SoftwareRendering: result = "SoftwareRendering"
    of HardwareRendering: result = "HardwareRendering"
    of VsyncEnabled: result = "VsyncEnabled"
    of RendererTarget: result = "RendererTarget"

proc `$`*(flags: seq[RendererFlags]): string =
  result = ""
  for flag in flags:
    result.add($flag & " ")
  result = result.strip

proc newWindowPtr(ew: EclipseWindow): WindowPtr =
  result = createWindow(
    ew.title.cstring,
    SDL_WINDOWPOS_CENTERED,
    SDL_WINDOWPOS_CENTERED,
    ew.width.cint,
    ew.height.cint,
    SDL_WINDOW_SHOWN or SDL_WINDOW_RESIZABLE
  )

template makeFlags*(flags: seq[RendererFlags]): cint =
  block:
    var result: cint = 0
    for flag in flags:
      result = result or flag.cint
    result

proc newEclipseWindow*(title: string, width, height: int, fullscreen: bool, flags: seq[RendererFlags]): EclipseWindow =
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
  logEclipse "Initialsing renderer with flags: " & $flags
  let rendererFlags = makeFlags(flags)
  let renderer = createRenderer(window, -1, rendererFlags)
  if renderer == nil:
    logEclipse "Failed to create renderer"
    quit(1)
  ew.renderer = some(renderer)

  result = ew

proc newEclipseWindow*(title: string, width, height: int, fullscreen: bool = false): EclipseWindow =
  result = newEclipseWindow(title, width, height, fullscreen, @[HardwareRendering, VsyncEnabled])

proc clearScreen*(ew: EclipseWindow): void =
  if ew.renderer.isNone:
    logEclipse "Cannot clear screen: renderer is none"
    return
  let wr = ew.renderer.get()
  wr.setDrawColor(255, 255, 255, 255)
  wr.clear()
  
proc drawPixel*(ew: EclipseWindow, x, y: int, color: DrawColor): void =
  if ew.renderer.isNone:
    logEclipse "Cannot draw pixel: renderer is none"
    return
  let wr = ew.renderer.get()
  wr.setDrawColor(color.r, color.g, color.b, color.a)
  wr.drawPoint(x.cint, y.cint)

proc drawRect*(ew: EclipseWindow, x, y, w, h: int, color: DrawColor, fill: bool = true): void =
  if ew.renderer.isNone:
    logEclipse "Cannot draw rectangle: renderer is none"
    return
  let wr = ew.renderer.get()
  wr.setDrawColor(color.r, color.g, color.b, color.a)
  var rec = rect(x.cint, y.cint, w.cint, h.cint)
  if fill:
    wr.fillRect(rec)
  else:
    wr.drawRect(rec)

proc presentScreen*(ew: EclipseWindow): void =
  if ew.renderer.isNone:
    logEclipse "Cannot present screen: renderer is none"
    return
  let wr = ew.renderer.get()
  wr.present()

proc renderText*(ew: EclipseWindow, text: string, x, y: int, font: EclipseFont, color: DrawColor, align: TextAlign = Left): void =
  if ew.renderer.isNone:
    logEclipse "Cannot render text: renderer is none"
    return
  let renderer = ew.renderer.get()
  
  let (width, height) = font.getTextSize(text)
  var textX = x.cint
  
  case align:
    of Left:
      discard
    of Center:
      textX = (x - width div 2).cint
    of Right:
      textX = (x - width).cint
  
  let surface = font.renderText(text, color)
  if surface.isNil:
    logEclipse "Failed to create surface for text"
    return
    
  defer: surface.freeSurface()
  
  let texture = renderer.createTextureFromSurface(surface)
  if texture.isNil:
    logEclipse "Failed to create texture from rendered text: " & $getError()
    return
  
  defer: texture.destroy()
  
  let destRect = rect(textX, y.cint, surface.w, surface.h)
  # Render
  discard renderer.copy(texture, nil, addr destRect)


# window control

proc getWindowTitle*(ew: EclipseWindow): string =
  if ew.window.isNone:
    logEclipse "Cannot get window title: window is none"
    return ""
  let window = ew.window.get()
  result = $window.getTitle()

proc setWindowTitle*(ew: EclipseWindow, title: string): void =
  if ew.window.isNone:
    logEclipse "Cannot set window title: window is none"
    return
  let window = ew.window.get()
  window.setTitle(title.cstring)

proc isWindowFullscreen*(ew: EclipseWindow): bool =
  if ew.window.isNone:
    logEclipse "Cannot get window fullscreen: window is none"
    return false
  let window = ew.window.get()
  let windowFlags = window.getFlags()
  result = (windowFlags and SDL_WINDOW_FULLSCREEN) != 0

proc setWindowFullscreen*(ew: EclipseWindow, fullscreen: bool): void =
  if ew.window.isNone:
    logEclipse "Cannot set window fullscreen: window is none"
    return
  let window = ew.window.get()
  if fullscreen:
    let status = window.setFullscreen(SDL_WINDOW_FULLSCREEN)
    if status != SdlSuccess:
      logEclipse "Failed to set window to fullscreen: " & $getError()
  else:
    let status = window.setFullscreen(0)
    if status != SdlSuccess:
      logEclipse "Failed to set window to windowed: " & $getError()

proc toggleWindowFullscreen*(ew: EclipseWindow): void =
  if ew.window.isNone:
    logEclipse "Cannot toggle window fullscreen: window is none"
    return
  let window = ew.window.get()
  let isFullscreen = ew.isWindowFullscreen()
  if isFullscreen:
    let status = window.setFullscreen(0)
    if status != SdlSuccess:
      logEclipse "Failed to toggle window fullscreen: " & $getError()
  else:
    let status = window.setFullscreen(SDL_WINDOW_FULLSCREEN)
    if status != SdlSuccess:
      logEclipse "Failed to toggle window fullscreen: " & $getError()

proc getWindowSize*(ew: EclipseWindow): Vec2 =
  if ew.window.isNone:
    logEclipse "Cannot get window size: window is none"
    return Vec2(x: 0, y: 0)
  let window = ew.window.get()
  var w, h: cint
  window.getSize(w, h)
  result = Vec2(x: w.float, y: h.float)

proc setWindowSize*(ew: EclipseWindow, width, height: int): void =
  if ew.window.isNone:
    logEclipse "Cannot set window size: window is none"
    return
  let window = ew.window.get()
  window.setSize(width.cint, height.cint)

proc getWindowPosition*(ew: EclipseWindow): Vec2 =
  if ew.window.isNone:
    logEclipse "Cannot get window position: window is none"
    return Vec2(x: 0, y: 0)
  let window = ew.window.get()
  var x, y: cint
  window.getPosition(x, y)
  result = Vec2(x: x.float, y: y.float)

proc setWindowPosition*(ew: EclipseWindow, x, y: int): void =
  if ew.window.isNone:
    logEclipse "Cannot set window position: window is none"
    return
  let window = ew.window.get()
  window.setPosition(x.cint, y.cint)

proc moveWindow*(ew: EclipseWindow, dx, dy: int): void =
  if ew.window.isNone:
    logEclipse "Cannot move window: window is none"
    return
  let window = ew.window.get()
  var x, y: cint
  window.getPosition(x, y)
  window.setPosition(x + dx.cint, y + dy.cint)

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

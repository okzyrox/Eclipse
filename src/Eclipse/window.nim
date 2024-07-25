#-- Eclipse Engine -- 
# Author: ZyroX

## Window

import common

import sdl2

type EclipseWindow* = object
    width: int
    height: int
    title: string
    fullscreen: bool
    flags: seq[cuint]

    sdl_window: WindowPtr
    sdl_renderer: RendererPtr


proc newWindow*(width, height: int, title: string, fullscreen: bool = false, flags: seq[cuint] = @[]): EclipseWindow =
    result.width = width
    result.height = height
    result.title = title
    result.fullscreen = fullscreen
    result.flags = flags

    result.sdl_window = createWindow(
        title, 
        SDL_WINDOWPOS_CENTERED, 
        SDL_WINDOWPOS_CENTERED, 
        width.cint, 
        height.cint, 
        SDL_WINDOW_SHOWN #flags
    )

    sdlFailIf result.sdl_window.isNil: "window could not be created"
    defer: result.sdl_window.destroy()

    result.sdl_renderer = createRenderer(
      result.sdl_window, 
      -1, 
      Renderer_Accelerated or Renderer_PresentVsync or Renderer_TargetTexture
    )

    sdlFailIf result.sdl_renderer.isNil: "renderer could not be created"
    defer: result.sdl_renderer.destroy()

proc get_renderer*(window: EclipseWindow): RendererPtr = window.sdl_renderer

proc present*(window: EclipseWindow) = 
    window.sdl_renderer.setDrawColor(0, 0, 0, 255)
    window.sdl_renderer.clear()
    window.sdl_renderer.present()
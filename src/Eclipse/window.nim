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


proc newWindow*(width, height: int, title: string, fullscreen: bool = false, flags: seq[cuint] = @[]): (EclipseWindow, WindowPtr, RendererPtr) =
    var window: EclipseWindow
    window.width = width
    window.height = height
    window.title = title
    window.fullscreen = fullscreen
    window.flags = flags

    var sdl_window = createWindow(
        title, 
        SDL_WINDOWPOS_CENTERED, 
        SDL_WINDOWPOS_CENTERED, 
        width.cint, 
        height.cint, 
        SDL_WINDOW_SHOWN  #flags
    )
    
    var sdl_renderer = createRenderer(
      sdl_window, 
      -1, 
      Renderer_Accelerated or Renderer_PresentVsync or Renderer_TargetTexture
    )

    sdlFailIf sdl_window.isNil: "window could not be created"
    defer: 
        sdl_window.destroy()
        echo "window could not be created, exiting..."
        #quit(1)

    sdlFailIf sdl_renderer.isNil: "renderer could not be created"
    defer: 
        sdl_renderer.destroy()
        echo "renderer could not be created, exiting..."
        #quit(1)
    
    return (window, sdl_window, sdl_renderer)
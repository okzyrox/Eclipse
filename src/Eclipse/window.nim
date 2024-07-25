#-- Eclipse Engine -- 
# Author: ZyroX

## Window

import common

import sdl2

type EclipseWindow* = object
    width*: int
    height*: int
    title*: string
    fullscreen*: bool
    flags*: seq[cuint]

type WindowRenderer* = object
    sdl2_renderer: RendererPtr

proc newWindow(ew: EclipseWindow): WindowPtr =

    result = createWindow(
        ew.title.cstring, 
        SDL_WINDOWPOS_CENTERED, 
        SDL_WINDOWPOS_CENTERED, 
        ew.width.cint,
        ew.height.cint,
        SDL_WINDOW_SHOWN
    )

proc newEclipseWindow*(title: string, width, height: int, fullscreen: bool, flags: seq[cuint]): (EclipseWindow, WindowPtr) =
    var ew = EclipseWindow(
        width: width,
        height: height,
        title: title,
        fullscreen: fullscreen,
        flags: flags
    )

    result = (ew, newWindow(ew))

proc createWindowRenderer*(win: WindowPtr): WindowRenderer = 
    WindowRenderer(
        sdl2_renderer: createRenderer(win, -1, Renderer_Accelerated)
    )

proc get_renderer*(wr: WindowRenderer): RendererPtr = wr.sdl2_renderer
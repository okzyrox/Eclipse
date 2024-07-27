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
    renderer_size*: Vec2
    base_draw_color: DrawColor
    sdl2_renderer: RendererPtr

proc newWindow(ew: EclipseWindow): WindowPtr =

    result = createWindow(
        ew.title.cstring, 
        SDL_WINDOWPOS_CENTERED, 
        SDL_WINDOWPOS_CENTERED, 
        ew.width.cint,
        ew.height.cint,
        SDL_WINDOW_SHOWN or SDL_WINDOW_RESIZABLE
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
    var size = win.getSize()
    WindowRenderer(
        renderer_size: Vec2(x: size.x.float, y: size.y.float), sdl2_renderer: createRenderer(win, -1, Renderer_Accelerated)
    )

proc get_sdl2_renderer*(wr: WindowRenderer): RendererPtr = wr.sdl2_renderer

proc clear*(wr: WindowRenderer): void =
    var renderer = wr.get_sdl2_renderer()
    var base_color = wr.base_draw_color
    renderer.setDrawColor(base_color.r, base_color.g, base_color.b, base_color.a)
    renderer.clear()

proc present*(wr: WindowRenderer): void = 
    wr.get_sdl2_renderer().present()
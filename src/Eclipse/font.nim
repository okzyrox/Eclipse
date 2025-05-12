#-- Eclipse Engine -- 
# Author: ZyroX

## Font management

import std/[tables, strformat, options, os]
import sdl2
import sdl2/ttf

import ./[common]

type
  FontStyle* = enum
    Normal, Bold, Italic, Underline, Strikethrough

  FontRenderMode* = enum
    Solid,    # Fast, no AA, single color
    Shaded,   # AA'd with background color
    Blended   # HQ + AA with alpha blending

  TextAlign* = enum
    Left, Center, Right

  EclipseFont* = object
    fontPtr*: FontPtr
    id*: string
    path*: string
    size*: int
    outline*: int
    styles*: set[FontStyle]
    renderMode*: FontRenderMode

  # Manages a collection of fonts
  FontManagerObj* = object
    fonts: Table[string, EclipseFont]
    defaultFontId: Option[string]
  
  FontManager* = ref FontManagerObj

proc toSdlStyle(styles: set[FontStyle]): int =
  result = TTF_STYLE_NORMAL
  if Italic in styles: result = result or TTF_STYLE_ITALIC
  if Bold in styles: result = result or TTF_STYLE_BOLD
  if Underline in styles: result = result or TTF_STYLE_UNDERLINE
  if Strikethrough in styles: result = result or TTF_STYLE_STRIKETHROUGH

proc fromSdlStyle(style: int): set[FontStyle] =
  result = {}
  if (style and TTF_STYLE_BOLD) != 0: result.incl(Bold)
  if (style and TTF_STYLE_ITALIC) != 0: result.incl(Italic)
  if (style and TTF_STYLE_UNDERLINE) != 0: result.incl(Underline)
  if (style and TTF_STYLE_STRIKETHROUGH) != 0: result.incl(Strikethrough)

proc newFontManager*(): FontManager =
  if not ttfInit():
    logEclipse "Failed to initialize SDL2-TTF"
    raise newException(SDLException, "Failed to initialize SDL2-TTF: " & $getError())
  
  result = FontManager(
    fonts: initTable[string, EclipseFont](),
    defaultFontId: none(string)
  )

# loading/creation
proc load*(fontManager: FontManager, id, path: string, size: int = 16): EclipseFont =
  if id in fontManager.fonts:
    logEclipse fmt"Font with ID '{id}' already exists"
    return fontManager.fonts[id]
    
  if not fileExists(path):
    logEclipse fmt"Font file not found: {path}"
    raise newException(IOError, fmt"Font file not found: {path}")
  
  let fontPtr = ttf.openFont(path.cstring, size.cint)
  if fontPtr.isNil:
    logEclipse fmt"Failed to load font '{path}': {$getError()}"
    raise newException(SDLException, fmt"Failed to load font: {$getError()}")
    
  result = EclipseFont(
    fontPtr: fontPtr,
    id: id,
    path: path,
    size: size,
    outline: 0,
    styles: {},
    renderMode: Blended
  )
  
  fontManager.fonts[id] = result
  
  # first font loaded, make it the default
  if fontManager.defaultFontId.isNone:
    fontManager.defaultFontId = some(id)
    
  logEclipse fmt"Font '{id}' loaded successfully from {path}"

proc setDefaultFont*(fontManager: FontManager, id: string) =
  if id in fontManager.fonts:
    fontManager.defaultFontId = some(id)
  else:
    logEclipse fmt"Cannot set default font to '{id}' - font not found"

proc getDefaultFont*(fontManager: FontManager): EclipseFont =
  if fontManager.defaultFontId.isSome:
    result = some(fontManager.fonts[fontManager.defaultFontId.get]).get()
  else:
    logEclipse "No default font set"
    raise newException(ValueError, "No default font set")

proc get*(fontManager: FontManager, id: string): EclipseFont =
  if id in fontManager.fonts:
    result = some(fontManager.fonts[id]).get()
  else:
    logEclipse fmt"Font with ID '{id}' not found"
    raise newException(ValueError, fmt"Font with ID '{id}' not found")

proc exists*(fontManager: FontManager, id: string): bool =
  result = id in fontManager.fonts

# setters
proc setStyle*(font: var EclipseFont, styles: set[FontStyle]): EclipseFont {.discardable.} =
  font.styles = styles
  font.fontPtr.setFontStyle(toSdlStyle(styles).cint)
  return font

proc setOutline*(font: var EclipseFont, outline: int): EclipseFont {.discardable.} =
  font.outline = outline
  font.fontPtr.setFontOutline(outline.cint)
  return font

proc setRenderMode*(font: var EclipseFont, mode: FontRenderMode): EclipseFont {.discardable.} =
  font.renderMode = mode
  return font

# rendering
proc renderText*(font: EclipseFont, text: string, color: DrawColor, bgColor: DrawColor = DrawColor(r: 0, g: 0, b: 0, a: 255)): SurfacePtr =
  if font.fontPtr.isNil:
    logEclipse "Cannot render text: font is nil"
    raise newException(ValueError, "Font is nil")
    
  let sdlColor = color(color.r, color.g, color.b, color.a)
  let sdlBgColor = color(bgColor.r, bgColor.g, bgColor.b, bgColor.a)
  
  case font.renderMode:
    of Solid:
      result = font.fontPtr.renderUtf8Solid(text.cstring, sdlColor)
    of Shaded:
      result = font.fontPtr.renderUtf8Shaded(text.cstring, sdlColor, sdlBgColor)
    of Blended:
      result = font.fontPtr.renderUtf8Blended(text.cstring, sdlColor)
  
  if result.isNil:
    logEclipse fmt"Failed to render text surface: {$getError()}"
    raise newException(SDLException, fmt"Failed to render text: {$getError()}")

# data
proc getTextSize*(font: EclipseFont, text: string): tuple[width, height: int] =
  var w, h: cint
  if ttf.sizeUtf8(font.fontPtr, text.cstring, addr w, addr h) != 0:
    logEclipse fmt"Failed to get text size: {$getError()}"
    return (0, 0)
  return (w.int, h.int)

proc getLineHeight*(font: EclipseFont): int =
  return font.fontPtr.fontLineSkip().int

proc getAscent*(font: EclipseFont): int =
  return font.fontPtr.fontAscent().int

proc getDescent*(font: EclipseFont): int =
  return font.fontPtr.fontDescent().int



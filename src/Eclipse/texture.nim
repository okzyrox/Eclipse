#-- Eclipse Engine -- 
# Author: ZyroX

## Texture and TextureManager

import std/[tables]

import sdl2

import ./[common]

type 
  EclipseTexture* = object 
    texturePtr*: TexturePtr
    path*: string
    width*: int
    height*: int
    color*: DrawColor
  TextureManager* = object
    textures*: Table[string, EclipseTexture]

proc setTextureColor*(texture: var EclipseTexture, color: DrawColor) =
  texture.color = color
  if texture.texturePtr != nil:
    discard texture.texturePtr.setTextureColorMod(color.r, color.g, color.b)
    discard texture.texturePtr.setTextureAlphaMod(color.a)

proc setTextureBlendMode*(texture: var EclipseTexture, blendMode: BlendMode) =
  if texture.texturePtr != nil:
    discard texture.texturePtr.setTextureBlendMode(blendMode)

proc destroy*(texture: var EclipseTexture) =
  if texture.texturePtr != nil:
    texture.texturePtr.destroy()
    texture.texturePtr = nil

proc newTextureManager*(): TextureManager =
  result = TextureManager(
    textures: initTable[string, EclipseTexture]()
  )
  
proc getTexture*(tm: TextureManager, id: string): EclipseTexture =
  if tm.textures.contains(id):
    result = tm.textures[id]
  else:
    logEclipse "Texture not found with id: " & id
    quit(1)
  
proc hasTexture*(tm: TextureManager, id: string): bool =
  result = tm.textures.contains(id)

proc addTexture*(tm: var TextureManager, eclTex: EclipseTexture, id: string) =
  if tm.hasTexture(id):
    logEclipse "Texture already exists with id: " & id
    quit(1)
  else:
    tm.textures[id] = eclTex

proc unloadTexture*(tm: var TextureManager, id: string) =
  if tm.hasTexture(id):
    tm.textures[id].destroy()
  
proc clearTextures*(tm: var TextureManager) =
  for id in tm.textures.keys:
    tm.unloadTexture(id)
  tm.textures.clear()
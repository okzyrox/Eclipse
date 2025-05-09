# i cant tell if im going insane or if sdl is just NOT working
# this literally has NOTHING
# only creates a window, and it shows
# but when i do it no no no no no no no no
# augh i hate this
import sdl2

discard sdl2.init(INIT_EVERYTHING)

var window: WindowPtr

window = createWindow("SDL Skeleton", 100, 100, 640,480, SDL_WINDOW_SHOWN)

var
  evt = sdl2.defaultEvent
  runGame = true

while runGame:
  while pollEvent(evt):
    if evt.kind == QuitEvent:
      runGame = false
      break


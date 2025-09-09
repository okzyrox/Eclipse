#-- Eclipse Engine -- 
# Author: ZyroX

## Input threading


import std/[threadpool, times, locks, os]
import ./[inputs]

# type
#   Game = object # forward decl
#     resizeRequested*: bool

var inputThreadRunning* = true

proc inputThreadProc*(game: ptr, inputManager: ptr InputManager, pollRate: int) {.thread.} =
  let sleepMs = 1000 div pollRate
  while inputThreadRunning:
    inputManager[].lock.acquire()
    let evt = updateInputs(inputManager[])
    inputManager[].lock.release()
    if evt == WindowResize:
      game[].resizeRequested = true
    sleep(sleepMs)
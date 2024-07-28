#-- Eclipse Engine -- 
# Author: ZyroX

## Events

import std/[tables, sequtils]

import sdl2

import common

type
  GameEvent* = ref object of RootObj
    listeners*: Table[int, EventListener]

  EventListener* = ref object of RootObj
    canFire*: bool
    event*: GameEvent
    procedure*: proc(ge: GameEvent)

## Permanent listeners
proc addListener*(event: GameEvent, listener: EventListener) =
    event.listeners[event.listeners.len] = listener

proc addListener*(event: GameEvent, procedure: proc(ge: GameEvent)) =
    event.listeners[event.listeners.len] = EventListener(canFire: true, event: event, procedure: procedure)

proc addListener*[T: bool | int | float | string](event: GameEvent, procedure: proc(ge: GameEvent): T) =
    event.listeners[event.listeners.len] = EventListener(canFire: true, event: event, procedure: procedure)

proc removeListener*(event: GameEvent, listener: EventListener) =
    event.listeners[event.listeners.find(listener)] = nil

proc deactivateListener*(event: GameEvent, listener: EventListener) =
    listener.canFire = false

proc activateListener*(event: GameEvent, listener: EventListener) =
    listener.canFire = true

## Once listener (fires once, then removes the listener)
## We kinda cheat this buy adding two listeners:
## - 1 for the main listener ('s)
## - 1 for the destroy listener (which deactivates the main listener)
proc addOnceListener*(event: GameEvent, listener: EventListener) =
    event.addListener(listener)
    event.addListener(EventListener(event: event, procedure: (proc(ge: GameEvent) = deactivateListener(event, listener))))

proc addOnceListener*(event: GameEvent, procedure: proc(ge: GameEvent)) =
    var listener = EventListener(event: event, procedure: procedure)
    event.addListener(listener)
    event.addListener(EventListener(event: event, procedure: (proc(ge: GameEvent) = deactivateListener(event, listener))))

proc addOnceListener*[T: bool | int | float | string](event: GameEvent, procedure: proc(ge: GameEvent): T) =
    var listener = EventListener(event: event, procedure: procedure)
    event.addListener(listener)
    event.addListener(EventListener(event: event, procedure: (proc(ge: GameEvent) = deactivateListener(event, listener))))

proc fireEvent*(event: GameEvent) =
  for id, listener in event.listeners:
    if listener.canFire:
        listener.procedure(event)

proc newEvent*(): GameEvent = 
    GameEvent()
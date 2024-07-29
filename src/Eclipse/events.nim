#-- Eclipse Engine -- 
# Author: ZyroX

## Events

import std/[tables, sequtils]

import sdl2

import common

type
  GameEvent* = ref object of RootObj
    connections*: Table[string, EventConnection]

  EventConnection* = ref object of RootObj
    canFire*: bool
    once*: bool
    event*: GameEvent
    procedure*: proc(ge: GameEvent): void

## Permanent listeners
proc Connect*(event: GameEvent, id: string, connection: EventConnection) =
    assert not event.connections.hasKey(id), "Connection with that id already exists (id: " & id & ")"
    event.connections[id] = connection

proc Connect*(event: GameEvent, id: string, procedure: proc(ge: GameEvent)) =
    assert not event.connections.hasKey(id), "Connection with that id already exists (id: " & id & ")"
    event.connections[id] = EventConnection(canFire: true, event: event, procedure: procedure)

proc Connect*[T](event: GameEvent, id: string, procedure: proc(ge: GameEvent): T) =
    assert not event.connections.hasKey(id), "Connection with that id already exists (id: " & id & ")"
    event.connections[id] = EventConnection(canFire: true, event: event, procedure: procedure)

proc Remove*(event: GameEvent, id: string) =
    assert not event.connections.hasKey(id), "Connection with that id already exists (id: " & id & ")"
    event.connections[id] = nil

proc Remove*(event: GameEvent, connection: EventConnection) =
    ## seems slow
    for id, c in event.connections:
        if c == connection:
            event.connections[id] = nil

proc Deactivate*(event: GameEvent, connection: EventConnection) =
    connection.canFire = false

proc Deactivate*(event: GameEvent, id: string) =
    assert not event.connections.hasKey(id), "Connection with that id already exists (id: " & id & ")"
    event.connections[id].canFire = false

proc Activate*(event: GameEvent, connection: EventConnection) =
    connection.canFire = true

## Once connection (fires once, then removes the listener)
## We kinda cheat this buy adding two listeners:
## - 1 for the main listener ('s)
## - 1 for the destroy listener (which deactivates the main listener)
proc Once*(event: GameEvent, id: string, connection: EventConnection) =
    assert not event.connections.hasKey(id), "Connection with that id already exists (id: " & id & ")"
    connection.canFire = true
    connection.once = true
    event.Connect(id, connection)

proc Once*(event: GameEvent, id: string, procedure: proc(ge: GameEvent)) =
    assert not event.connections.hasKey(id), "Connection with that id already exists (id: " & id & ")"
    var connection = EventConnection(event: event, canFire: true, once: true, procedure: procedure)
    event.Connect(id, connection)

proc Once*[T](event: GameEvent, id: string, procedure: proc(ge: GameEvent): T) =
    assert not event.connections.hasKey(id), "Connection with that id already exists (id: " & id & ")"
    var connection = EventConnection(event: event, canFire: true, once: true, procedure: procedure)
    event.Connect(id, connection)

proc FireAll*(event: GameEvent) =
    for id, connection in event.connections:
        if connection.canFire:
            connection.procedure(event)
            if connection.once:
                connection.canFire = false # requires manual cleanp

    
proc Fire*(event: GameEvent, id: string) =
    assert not event.connections.hasKey(id), "Connection with that id already exists (id: " & id & ")"
    var connection = event.connections[id]
    connection.procedure(event)
    if connection.once:
        event.connections[id] = nil

proc newEvent*(): GameEvent = 
    GameEvent()
#-- Eclipse Engine -- 
# Author: ZyroX

## Events

import std/[tables]

type
  GameEvent* = ref object of RootObj
    connections*: Table[string, EventConnection] # todo: remove id system?, kinda useless over just a seq

  EventConnection* = ref object of RootObj
    canFire*: bool
    once*: bool
    event*: GameEvent
    procedure*: proc(ge: GameEvent): void

## Permanent listeners
proc connect*(event: GameEvent, id: string, connection: EventConnection) =
    assert not event.connections.hasKey(id),
        "Connection with that id already exists (id: " & id & ")"
    event.connections[id] = connection

proc connect*(event: GameEvent, id: string, procedure: proc(ge: GameEvent)) =
  assert not event.connections.hasKey(id),
      "Connection with that id already exists (id: " & id & ")"
  event.connections[id] = EventConnection(canFire: true, event: event,
      procedure: procedure)

proc connect*[T](event: GameEvent, id: string, procedure: proc(
    ge: GameEvent): T) =
  assert not event.connections.hasKey(id),
      "Connection with that id already exists (id: " & id & ")"
  event.connections[id] = EventConnection(canFire: true, event: event,
      procedure: procedure)

proc remove*(event: GameEvent, id: string) =
  assert not event.connections.hasKey(id),
      "Connection with that id already exists (id: " & id & ")"
  event.connections[id] = nil

proc remove*(event: GameEvent, connection: EventConnection) =
  ## seems slow
  for id, c in event.connections:
    if c == connection:
      event.connections[id] = nil

proc deactivate*(event: GameEvent, connection: EventConnection) =
  connection.canFire = false

proc deactivate*(event: GameEvent, id: string) =
  assert not event.connections.hasKey(id),
      "Connection with that id already exists (id: " & id & ")"
  event.connections[id].canFire = false

proc activate*(event: GameEvent, connection: EventConnection) =
  connection.canFire = true

## Once connection (fires once, then removes the listener)
## We kinda cheat this buy adding two listeners:
## - 1 for the main listener ('s)
## - 1 for the destroy listener (which deactivates the main listener)
proc once*(event: GameEvent, id: string, connection: EventConnection) =
  assert not event.connections.hasKey(id),
      "Connection with that id already exists (id: " & id & ")"
  connection.canFire = true
  connection.once = true
  event.connect(id, connection)

proc once*(event: GameEvent, id: string, procedure: proc(ge: GameEvent)) =
  assert not event.connections.hasKey(id),
      "Connection with that id already exists (id: " & id & ")"
  var connection = EventConnection(event: event, canFire: true, once: true,
      procedure: procedure)
  event.connect(id, connection)

proc once*[T](event: GameEvent, id: string, procedure: proc(ge: GameEvent): T) =
  assert not event.connections.hasKey(id),
      "Connection with that id already exists (id: " & id & ")"
  var connection = EventConnection(event: event, canFire: true, once: true,
      procedure: procedure)
  event.connect(id, connection)

proc fireAll*(event: GameEvent) =
  for id, connection in event.connections:
    if connection.canFire:
      connection.procedure(event)
      if connection.once:
        connection.canFire = false # requires manual cleanp


proc fire*(event: GameEvent, id: string) =
  assert not event.connections.hasKey(id),
      "Connection with that id already exists (id: " & id & ")"
  var connection = event.connections[id]
  connection.procedure(event)
  if connection.once:
    event.connections[id] = nil

proc newEvent*(): GameEvent =
  GameEvent()

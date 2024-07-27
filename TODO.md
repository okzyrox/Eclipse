# A more complete TODO list

- [x] Fix examples (non working atm)
- [ ] Check for closing window actions (Event????)
- [ ] More features:
    - [ ] Better global UI
    - [ ] Inputs, keymapping, etc
    - [ ] Data saving and loading
    - [ ] Popup windows
    - [ ] Images, loading tilemaps, loading animated sprites, etc
    - [ ] Loading videos, gifs, etc
    - [ ] Built in physics engine (for entitys)
    - [ ] SolidParts (entity that does not move, collides with other entities, canot be moved: aka a wall)
    - [ ] Properties
- [ ] Register input better:
    - [ ] Maybe make seperate functions for detecting input types, like press, hold, release, etc.
- [ ] Make more examples for the features:
    - [ ] UI
    - [ ] Scenes, Scene switching, scene management
    - [ ] Games and Game Management
    - [ ] Entities (creation, deletion), assignment of script components, etc
- [ ] Add more components: audio, sprites, scripting (for entities), etc
- [ ] Loading data from a `assets` folder (fonts, images, gifs, videos, spritemaps, etc)
- [ ] Displaying text on screen (through loading a font, and maybe making some sort of UI component)


# Ideas


## Events

Events are features that are both used by the engine, and also can be created and used by the developer.

An event simply refers to an object which tells other s when it is `Fired`, or `Activated`

```nim

type BaseEvent = object #???

type Event = object
    id: string

    activators: seq[BaseEvent]
    connections: seq[proc]

```

An idea could be:
```nim

type Player = ref object of Entity = 
    username: string

# This event serves to tell the main event when it should run its code
type PlayerCreated = ref object of Event

# This event encapsulates what we want it to do
Type PlayerJoinEvent = ref object of Event
    player: Player

proc newPlayer(username: string) =
    PlayerCreated.Fire() # Fire the event (calls connections)
    Player(username)

proc playerJoined(p: Player) =
    echo p.username & " joined"

PlayerJoinEvent.Activated(PlayerCreated)
PlayerJoinEvent.Connect(playerJoined) # fields are passed over to proc

var player1 = newPlayer("Player 1")

# >>> Player 1 joined
```

Events could also be disconnected, and an event can have as many connections as it needs.

Events can be manually fired too if they dont have any parameters that are sent by an `Activation`

```nim

PlayerJoinEvent.Disconnect(playerJoined)
var player2 = newPlayer("Player 2")
# >>> <empty, no connection able to be called>

```

Or the other way around..:

```nim

PlayerJoinEvent.Deactivate(PlayerCreated)
var player3 = newPlayer("Player 3")
# >>> <empty, connection not called as event was not fired>

```

```nim

type GameStartedEvent = ref object of Event

proc gameStarted() =
    echo "The game has started!!"

GameStartedEvent.Connect(gameStarted)

# .... game code omitted

if game.started:
    GameStartedEvent.Fire()
    GameStartedEvent.Disconnect() # Cleanup the event

# >>> "The Game has started!!

```

this is purely hypothetical, i dont even know if i can implement this but we'll see
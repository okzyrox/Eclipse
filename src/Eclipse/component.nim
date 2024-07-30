#-- Eclipse Engine -- 
# Author: ZyroX

## Components
## Components are attached to Scenes, Entitys and other things and run when the component parent is updated

import common

type 
    ComponentProc* = proc(component: Component)
    Component* = object
        id*: string
        enabled*: bool

        update*: ComponentProc

proc newComponent*(id: string): Component =
    Component(id: id, enabled: true)

proc newScriptComponent*(id: string, update: ComponentProc): Component =
    Component(id: id, enabled: true, update: update)

proc newScript*(id: string): Component =
    Component(id: id, enabled: true)

proc newScript*(id: string, update: ComponentProc): Component =
    Component(id: id, enabled: true, update: update)

proc update*(component: Component) =
    if component.update != nil and component.enabled:
        component.update(component)
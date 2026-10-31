--- @class EventListener
EventListener = Class(EventListener)

--- @return void
--- @param hero BaseHero
--- @param owner table owner of listener method
--- @param listenerMethod function listener method
function EventListener:Ctor(hero, owner, listenerMethod)
    --- @type BaseHero
    self.myHero = hero

    --- @type table
    self.owner = owner

    --- @type function
    self.listenerMethod = listenerMethod
end

--- @return void
--- @param eventData table
function EventListener:Trigger(eventData)
    self.listenerMethod(self.owner, eventData)
end
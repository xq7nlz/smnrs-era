--- @class EventDispatcherListener
EventDispatcherListener = Class(EventDispatcherListener)

--- @return void
--- @param owner table owner of listener method
--- @param listenerMethod function listener method
function EventDispatcherListener:Ctor(owner, listenerMethod)
  assert(listenerMethod)
    --- @type table
    self.owner = owner

    --- @type function
    self.listenerMethod = listenerMethod
end

--- @return void
--- @param eventData table
function EventDispatcherListener:Trigger(eventData)
    if self.owner ~= nil then
        self.listenerMethod(self.owner, eventData)
    else
        self.listenerMethod(eventData)
    end
end
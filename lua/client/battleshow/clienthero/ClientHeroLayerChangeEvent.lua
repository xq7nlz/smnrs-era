--- @class ClientHeroLayerChangeEvent
ClientHeroLayerChangeEvent = Class(ClientHeroLayerChangeEvent)

--- @param owner lua object that listen to event
--- @param method function triggerd by event
function ClientHeroLayerChangeEvent:Ctor(owner, method)
    if owner == nil or method == nil then
        assert(false, string.format("owner %s, method %s", owner, method))
    end

    self.owner = owner
    self.method = method
end

--- @param eventData table
function ClientHeroLayerChangeEvent:Trigger(eventData)
    self.method(self.owner, eventData)
end

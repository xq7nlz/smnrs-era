require "lua.client.core.network.event.EventData"

--- @class EventExchangeData : EventData
EventExchangeData = Class(EventExchangeData, EventData)

function EventExchangeData:Ctor()
    --- @type Dictionary
    self.numberExchangeDict = Dictionary
    EventData.Ctor(self)
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventExchangeData:FillData(buffer)
    local size = buffer:GetByte()
    self.numberExchangeDict:Clear()
    for _ = 1, size do
        self.numberExchangeDict:Add(buffer:GetInt(), buffer:GetInt())
    end
end
--- @class EventIdleTimeData
EventIdleTimeData = Class(EventIdleTimeData)

function EventIdleTimeData:Ctor()
    self.claimIdleTimeMap = Dictionary()
end
--- @param buffer UnifiedNetwork_ByteBuf
function EventIdleTimeData:ReadBuffer(buffer)
    self.size = buffer:GetByte()
    for i = 1, self.size do
        --- @type EventActionType
        local id = buffer:GetInt()
        local value = buffer:GetLong()
        self.claimIdleTimeMap:Add(id, value)
    end
end

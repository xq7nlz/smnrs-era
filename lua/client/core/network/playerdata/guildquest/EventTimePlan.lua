
--- @class EventTimePlan
EventTimePlan = Class(EventTimePlan)
EventTimePlan.flag = 0

--- @return void
function EventTimePlan:Ctor()
    --- @type EventTimeType
    self.eventType = nil
    --- @type number
    self.startTime = nil
    --- @type number
    self.endTime = nil
    --- @type number
    self.dataId = nil
    --- @type number
    self.season = nil
end

--- @return EventTimePlan
--- @param buffer UnifiedNetwork_ByteBuf
function EventTimePlan.CreateByBuffer(buffer)
    local data = EventTimePlan()
    data.startTime = buffer:GetLong()
    data.endTime = buffer:GetLong()
    data.dataId = buffer:GetShort()
    data.season = buffer:GetLong()
    return data
end
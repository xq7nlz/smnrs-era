
--- @class EventTimeData
EventTimeData = Class(EventTimeData)
EventTimeData.flag = 0

--- @return void
function EventTimeData:Ctor()
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

--- @return boolean
function EventTimeData:IsOpening()
    local serverTime = zg.timeMgr:GetServerTime()
    return self.startTime <= serverTime and self.endTime >= serverTime
end

--- @return EventTimeData
--- @param buffer UnifiedNetwork_ByteBuf
function EventTimeData.CreateByBuffer(buffer)
    local data = EventTimeData()
    --- @type EventTimeType
    data.eventType = buffer:GetShort()
    data.startTime = buffer:GetLong()
    data.endTime = buffer:GetLong()
    data.dataId = buffer:GetShort()
    data.season = buffer:GetLong()
    --if EventTimeType.IsEventPopup(data.eventType) and EventTimeData.flag == 0 then
    --    data.startTime = data.startTime - TimeUtils.SecondAHour
    --    data.endTime = data.endTime - TimeUtils.SecondAHour + TimeUtils.SecondAMin * 19
    --end
    return data
end
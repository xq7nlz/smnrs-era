--- @class EventRateUpModel : EventPopupModel
EventRateUpModel = Class(EventRateUpModel, EventPopupModel)

--- @param buffer UnifiedNetwork_ByteBuf
function EventRateUpModel:ReadData(buffer)
    EventPopupModel.ReadData(self, buffer)
    self.numberSummon = buffer:GetInt()
end

--- @return boolean
function EventRateUpModel:IsNotifySummon()
    local time = zg.playerData.remoteConfig.lastTimeOpenRateUp
    return time == nil or self.timeData.startTime > time
end

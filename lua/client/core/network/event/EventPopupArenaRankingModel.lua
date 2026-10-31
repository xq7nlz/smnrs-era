--- @class EventPopupArenaRankingModel : EventPopupModel
EventPopupArenaRankingModel = Class(EventPopupArenaRankingModel, EventPopupModel)

function EventPopupArenaRankingModel:Ctor()
    EventPopupModel.Ctor(self)
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventPopupArenaRankingModel:ReadInnerData(buffer)
    self.isClaim = buffer:GetBool()
    self.arenaSeason = buffer:GetLong()
    --- @type RewardState
    self.rewardState = buffer:GetByte()
    self.playerPoint = buffer:GetInt()
end

function EventPopupArenaRankingModel:HasNotification()
    local eventInBound = zg.playerData:GetEvents()
    if eventInBound ~= nil then
        local eventArena = eventInBound:GetEvent(EventTimeType.ARENA)
        return self.isClaim == false
                and self.arenaSeason ~= eventArena.timeData.season
                and self.rewardState ~= RewardState.NOT_AVAILABLE_TO_CLAIM
    end
    return false
end

--- @return EventArenaRankingConfig
function EventPopupArenaRankingModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end
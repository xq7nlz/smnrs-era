--- @class EventNewHeroSummonModel : EventPopupModel
EventNewHeroSummonModel = Class(EventNewHeroSummonModel, EventPopupModel)

function EventNewHeroSummonModel:Ctor()
    --- @type number
    self.numberSummon = 0
    --- @type number
    self.lastFreeSummon = 0
    EventPopupModel.Ctor(self)
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventNewHeroSummonModel:ReadInnerData(buffer)
    self.numberSummon = buffer:GetInt()
    self.lastFreeSummon = buffer:GetLong()
end

--- @return number
--- @param summonType SummonType
function EventNewHeroSummonModel:GetTimeFreeSummon()
    local serverTime = TimeUtils.GetTimeEndDayFromSec(zg.timeMgr:GetServerTime())
    return serverTime - zg.timeMgr:GetServerTime() + 1
end

--- @return number
function EventNewHeroSummonModel:IsAvailableFreeSummon()
    local serverTime = zg.timeMgr:GetServerTime()
    return self.lastFreeSummon - TimeUtils.GetTimeStartDayFromSec(serverTime) < 0
end

function EventNewHeroSummonModel:HasNotification()
    return self:IsAvailableFreeSummon()
end
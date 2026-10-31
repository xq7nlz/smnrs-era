--- @class EventNewHeroRateUpModel : EventPopupModel
EventNewHeroRateUpModel = Class(EventNewHeroRateUpModel, EventPopupModel)

function EventNewHeroRateUpModel:Ctor()
    --- @type number
    self.numberSummon = 0
    --- @type number
    self.lastFreeSummon = 0
    EventPopupModel.Ctor(self)
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventNewHeroRateUpModel:ReadInnerData(buffer)
    self.numberSummon = buffer:GetInt()
    self.lastFreeSummon = buffer:GetLong()
end


--- @return number
--- @param summonType SummonType
function EventNewHeroRateUpModel:GetTimeFreeSummon()
    local serverTime = TimeUtils.GetTimeEndDayFromSec(zg.timeMgr:GetServerTime())
    return serverTime - zg.timeMgr:GetServerTime() + 1
end

--- @return number
--- @param summonType SummonType
function EventNewHeroRateUpModel:IsAvailableFreeSummon()
    local serverTime = zg.timeMgr:GetServerTime()
    return self.lastFreeSummon - TimeUtils.GetTimeStartDayFromSec(serverTime) < 0
end

function EventNewHeroRateUpModel:HasNotification()
    return self:IsAvailableFreeSummon()
end
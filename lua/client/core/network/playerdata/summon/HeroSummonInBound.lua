--- @class HeroSummonInBound
HeroSummonInBound = Class(HeroSummonInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function HeroSummonInBound:ReadBuffer(buffer)
    self.sizeOfLastFreeSummon = buffer:GetByte()
    self.csv = ResourceMgr.GetHeroSummonConfig()

    self.summonLastFreeDict = Dictionary()
    for _ = 1, self.sizeOfLastFreeSummon do
        local summonType = buffer:GetByte()
        local lastFreeSummonTime = buffer:GetLong()
        self.summonLastFreeDict:Add(summonType, lastFreeSummonTime)
    end

    self.sizeOfWatchedAdsDict = buffer:GetByte()
    self.summonWatchedAdsDict = Dictionary()
    for _ = 1, self.sizeOfWatchedAdsDict do
        local summonType = buffer:GetByte()
        local amountAds = buffer:GetInt()
        self.summonWatchedAdsDict:Add(summonType, amountAds)
    end
    self.firstTopUpDataId = buffer:GetInt()
end

--- @return number
--- @param summonType SummonType
function HeroSummonInBound:GetLastTimeFreeSummon(summonType)
    return self.summonLastFreeDict:Get(summonType)
end

--- @return number
function HeroSummonInBound:GetTimeFreeSummon()
    local serverTime = TimeUtils.GetTimeEndDayFromSec(zg.timeMgr:GetServerTime())
    return serverTime - zg.timeMgr:GetServerTime() + 1
end

--- @return void
--- @param summonType SummonType
--- @param time number
function HeroSummonInBound:SetTimeFreeSummon(summonType, time)
    self.summonLastFreeDict:Add(summonType, time)
end

--- @return number
--- @param summonType SummonType
function HeroSummonInBound:IsAvailableFreeSummon(summonType)
    local serverTime = zg.timeMgr:GetServerTime()
    return self:GetLastTimeFreeSummon(summonType) - TimeUtils.GetTimeStartDayFromSec(serverTime) < 0
end

--- @return number
--- @param summonType SummonType
function HeroSummonInBound:IsAvailableAdsSummon(summonType)
    local csv = ResourceMgr.GetHeroSummonConfig()
    return (csv:GetAdsLimit(summonType) - self.summonWatchedAdsDict:GetOrDefault(summonType, 0)) > 0
end

--- @return void
function HeroSummonInBound:ToString()
    local str = ""
    str = str .. "last: " .. self.summonLastFreeDict:ToString()
    return str
end

--- @return number
function HeroSummonInBound:GetFirstTopUpDataId()
    return self.firstTopUpDataId
end
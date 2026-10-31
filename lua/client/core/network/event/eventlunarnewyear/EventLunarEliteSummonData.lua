--- @class EventLunarEliteSummonData
EventLunarEliteSummonData = Class(EventLunarEliteSummonData)

function EventLunarEliteSummonData:Ctor(buffer)
    if buffer then
        self:ReadBuffer(buffer)
    end
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventLunarEliteSummonData:ReadBuffer(buffer)
    self.wishId = buffer:GetShort()
    self.numberSummonByGem = buffer:GetInt()
    self.lastSummonFree = buffer:GetLong()
    self.lastResetSummonByGem = buffer:GetLong()

    local startTimeOfDay = TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime())
    if startTimeOfDay > self.lastResetSummonByGem then
        self.numberSummonByGem = 0
        self.lastResetSummonByGem = startTimeOfDay + TimeUtils.SecondADay - 1
    end
end

function EventLunarEliteSummonData:RequestSelectWish(wishId, onSuccessCallback)
    local onReceived = function(result)
        local onSuccess = function()
            self.wishId = wishId
            if onSuccessCallback then
                onSuccessCallback()
            end
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, SmartPoolUtils.LogicCodeNotification)
    end
    NetworkUtils.Request(OpCode.EVENT_LUNAR_ELITE_WISH_SELECT,
            UnknownOutBound.CreateInstance(PutMethod.Short, wishId), onReceived)
end

function EventLunarEliteSummonData:RequestSummon(priceId, onSuccessCallback)
    local onReceived = function(result)
        local rewardList
        local lunarSummonPoint
        local onBufferReading = function(buffer)
            rewardList = NetworkUtils.GetRewardInBoundList(buffer)
            lunarSummonPoint = buffer:GetLong()
        end
        local onSuccess = function()
            if onSuccessCallback then
                onSuccessCallback(rewardList, lunarSummonPoint)
            end
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
    end
    NetworkUtils.Request(OpCode.EVENT_LUNAR_ELITE_SUMMON,
            UnknownOutBound.CreateInstance(PutMethod.Short, priceId), onReceived)
end

--- @return boolean
function EventLunarEliteSummonData:HasNotification()
    if self:IsFreeSummonAvailable() then
        return true
    end
    return InventoryUtils.Get(ResourceType.Money, MoneyType.SUMMON_ELITE_SCROLL) > 0
end

function EventLunarEliteSummonData:IsFreeSummonAvailable()
    return zg.timeMgr:GetServerTime() >= self.lastSummonFree + TimeUtils.SecondADay
end

--- @class EventBlackFridayModel : EventPopupModel
EventBlackFridayModel = Class(EventBlackFridayModel, EventPopupModel)

function EventBlackFridayModel:Ctor()
    --- @type Dictionary
    self.numberBuyDataDict = Dictionary()
    EventPopupModel.Ctor(self)

end

function EventBlackFridayModel:HasNotification()
    local hasDailyNoti =self:HasDailyDoneNotClaimed()
    return hasDailyNoti
end

--- @param blackFridayTab BlackFridayTab
function EventBlackFridayModel:IsTabNotified(blackFridayTab)
    if (blackFridayTab == BlackFridayTab.DAILY_CHECK_IN) then
        return self:HasDailyDoneNotClaimed()
    end
    return false
end

function EventBlackFridayModel:HasDailyDoneNotClaimed()
    return not self.eventLoginData:IsFreeClaim()
end
function EventBlackFridayModel:ReadInnerData(buffer)
    self.numberBuyDataDict = Dictionary()
    local size = buffer:GetByte()
    for i = 1, size do
        --- @type EventActionType
        local eventActionType = buffer:GetByte()
        local numberBuyData = NumberBuyData()
        numberBuyData:ReadBuffer(buffer)
        self.numberBuyDataDict:Add(eventActionType, numberBuyData)
    end
    --- @type EventLoginData
    self.eventLoginData = EventLoginData(buffer)
end
function EventBlackFridayModel:ReadData(buffer)
    EventPopupModel.ReadData(self, buffer)
    self:ReadSubscriptionPack(buffer)
end
--- @param buffer UnifiedNetwork_ByteBuf
---
function EventBlackFridayModel:ReadSubscriptionPack(buffer)
    --- @param buffer UnifiedNetwork_ByteBuf
    --- @param durationDict Dictionary
    local readDuration = function(buffer, durationDict)
        --- @type number
        local durationSize = buffer:GetShort()
        for _ = 1, durationSize do
            local packId = buffer:GetInt()
            local packDurationInDays = buffer:GetInt()
            durationDict:Add(packId, packDurationInDays)
        end
    end

    self.subscriptionDurationDict = Dictionary()
    readDuration(buffer, self.subscriptionDurationDict)
    self.subscriptionTrialDurationDict = Dictionary()
    readDuration(buffer, self.subscriptionTrialDurationDict)

    local subscriptionTrialAvailableSize = buffer:GetShort()
    self.subscriptionTrialAvailabilityDict = Dictionary()
    for _ = 1, subscriptionTrialAvailableSize do
        local packId = buffer:GetInt()
        local isAvailableToTrial = buffer:GetBool()
        self.subscriptionTrialAvailabilityDict:Add(packId, isAvailableToTrial)
    end
end

function EventBlackFridayModel:_GetNumberBuyData(eventActionType)
    ---@type NumberBuyData
    local numberBuyData = self.numberBuyDataDict:Get(eventActionType)
    if numberBuyData == nil then
        numberBuyData = NumberBuyData()
        self.numberBuyDataDict:Add(eventActionType, numberBuyData)
    end
    return numberBuyData
end

function EventBlackFridayModel:GetNumberBuy(eventActionType, id)
    ---@type NumberBuyData
    local numberBuyData = self:_GetNumberBuyData(eventActionType)
    return numberBuyData.buyStatsDict:Get(id) or 0
end

function EventBlackFridayModel:AddNumberBuy(eventActionType, id, number)
    ---@type NumberBuyData
    local numberBuyData = self:_GetNumberBuyData(eventActionType)
    local current = numberBuyData.buyStatsDict:Get(id) or 0
    numberBuyData.buyStatsDict:Add(id, current + number)
end

--- @return EventHalloweenConfig
function EventBlackFridayModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end

function EventBlackFridayModel:IsAutoShow()
    local lastTimeShow = zg.playerData.remoteConfig.lastTimeShowBlackFriday
    local saveTime = function()
        zg.playerData.remoteConfig.lastTimeShowBlackFriday = zg.timeMgr:GetServerTime()
        zg.playerData:SaveRemoteConfig()
    end
    if lastTimeShow == nil then
        saveTime()
        return true
    elseif lastTimeShow ~= nil then
        local show = TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime()) > TimeUtils.GetTimeStartDayFromSec(lastTimeShow)
        if show then
            saveTime()
        end
        return show
    end
    return false
end
function EventBlackFridayModel:IsAutoShowValidDuration()
    local packId = 1
    local isBought = self:IsEndPack(packId)
    if isBought then
        local lastTimeDuration = zg.playerData.remoteConfig.lastTimeDurationBlackFriday
        if lastTimeDuration == nil then
            zg.playerData.remoteConfig.lastTimeDurationBlackFriday = self.subscriptionDurationDict:Get(packId)
            if zg.playerData.remoteConfig.lastTimeDurationBlackFriday == nil then
                zg.playerData.remoteConfig.lastTimeDurationBlackFriday = 0
            end
            zg.playerData:SaveRemoteConfig()
            return true
        else
            local subscriptionDuration = self.subscriptionDurationDict:Get(packId)
            if lastTimeDuration == 0 or lastTimeDuration == subscriptionDuration then
                return false
            else
                zg.playerData.remoteConfig.lastTimeDurationBlackFriday = subscriptionDuration
                zg.playerData:SaveRemoteConfig()
                return true
            end
        end
    end
    return false

end

function EventBlackFridayModel:IsEndPack(packId)
    if self.subscriptionDurationDict ~= nil and self.subscriptionDurationDict:IsContainKey(packId) then
        local check = self.subscriptionDurationDict:Get(packId) > 0
        return check
    end
    return false
end

function EventBlackFridayModel:IsClaim()
    if self.eventLoginData.lastClaimLoginTime ~= nil then
        return TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime()) <= self.eventLoginData.lastClaimLoginTime
                or self.eventLoginData.lastClaimDay >= 7
    end
    return nil
end

--- @class BlackFridayTab
BlackFridayTab = {
    CARD = 1,
    GEM_BOX = 2,
    DAILY_CHECK_IN = 3,
    BUNDLE = 4
}

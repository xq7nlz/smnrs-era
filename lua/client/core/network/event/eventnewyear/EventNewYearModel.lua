require "lua.client.core.network.event.eventNewYear.LotteryData"
require "lua.client.core.network.iap.LimitedPackStatisticsInBound"

--- @class EventNewYearModel : EventPopupModel
EventNewYearModel = Class(EventNewYearModel, EventPopupModel)

function EventNewYearModel:Ctor()
    --- @type Dictionary
    self.numberBuyDataDict = Dictionary()
    --- @type List
    --self.listOfLimitedPackStatistics = List()
    ---@type EventIdleTimeData
    self.eventIdleTimeData = nil
    ---@type LotteryData
    self.lotteryData = nil
    EventPopupModel.Ctor(self)
end

function EventNewYearModel:HasNotification()
    return self:IsTabNotified(NewYearTab.LOTTERY)
            or self:IsTabNotified(NewYearTab.CARD)
end

--- @param newYearTab NewYearTab
function EventNewYearModel:IsTabNotified(newYearTab)
    if newYearTab == NewYearTab.LOTTERY then
        local rollRequireListConfig = self:GetConfig():GetRollRequireConfig()
        local rollData = rollRequireListConfig:Get(self.lotteryData.numberRoll + 1)
        if (rollData == nil) then
            return false
        end
        return InventoryUtils.IsEnoughSingleResourceRequirement(rollData, false)
    elseif newYearTab == NewYearTab.CARD then
        local numberBuy = self:GetNumberBuy(EventActionType.NEW_YEAR_CARD_BUNDLE_PURCHASE, 1)
        if numberBuy == 0 then
            --- @type BasicInfoInBound
            local basicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
            local lastTimeLogin = basicInfoInBound.lastLoginTime
            local lastTimeCheckOutNewYearCard = zg.playerData.remoteConfig.lastTimeCheckOutNewYearCard
            if lastTimeCheckOutNewYearCard == nil or lastTimeCheckOutNewYearCard < lastTimeLogin then
                return true
            end
        end
        return false
    end
    return false
end

function EventNewYearModel:ReadData(buffer)
    EventPopupModel.ReadData(self, buffer)
    self:ReadSubscriptionPack(buffer)
end

function EventNewYearModel:ReadSubscriptionPack(buffer)
    --- @param buffer UnifiedNetwork_ByteBuf
    --- @param durationDict Dictionary
    local readDuration = function(buffer, durationDict)
        --- @type number
        local durationSize = buffer:GetShort()
        for _ = 1, durationSize do
            local packId = buffer:GetInt()
            local packDurationInDays = buffer:GetInt()
            durationDict:Add(packId, packDurationInDays)
            --XDebug.Log("pack id: " .. tostring(packId))
            --XDebug.Log("packDurationInDays : " .. tostring(packDurationInDays))
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

function EventNewYearModel:ReadInnerData(buffer)
    --- Event IdleTime
    --self.eventIdleTimeData = EventIdleTimeData()
    --self.eventIdleTimeData:ReadBuffer(buffer)

    -- Number Buy Data Map
    self.numberBuyDataDict = Dictionary()
    local size = buffer:GetByte()
    for i = 1, size do
        --- @type EventActionType
        local eventActionType = buffer:GetByte()
        local numberBuyData = NumberBuyData()
        numberBuyData:ReadBuffer(buffer)
        self.numberBuyDataDict:Add(eventActionType, numberBuyData)
    end

    --- List of LimitedPackStatistics
    --self.listOfLimitedPackStatistics = List()
    --size = buffer:GetByte()
    --for i = 1, size do
    --    self.listOfLimitedPackStatistics:Add(LimitedPackStatisticsInBound.CreateByBuffer(buffer))
    --end

    --- LotteryData
    self.lotteryData = LotteryData(buffer)
end

--- @param packId number
function EventNewYearModel:IncreaseNumberOfBoughtBundlePack(packId)
    --local pack = self:GetLimitedPackStatisticsInBound(packId)
    --if pack ~= nil then
    --    pack:IncreaseNumberOfBought()
    --else
    --    XDebug.Error(string.format("Limited Pack %d isn't exist", packId))
    --end
    self:AddNumberBuy(EventActionType.NEW_YEAR_BUNDLE_PURCHASE, packId)
end

function EventNewYearModel:GetOpenedLottery()
    return self.lotteryData.openedRewardIds
end

function EventNewYearModel:_GetNumberBuyData(eventActionType)
    ---@type NumberBuyData
    local numberBuyData = self.numberBuyDataDict:Get(eventActionType)
    if numberBuyData == nil then
        numberBuyData = NumberBuyData()
        self.numberBuyDataDict:Add(eventActionType, numberBuyData)
    end
    return numberBuyData
end

--- @param eventActionType EventActionType
function EventNewYearModel:GetNumberBuy(eventActionType, id)
    ---@type NumberBuyData
    local numberBuyData = self:_GetNumberBuyData(eventActionType)
    return numberBuyData.buyStatsDict:Get(id) or 0
end

function EventNewYearModel:AddNumberBuy(eventActionType, id, number)
    local number = number or 1
    ---@type NumberBuyData
    local numberBuyData = self:_GetNumberBuyData(eventActionType)
    local current = numberBuyData.buyStatsDict:Get(id) or 0
    numberBuyData.buyStatsDict:Add(id, current + number)
end

--- @return LimitedPackStatisticsInBound
--- @param packId number
function EventNewYearModel:GetLimitedPackStatisticsInBound(packId)
    --for i = 1, self.listOfLimitedPackStatistics:Count() do
    --    --- @type LimitedPackStatisticsInBound
    --    local itemData = self.listOfLimitedPackStatistics:Get(i)
    --    if itemData.packId == packId then
    --        return itemData
    --    end
    --end
    --local default = LimitedPackStatisticsInBound()
    --default.packId = packId
    --self.listOfLimitedPackStatistics:Add(default)
    --return default
    self:GetNumberBuy(EventActionType.NEW_YEAR_BUNDLE_PURCHASE, packId)
end

--- @return EventNewYearConfig
function EventNewYearModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end

function EventNewYearModel:IsEndPack(packId)
    if self.subscriptionDurationDict ~= nil and self.subscriptionDurationDict:IsContainKey(packId) then
        local check = self.subscriptionDurationDict:Get(packId) > 0
        return check
    end
    return false
end

function EventNewYearModel:IsValidCardDuration()
    local packId = 1
    local isBought = self:IsEndPack(packId)
    if isBought then
        local subscriptionDuration = self.subscriptionDurationDict:Get(packId)
        if subscriptionDuration > 0 then
            return true
        else
            return false
        end
    end
    return false

end

--- @class NewYearTab
NewYearTab = {
    GOLDEN_TIME = 1,
    CARD = 2,
    LOTTERY = 3,
    EXCHANGE = 4,
    BUNDLE = 5,
}

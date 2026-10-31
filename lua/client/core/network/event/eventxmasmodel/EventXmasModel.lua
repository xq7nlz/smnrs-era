require "lua.client.core.network.event.eventHalloweenModel.EventIdleTimeData"
require "lua.client.core.network.iap.LimitedPackStatisticsInBound"
require "lua.client.core.network.event.eventXmasModel.EventXmasLoginData"
require "lua.client.core.network.event.eventXmasModel.EventIgnatiusRankingInBound"
require "lua.client.core.network.event.eventXmasModel.ChristmasChallengeBossInBound"

--- @class EventXmasModel : EventPopupModel
EventXmasModel = Class(EventXmasModel, EventPopupModel)

function EventXmasModel:Ctor()
    --- @type Dictionary
    self.numberBuyDataDict = Dictionary()
    --- @type List
    self.listOfLimitedPackStatistics = List()
    ---@type EventIdleTimeData
    self.eventIdleTimeData = nil
    ---@type EventXmasLoginData
    self.eventXmasLoginData = nil
    ---@type EventIgnatiusRankingInBound
    self.eventIgnatiusRankingInBound = nil
    --- @type ChristmasChallengeBossInBound
    self.christmasChallengeBossInBound = nil
    EventPopupModel.Ctor(self)
end

function EventXmasModel:HasNotification()
    return self:IsTabNotified(XmasTab.DAILY_CHECK_IN)
            or self:IsTabNotified(XmasTab.FROSTY_IGNATIUS)
end

--- @param xmasTab XmasTab
function EventXmasModel:IsTabNotified(xmasTab)
    if xmasTab == XmasTab.DAILY_CHECK_IN then
        return self:IsDailyLoginHasNotification()
    elseif xmasTab == XmasTab.FROSTY_IGNATIUS then
        local turn = InventoryUtils.Get(ResourceType.Money, MoneyType.EVENT_CHRISTMAS_STAMINA)
        return turn > 0
    end
    return false
end

function EventXmasModel:IsDailyLoginHasNotification()
    return not self:IsFreeClaim()
end

function EventXmasModel:ReadInnerData(buffer)
    --- Event IdleTime
    self.eventIdleTimeData = EventIdleTimeData()
    self.eventIdleTimeData:ReadBuffer(buffer)

    self.numberBuyDataDict = Dictionary()
    local size = buffer:GetByte()
    for i = 1, size do
        --- @type EventActionType
        local eventActionType = buffer:GetByte()
        local numberBuyData = NumberBuyData()
        numberBuyData:ReadBuffer(buffer)
        self.numberBuyDataDict:Add(eventActionType, numberBuyData)
    end

    self.listOfLimitedPackStatistics = List()
    size = buffer:GetByte()
    for i = 1, size do
        self.listOfLimitedPackStatistics:Add(LimitedPackStatisticsInBound.CreateByBuffer(buffer))
    end

    --- Event Login
    self.eventXmasLoginData = EventXmasLoginData()
    self.eventXmasLoginData:ReadBuffer(buffer)

    if InventoryUtils.Get(ResourceType.Money, MoneyType.EVENT_CHRISTMAS_STAMINA) == 0 then
        PlayerDataRequest.Request(PlayerDataMethod.BASIC_INFO)
    end
end

--- @param packId number
function EventXmasModel:IncreaseNumberOfBoughtLimitedPack(packId)
    local pack = self:GetLimitedPackStatisticsInBound(packId)
    if pack ~= nil then
        pack:IncreaseNumberOfBought()
    else
        XDebug.Error(string.format("Limited Pack %d isn't exist", packId))
    end
end

function EventXmasModel:_GetNumberBuyData(eventActionType)
    ---@type NumberBuyData
    local numberBuyData = self.numberBuyDataDict:Get(eventActionType)
    if numberBuyData == nil then
        numberBuyData = NumberBuyData()
        self.numberBuyDataDict:Add(eventActionType, numberBuyData)
    end
    return numberBuyData
end

function EventXmasModel:GetPositionDiceList()
    return self.eventDiceGameData.historyPositionList
end

function EventXmasModel:GetNumberBuy(eventActionType, id)
    ---@type NumberBuyData
    local numberBuyData = self:_GetNumberBuyData(eventActionType)
    return numberBuyData.buyStatsDict:Get(id) or 0
end

function EventXmasModel:AddNumberBuy(eventActionType, id, number)
    ---@type NumberBuyData
    local numberBuyData = self:_GetNumberBuyData(eventActionType)
    local current = numberBuyData.buyStatsDict:Get(id) or 0
    numberBuyData.buyStatsDict:Add(id, current + number)
end

--- @return LimitedPackStatisticsInBound
--- @param packId number
function EventXmasModel:GetLimitedPackStatisticsInBound(packId)
    for i = 1, self.listOfLimitedPackStatistics:Count() do
        --- @type LimitedPackStatisticsInBound
        local itemData = self.listOfLimitedPackStatistics:Get(i)
        if itemData.packId == packId then
            return itemData
        end
    end
    local default = LimitedPackStatisticsInBound()
    default.packId = packId
    self.listOfLimitedPackStatistics:Add(default)
    return default
end

function EventXmasModel:IsClaim()
    if self.eventXmasLoginData ~= nil then
        return self.eventXmasLoginData:IsClaim()
    end
    return nil
end

function EventXmasModel:IsFreeClaim()
    if self.eventXmasLoginData ~= nil then
        return self.eventXmasLoginData:IsFreeClaim()
    end
    return false
end

function EventXmasModel:GetLoginData()
    return self.eventXmasLoginData
end

--- @return EventXmasConfig
function EventXmasModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end

--- @class XmasTab
XmasTab = {
    GOLDEN_TIME = 1,
    FROSTY_IGNATIUS = 2,
    SHOP = 3,
    EXCLUSIVE_OFFER = 4,
    DAILY_CHECK_IN = 5,
}

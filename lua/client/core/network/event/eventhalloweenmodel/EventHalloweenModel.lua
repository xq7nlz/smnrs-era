require "lua.client.core.network.event.eventHalloweenModel.EventIdleTimeData"
require "lua.client.core.network.event.eventHalloweenModel.EventDiceGameData"
require "lua.client.core.network.event.eventHalloweenModel.EventHalloweenLoginData"
require "lua.client.core.network.event.eventMidAutumnModel.FeedBeastQuestInBound"
require "lua.client.core.network.iap.LimitedPackStatisticsInBound"

--- @class EventHalloweenModel : EventPopupModel
EventHalloweenModel = Class(EventHalloweenModel, EventPopupModel)

function EventHalloweenModel:Ctor()
    --- @type Dictionary
    self.numberBuyDataDict = Dictionary()
    --- @type List
    self.listOfLimitedPackStatistics = List()
    ---@type EventIdleTimeData
    self.eventIdleTimeData = nil
    ---@type EventDiceGameData
    self.eventDiceGameData = nil
    ---@type EventHalloweenLoginData
    self.eventHalloweenLoginData = nil
    EventPopupModel.Ctor(self)
end

function EventHalloweenModel:HasNotification()
    return self:IsTabNotified(HalloweenTab.GOLDEN_TIME)
            or self:IsTabNotified(HalloweenTab.DICE)
            or self:IsTabNotified(HalloweenTab.EXCHANGE)
            or self:IsTabNotified(HalloweenTab.SPECIAL_OFFER)
            --or self:IsTabNotified(HalloweenTab.DAILY_CHECK_IN)
            or self:IsTabNotified(HalloweenTab.QUEST)
            or self:IsTabNotified(HalloweenTab.SHOP)
end

--- @param halloweenTab HalloweenTab
function EventHalloweenModel:IsTabNotified(halloweenTab)
    if halloweenTab == HalloweenTab.GOLDEN_TIME then
        -- return self:IsGoldenTimeHasNotification()
    elseif halloweenTab == HalloweenTab.DICE then
        return self:IsDiceHasNotification()
    elseif halloweenTab == HalloweenTab.EXCHANGE then
        --   return self:IsExchangeHasNotification()
    elseif halloweenTab == HalloweenTab.SPECIAL_OFFER then
         --return self:IsSpecialOfferHasNotification()
    --elseif halloweenTab == HalloweenTab.DAILY_CHECK_IN then
    --     return self:IsDailyLoginHasNotification()
    elseif halloweenTab == HalloweenTab.QUEST then
        return self:HasClaimableDailyQuest()
    elseif halloweenTab == HalloweenTab.SHOP then

    end
    return false
end

function EventHalloweenModel:IsDiceHasNotification()
    local requireList = self:GetConfig():GetRollRequireConfig()
    return InventoryUtils.IsEnoughSingleResourceRequirement(requireList:Get(1), false)
end

function EventHalloweenModel:IsDailyLoginHasNotification()
    return not self:IsFreeClaim()
end

function EventHalloweenModel:ReadInnerData(buffer)
    ---@type EventHalloweenConfig
    self.config = self:GetConfig()
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
    self.eventHalloweenLoginData = EventHalloweenLoginData()
    self.eventHalloweenLoginData:ReadBuffer(buffer)
    --- Event Dice
    self.eventDiceGameData = EventDiceGameData()
    self.eventDiceGameData:ReadBuffer(buffer)
    self.listQuestData = List()
    local sizeQuest = buffer:GetByte()
    for _ = 1, sizeQuest do
        local feedBeastQuestInBound = FeedBeastQuestInBound()
        feedBeastQuestInBound:ReadBuffer(buffer)
        self.listQuestData:Add(feedBeastQuestInBound)
    end
    local sizeDailyQuest = buffer:GetByte()
    self.listDailyQuest = QuestDataInBound.ReadListQuestFromBuffer(buffer, self.config:GetDailyQuestConfig(),sizeDailyQuest)
    self:CheckResourceOnSeason()
end

--- @return LimitedPackStatisticsInBound
--- @param packId number
function EventHalloweenModel:GetLimitedPackStatisticsInBound(packId)
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

--- @param packId number
function EventHalloweenModel:IncreaseNumberOfBoughtLimitedPack(packId)
    local pack = self:GetLimitedPackStatisticsInBound(packId)
    if pack ~= nil then
        pack:IncreaseNumberOfBought()
    else
        XDebug.Error(string.format("Limited Pack %d isn't exist", packId))
    end
end

function EventHalloweenModel:GetDiceData()
    return self.eventDiceGameData
end

function EventHalloweenModel:GetLoginData()
    return self.eventHalloweenLoginData
end
function EventHalloweenModel:_GetNumberBuyData(eventActionType)
    ---@type NumberBuyData
    local numberBuyData = self.numberBuyDataDict:Get(eventActionType)
    if numberBuyData == nil then
        numberBuyData = NumberBuyData()
        self.numberBuyDataDict:Add(eventActionType, numberBuyData)
    end
    return numberBuyData
end

function EventHalloweenModel:GetPositionDiceList()
    return self.eventDiceGameData.historyPositionList
end

function EventHalloweenModel:GetNumberBuy(eventActionType, id)
    ---@type NumberBuyData
    local numberBuyData = self:_GetNumberBuyData(eventActionType)
    return numberBuyData.buyStatsDict:Get(id) or 0
end

function EventHalloweenModel:AddNumberBuy(eventActionType, id, number)
    ---@type NumberBuyData
    local numberBuyData = self:_GetNumberBuyData(eventActionType)
    local current = numberBuyData.buyStatsDict:Get(id) or 0
    numberBuyData.buyStatsDict:Add(id, current + number)
end

function EventHalloweenModel:IsClaim()
    if self.eventHalloweenLoginData ~= nil then
        return self.eventHalloweenLoginData:IsClaim()
    end
    return nil
end
function EventHalloweenModel:IsFreeClaim()
    if self.eventHalloweenLoginData ~= nil then
        return self.eventHalloweenLoginData:IsFreeClaim()
    end
    return nil
end

--- @return EventHalloweenConfig
function EventHalloweenModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end

function EventHalloweenModel:GetHalloweenDice()
    return InventoryUtils.Get(ResourceType.Money, MoneyType.EVENT_HALLOWEEN_DICE)
end

function EventHalloweenModel:CheckResourceOnSeason()
    local endTime = self.timeData.endTime
    local savedRemoteConfig = false
    if (zg.playerData.remoteConfig.eventHalloweenEnd == nil) then
        savedRemoteConfig = true
    end
    local savedEndSeason = zg.playerData.remoteConfig.eventHalloweenEnd or endTime
    if savedEndSeason ~= endTime or savedRemoteConfig then
        self:UpdateHalloweenDice()
        zg.playerData.remoteConfig.eventBattlePassEnd = endTime
        zg.playerData.remoteConfig.firstOpen = true
        zg.playerData:SaveRemoteConfig()
    end
end

function EventHalloweenModel:UpdateHalloweenDice()
    local curMoney = self:GetHalloweenDice()
    InventoryUtils.Sub(ResourceType.Money, MoneyType.EVENT_HALLOWEEN_DICE, curMoney)
end

function EventHalloweenModel:HasClaimableDailyQuest()
    --- @param v QuestUnitInBound
    for _, v in pairs(self.listDailyQuest:GetItems()) do
        if v.questState == QuestState.DONE_REWARD_NOT_CLAIM then
            return true
        end
    end
end

--- @return List
function EventHalloweenModel:GetListSortedDailyQuestData()
    QuestDataInBound.SortQuestByQuestId(self.listDailyQuest)
    return self:SortQuestByListQuestData(self.listDailyQuest)
end

--- @return List
function EventHalloweenModel:GetListDailyQuestData()
    return self.listDailyQuest
end

function EventHalloweenModel:OnClaimQuestDailySuccess(questId)
    --- @param v QuestUnitInBound
    for _, v in ipairs(self.listDailyQuest:GetItems()) do
        if v.questId == questId then
            v.questState = QuestState.COMPLETED
            break
        end
    end
    self:SortQuestByListQuestData(self.listDailyQuest)
end

--- @param listQuestData List|QuestUnitInBound
function EventHalloweenModel:SortQuestByListQuestData(listQuestData)
    local count = listQuestData:Count()
    local index = 1
    local firstIndex = 1
    for _ = 1, count do
        --- @type QuestUnitInBound
        local questData = listQuestData:Get(index)
        if questData.questState == QuestState.DONE_REWARD_NOT_CLAIM then
            listQuestData:RemoveByIndex(index)
            listQuestData:Insert(questData, firstIndex)
            firstIndex = firstIndex + 1
        elseif questData.questState == QuestState.COMPLETED then
            listQuestData:RemoveByIndex(index)
            listQuestData:Insert(questData, count)
            index = index - 1
        end
        index = index + 1
    end
    return listQuestData
end

--- @class HalloweenTab
HalloweenTab = {
    GOLDEN_TIME = 1,
    DICE = 2,
    QUEST = 3,
    EXCHANGE = 4,
    --DAILY_CHECK_IN = 5,
    SPECIAL_OFFER = 6,
    SHOP = 7,
}

require "lua.client.core.network.event.eventThankGiving.EventThankGivingIdleTimeData"
require "lua.client.core.network.event.eventThankGiving.EventThankGivingDiceGameData"
require "lua.client.core.network.event.eventThankGiving.EventThankGivingLoginData"
require "lua.client.core.network.event.eventMidAutumnModel.FeedBeastQuestInBound"
require "lua.client.core.network.iap.LimitedPackStatisticsInBound"

--- @class EventSummerDayModel : EventPopupModel
EventSummerDayModel = Class(EventSummerDayModel, EventPopupModel)

function EventSummerDayModel:Ctor()
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

function EventSummerDayModel:HasNotification()
    return self:IsTabNotified(SummerDayTab.GOLDEN_TIME)
            or self:IsTabNotified(SummerDayTab.DICE)
            or self:IsTabNotified(SummerDayTab.EXCHANGE)
            or self:IsTabNotified(SummerDayTab.SPECIAL_OFFER)
            --or self:IsTabNotified(SummerDayTab.DAILY_CHECK_IN)
            or self:IsTabNotified(SummerDayTab.QUEST)
            or self:IsTabNotified(SummerDayTab.SHOP)
end

--- @param tab SummerDayTab
function EventSummerDayModel:IsTabNotified(tab)
    if tab == SummerDayTab.GOLDEN_TIME then
        -- return self:IsGoldenTimeHasNotification()
    elseif tab == SummerDayTab.DICE then
        return self:IsDiceHasNotification()
    elseif tab == SummerDayTab.EXCHANGE then
        --   return self:IsExchangeHasNotification()
    elseif tab == SummerDayTab.SPECIAL_OFFER then
         --return self:IsSpecialOfferHasNotification()
    --elseif SummerDayTab == SummerDayTab.DAILY_CHECK_IN then
    --     return self:IsDailyLoginHasNotification()
    elseif tab == SummerDayTab.QUEST then
        return self:HasClaimableDailyQuest()
    elseif tab == SummerDayTab.SHOP then

    end
    return false
end

function EventSummerDayModel:IsDiceHasNotification()
    local requireList = self:GetConfig():GetRollRequireConfig()
    return InventoryUtils.IsEnoughSingleResourceRequirement(requireList:Get(1), false)
end

function EventSummerDayModel:IsDailyLoginHasNotification()
    return not self:IsFreeClaim()
end

function EventSummerDayModel:ReadInnerData(buffer)
    ---@type EventHalloweenConfig
    self.config = self:GetConfig()
    --- Event IdleTime
    self.eventIdleTimeData = EventThankGivingIdleTimeData()
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
    self.eventHalloweenLoginData = EventThankGivingLoginData()
    self.eventHalloweenLoginData:ReadBuffer(buffer)
    --- Event Dice
    self.eventDiceGameData = EventThankGivingDiceGameData()
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
    --self:CheckResourceOnSeason()
end

--- @return LimitedPackStatisticsInBound
--- @param packId number
function EventSummerDayModel:GetLimitedPackStatisticsInBound(packId)
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
function EventSummerDayModel:IncreaseNumberOfBoughtLimitedPack(packId)
    local pack = self:GetLimitedPackStatisticsInBound(packId)
    if pack ~= nil then
        pack:IncreaseNumberOfBought()
    else
        XDebug.Error(string.format("Limited Pack %d isn't exist", packId))
    end
end

function EventSummerDayModel:GetDiceData()
    return self.eventDiceGameData
end

function EventSummerDayModel:GetLoginData()
    return self.eventHalloweenLoginData
end
function EventSummerDayModel:_GetNumberBuyData(eventActionType)
    ---@type NumberBuyData
    local numberBuyData = self.numberBuyDataDict:Get(eventActionType)
    if numberBuyData == nil then
        numberBuyData = NumberBuyData()
        self.numberBuyDataDict:Add(eventActionType, numberBuyData)
    end
    return numberBuyData
end

function EventSummerDayModel:GetPositionDiceList()
    return self.eventDiceGameData.historyPositionList
end

function EventSummerDayModel:GetNumberBuy(eventActionType, id)
    ---@type NumberBuyData
    local numberBuyData = self:_GetNumberBuyData(eventActionType)
    return numberBuyData.buyStatsDict:Get(id) or 0
end

function EventSummerDayModel:AddNumberBuy(eventActionType, id, number)
    ---@type NumberBuyData
    local numberBuyData = self:_GetNumberBuyData(eventActionType)
    local current = numberBuyData.buyStatsDict:Get(id) or 0
    numberBuyData.buyStatsDict:Add(id, current + number)
end

function EventSummerDayModel:IsClaim()
    if self.eventHalloweenLoginData ~= nil then
        return self.eventHalloweenLoginData:IsClaim()
    end
    return nil
end
function EventSummerDayModel:IsFreeClaim()
    if self.eventHalloweenLoginData ~= nil then
        return self.eventHalloweenLoginData:IsFreeClaim()
    end
    return nil
end

--- @return EventHalloweenConfig
function EventSummerDayModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end

function EventSummerDayModel:GetHalloweenDice()
    return InventoryUtils.Get(ResourceType.Money, MoneyType.EVENT_SUMMER_PLAY_TICKET)
end

function EventSummerDayModel:CheckResourceOnSeason()
    local endTime = self.timeData.endTime
    local savedRemoteConfig = false
    if (zg.playerData.remoteConfig.eventThanksGivingEnd == nil) then
        savedRemoteConfig = true
    end
    local savedEndSeason = zg.playerData.remoteConfig.eventThanksGivingEnd or endTime
    if savedEndSeason ~= endTime or savedRemoteConfig then
        self:UpdateHalloweenDice()
        zg.playerData.remoteConfig.eventBattlePassEnd = endTime
        zg.playerData.remoteConfig.firstOpen = true
        zg.playerData:SaveRemoteConfig()
    end
end

function EventSummerDayModel:UpdateHalloweenDice()
    local curMoney = self:GetHalloweenDice()
    InventoryUtils.Sub(ResourceType.Money, MoneyType.EVENT_SUMMER_PLAY_TICKET, curMoney)
end

function EventSummerDayModel:HasClaimableDailyQuest()
    --- @param v QuestUnitInBound
    for _, v in pairs(self.listDailyQuest:GetItems()) do
        if v.questState == QuestState.DONE_REWARD_NOT_CLAIM then
            return true
        end
    end
end

--- @return List
function EventSummerDayModel:GetListSortedDailyQuestData()
    QuestDataInBound.SortQuestByQuestId(self.listDailyQuest)
    return self:SortQuestByListQuestData(self.listDailyQuest)
end

--- @return List
function EventSummerDayModel:GetListDailyQuestData()
    return self.listDailyQuest
end

function EventSummerDayModel:OnClaimQuestDailySuccess(questId)
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
function EventSummerDayModel:SortQuestByListQuestData(listQuestData)
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

--- @class SummerDayTab
SummerDayTab = {
    GOLDEN_TIME = 1,
    DICE = 2,
    QUEST = 3,
    EXCHANGE = 4,
    SPECIAL_OFFER = 5,
    SHOP = 6,
}

require "lua.client.core.network.event.eventThankGiving.EventThankGivingIdleTimeData"
require "lua.client.core.network.event.eventThankGiving.EventThankGivingDiceGameData"
require "lua.client.core.network.event.eventThankGiving.EventThankGivingLoginData"
require "lua.client.core.network.event.eventMidAutumnModel.FeedBeastQuestInBound"
require "lua.client.core.network.iap.LimitedPackStatisticsInBound"

--- @class EventThankGivingModel : EventPopupModel
EventThankGivingModel = Class(EventThankGivingModel, EventPopupModel)

function EventThankGivingModel:Ctor()
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

function EventThankGivingModel:HasNotification()
    return self:IsTabNotified(ThankGivingTab.GOLDEN_TIME)
            or self:IsTabNotified(ThankGivingTab.DICE)
            or self:IsTabNotified(ThankGivingTab.EXCHANGE)
            or self:IsTabNotified(ThankGivingTab.SPECIAL_OFFER)
            --or self:IsTabNotified(ThankGivingTab.DAILY_CHECK_IN)
            or self:IsTabNotified(ThankGivingTab.QUEST)
            or self:IsTabNotified(ThankGivingTab.SHOP)
end

--- @param thankGivingTab ThankGivingTab
function EventThankGivingModel:IsTabNotified(thankGivingTab)
    if thankGivingTab == ThankGivingTab.GOLDEN_TIME then
        -- return self:IsGoldenTimeHasNotification()
    elseif thankGivingTab == ThankGivingTab.DICE then
        return self:IsDiceHasNotification()
    elseif thankGivingTab == ThankGivingTab.EXCHANGE then
        --   return self:IsExchangeHasNotification()
    elseif thankGivingTab == ThankGivingTab.SPECIAL_OFFER then
         --return self:IsSpecialOfferHasNotification()
    --elseif ThankGivingTab == ThankGivingTab.DAILY_CHECK_IN then
    --     return self:IsDailyLoginHasNotification()
    elseif thankGivingTab == ThankGivingTab.QUEST then
        return self:HasClaimableDailyQuest()
    elseif thankGivingTab == ThankGivingTab.SHOP then

    end
    return false
end

function EventThankGivingModel:IsDiceHasNotification()
    local requireList = self:GetConfig():GetRollRequireConfig()
    return InventoryUtils.IsEnoughSingleResourceRequirement(requireList:Get(1), false)
end

function EventThankGivingModel:IsDailyLoginHasNotification()
    return not self:IsFreeClaim()
end

function EventThankGivingModel:ReadInnerData(buffer)
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
function EventThankGivingModel:GetLimitedPackStatisticsInBound(packId)
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
function EventThankGivingModel:IncreaseNumberOfBoughtLimitedPack(packId)
    local pack = self:GetLimitedPackStatisticsInBound(packId)
    if pack ~= nil then
        pack:IncreaseNumberOfBought()
    else
        XDebug.Error(string.format("Limited Pack %d isn't exist", packId))
    end
end

function EventThankGivingModel:GetDiceData()
    return self.eventDiceGameData
end

function EventThankGivingModel:GetLoginData()
    return self.eventHalloweenLoginData
end
function EventThankGivingModel:_GetNumberBuyData(eventActionType)
    ---@type NumberBuyData
    local numberBuyData = self.numberBuyDataDict:Get(eventActionType)
    if numberBuyData == nil then
        numberBuyData = NumberBuyData()
        self.numberBuyDataDict:Add(eventActionType, numberBuyData)
    end
    return numberBuyData
end

function EventThankGivingModel:GetPositionDiceList()
    return self.eventDiceGameData.historyPositionList
end

function EventThankGivingModel:GetNumberBuy(eventActionType, id)
    ---@type NumberBuyData
    local numberBuyData = self:_GetNumberBuyData(eventActionType)
    return numberBuyData.buyStatsDict:Get(id) or 0
end

function EventThankGivingModel:AddNumberBuy(eventActionType, id, number)
    ---@type NumberBuyData
    local numberBuyData = self:_GetNumberBuyData(eventActionType)
    local current = numberBuyData.buyStatsDict:Get(id) or 0
    numberBuyData.buyStatsDict:Add(id, current + number)
end

function EventThankGivingModel:IsClaim()
    if self.eventHalloweenLoginData ~= nil then
        return self.eventHalloweenLoginData:IsClaim()
    end
    return nil
end
function EventThankGivingModel:IsFreeClaim()
    if self.eventHalloweenLoginData ~= nil then
        return self.eventHalloweenLoginData:IsFreeClaim()
    end
    return nil
end

--- @return EventHalloweenConfig
function EventThankGivingModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end

function EventThankGivingModel:GetHalloweenDice()
    return InventoryUtils.Get(ResourceType.Money, MoneyType.THANK_GIVING_DICE)
end

function EventThankGivingModel:CheckResourceOnSeason()
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

function EventThankGivingModel:UpdateHalloweenDice()
    local curMoney = self:GetHalloweenDice()
    InventoryUtils.Sub(ResourceType.Money, MoneyType.THANK_GIVING_DICE, curMoney)
end

function EventThankGivingModel:HasClaimableDailyQuest()
    --- @param v QuestUnitInBound
    for _, v in pairs(self.listDailyQuest:GetItems()) do
        if v.questState == QuestState.DONE_REWARD_NOT_CLAIM then
            return true
        end
    end
end

--- @return List
function EventThankGivingModel:GetListSortedDailyQuestData()
    QuestDataInBound.SortQuestByQuestId(self.listDailyQuest)
    return self:SortQuestByListQuestData(self.listDailyQuest)
end

--- @return List
function EventThankGivingModel:GetListDailyQuestData()
    return self.listDailyQuest
end

function EventThankGivingModel:OnClaimQuestDailySuccess(questId)
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
function EventThankGivingModel:SortQuestByListQuestData(listQuestData)
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

--- @class ThankGivingTab
ThankGivingTab = {
    GOLDEN_TIME = 1,
    DICE = 2,
    QUEST = 3,
    EXCHANGE = 4,
    --DAILY_CHECK_IN = 5,
    SPECIAL_OFFER = 6,
    SHOP = 7,
}

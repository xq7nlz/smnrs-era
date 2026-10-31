require "lua.client.core.network.event.eventThankGiving.EventThankGivingIdleTimeData"
require "lua.client.core.network.event.eventThankGiving.EventThankGivingDiceGameData"
require "lua.client.core.network.event.eventThankGiving.EventThankGivingLoginData"
require "lua.client.core.network.event.eventMidAutumnModel.FeedBeastQuestInBound"
require "lua.client.core.network.iap.LimitedPackStatisticsInBound"

--- @class EventEasterDayModel : EventPopupModel
EventEasterDayModel = Class(EventEasterDayModel, EventPopupModel)

function EventEasterDayModel:Ctor()
    --- @type Dictionary
    self.numberBuyDataDict = Dictionary()
    --- @type List
    self.listOfLimitedPackStatistics = List()
    ---@type EventIdleTimeData
    self.eventIdleTimeData = nil
    ---@type EventDiceGameData
    self.eventDiceGameData = nil
    ---@type EventThankGivingLoginData
    self.eventEasterDayLoginData = nil
    EventPopupModel.Ctor(self)
end

function EventEasterDayModel:HasNotification()
    return self:IsTabNotified(EasterDayTab.GOLDEN_TIME)
            or self:IsTabNotified(EasterDayTab.DICE)
            or self:IsTabNotified(EasterDayTab.EXCHANGE)
            or self:IsTabNotified(EasterDayTab.SPECIAL_OFFER)
            --or self:IsTabNotified(ThankGivingTab.DAILY_CHECK_IN)
            or self:IsTabNotified(EasterDayTab.QUEST)
            or self:IsTabNotified(EasterDayTab.SHOP)
end

--- @param thankGivingTab ThankGivingTab
function EventEasterDayModel:IsTabNotified(thankGivingTab)
    if thankGivingTab == EasterDayTab.GOLDEN_TIME then
        -- return self:IsGoldenTimeHasNotification()
    elseif thankGivingTab == EasterDayTab.DICE then
        return self:IsDiceHasNotification()
    elseif thankGivingTab == EasterDayTab.EXCHANGE then
        --   return self:IsExchangeHasNotification()
    elseif thankGivingTab == EasterDayTab.SPECIAL_OFFER then
         --return self:IsSpecialOfferHasNotification()
    --elseif ThankGivingTab == ThankGivingTab.DAILY_CHECK_IN then
    --     return self:IsDailyLoginHasNotification()
    elseif thankGivingTab == EasterDayTab.QUEST then
        return self:HasClaimableDailyQuest()
    elseif thankGivingTab == EasterDayTab.SHOP then

    end
    return false
end

function EventEasterDayModel:IsDiceHasNotification()
    local requireList = self:GetConfig():GetRollRequireConfig()
    return InventoryUtils.IsEnoughSingleResourceRequirement(requireList:Get(1), false)
end

function EventEasterDayModel:IsDailyLoginHasNotification()
    return not self:IsFreeClaim()
end

function EventEasterDayModel:ReadInnerData(buffer)
    ---@type EventEasterDayConfig
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
    self.eventEasterDayLoginData = EventThankGivingLoginData()
    self.eventEasterDayLoginData:ReadBuffer(buffer)
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
function EventEasterDayModel:GetLimitedPackStatisticsInBound(packId)
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
function EventEasterDayModel:IncreaseNumberOfBoughtLimitedPack(packId)
    local pack = self:GetLimitedPackStatisticsInBound(packId)
    if pack ~= nil then
        pack:IncreaseNumberOfBought()
    else
        XDebug.Error(string.format("Limited Pack %d isn't exist", packId))
    end
end

function EventEasterDayModel:GetDiceData()
    return self.eventDiceGameData
end

function EventEasterDayModel:GetLoginData()
    return self.eventEasterDayLoginData
end
function EventEasterDayModel:_GetNumberBuyData(eventActionType)
    ---@type NumberBuyData
    local numberBuyData = self.numberBuyDataDict:Get(eventActionType)
    if numberBuyData == nil then
        numberBuyData = NumberBuyData()
        self.numberBuyDataDict:Add(eventActionType, numberBuyData)
    end
    return numberBuyData
end

function EventEasterDayModel:GetPositionDiceList()
    return self.eventDiceGameData.historyPositionList
end

function EventEasterDayModel:GetNumberBuy(eventActionType, id)
    ---@type NumberBuyData
    local numberBuyData = self:_GetNumberBuyData(eventActionType)
    return numberBuyData.buyStatsDict:Get(id) or 0
end

function EventEasterDayModel:AddNumberBuy(eventActionType, id, number)
    ---@type NumberBuyData
    local numberBuyData = self:_GetNumberBuyData(eventActionType)
    local current = numberBuyData.buyStatsDict:Get(id) or 0
    numberBuyData.buyStatsDict:Add(id, current + number)
end

function EventEasterDayModel:IsClaim()
    if self.eventEasterDayLoginData ~= nil then
        return self.eventEasterDayLoginData:IsClaim()
    end
    return nil
end
function EventEasterDayModel:IsFreeClaim()
    if self.eventEasterDayLoginData ~= nil then
        return self.eventEasterDayLoginData:IsFreeClaim()
    end
    return nil
end

--- @return EventHalloweenConfig
function EventEasterDayModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end

function EventEasterDayModel:GetHalloweenDice()
    return InventoryUtils.Get(ResourceType.Money, MoneyType.EASTER_DAY_PLAY_TICKET)
end

function EventEasterDayModel:CheckResourceOnSeason()
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

function EventEasterDayModel:UpdateHalloweenDice()
    local curMoney = self:GetHalloweenDice()
    InventoryUtils.Sub(ResourceType.Money, MoneyType.EASTER_DAY_PLAY_TICKET, curMoney)
end

function EventEasterDayModel:HasClaimableDailyQuest()
    --- @param v QuestUnitInBound
    for _, v in pairs(self.listDailyQuest:GetItems()) do
        if v.questState == QuestState.DONE_REWARD_NOT_CLAIM then
            return true
        end
    end
end

--- @return List
function EventEasterDayModel:GetListSortedDailyQuestData()
    QuestDataInBound.SortQuestByQuestId(self.listDailyQuest)
    return self:SortQuestByListQuestData(self.listDailyQuest)
end

--- @return List
function EventEasterDayModel:GetListDailyQuestData()
    return self.listDailyQuest
end

function EventEasterDayModel:OnClaimQuestDailySuccess(questId)
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
function EventEasterDayModel:SortQuestByListQuestData(listQuestData)
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

--- @class EasterDayTab
EasterDayTab = {
    GOLDEN_TIME = 1,
    DICE = 2,
    QUEST = 3,
    EXCHANGE = 4,
    SPECIAL_OFFER = 5,
    SHOP = 6,
}

require "lua.client.core.network.event.eventThankGiving.EventThankGivingIdleTimeData"
require "lua.client.core.network.event.eventThankGiving.EventThankGivingLoginData"
require "lua.client.core.network.event.eventMidAutumnModel.FeedBeastQuestInBound"
require "lua.client.core.network.iap.LimitedPackStatisticsInBound"

--- @class EventNewYear2023Model : EventPopupModel
EventNewYear2023Model = Class(EventNewYear2023Model, EventPopupModel)

function EventNewYear2023Model:Ctor()
    --- @type Dictionary
    self.numberBuyDataDict = Dictionary()
    --- @type List
    self.listOfLimitedPackStatistics = List()
    ---@type EventIdleTimeData
    self.eventIdleTimeData = nil
    ---@type EventHalloweenLoginData
    self.eventHalloweenLoginData = nil
    --- @type number
    self.wishTotal = nil
    EventPopupModel.Ctor(self)
end

function EventNewYear2023Model:HasNotification()
    return self:IsTabNotified(NewYear2023Tab.GOLDEN_TIME)
            or self:IsTabNotified(NewYear2023Tab.LUCKY_WISH)
            or self:IsTabNotified(NewYear2023Tab.EXCHANGE)
            or self:IsTabNotified(NewYear2023Tab.SPECIAL_OFFER)
            --or self:IsTabNotified(NewYear2023Tab.DAILY_CHECK_IN)
            or self:IsTabNotified(NewYear2023Tab.QUEST)
            or self:IsTabNotified(NewYear2023Tab.SHOP)
end

--- @param newYear2023Tab NewYear2023Tab
function EventNewYear2023Model:IsTabNotified(newYear2023Tab)
    if newYear2023Tab == NewYear2023Tab.GOLDEN_TIME then
        -- return self:IsGoldenTimeHasNotification()
    elseif newYear2023Tab == NewYear2023Tab.EXCHANGE then
           --return self:IsExchangeHasNotification()
    elseif newYear2023Tab == NewYear2023Tab.LUCKY_WISH then
        return self:IsWishHasNotification()
    elseif newYear2023Tab == NewYear2023Tab.SPECIAL_OFFER then
         --return self:IsSpecialOfferHasNotification()
    elseif newYear2023Tab == NewYear2023Tab.QUEST then
        return self:HasClaimableDailyQuest()
    elseif newYear2023Tab == NewYear2023Tab.SHOP then

    end
    return false
end

function EventNewYear2023Model:IsWishHasNotification()
    local require = self:GetConfig():GetWishConfig().require
    return InventoryUtils.IsEnoughSingleResourceRequirement(require, false)
end

function EventNewYear2023Model:IsDailyLoginHasNotification()
    return not self:IsFreeClaim()
end

function EventNewYear2023Model:ReadInnerData(buffer)
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

    self.listPosition = List()
    size = buffer:GetByte()
    for i = 1, size do
        self.listPosition:Add(buffer:GetInt())
    end

    self.wishTotal = buffer:GetInt()

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

function EventNewYear2023Model:GetOpenedLottery()
    return self.listPosition
end

--- @return LimitedPackStatisticsInBound
--- @param packId number
function EventNewYear2023Model:GetLimitedPackStatisticsInBound(packId)
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
function EventNewYear2023Model:IncreaseNumberOfBoughtLimitedPack(packId)
    local pack = self:GetLimitedPackStatisticsInBound(packId)
    if pack ~= nil then
        pack:IncreaseNumberOfBought()
    else
        XDebug.Error(string.format("Limited Pack %d isn't exist", packId))
    end
end

function EventNewYear2023Model:GetLoginData()
    return self.eventHalloweenLoginData
end
function EventNewYear2023Model:_GetNumberBuyData(eventActionType)
    ---@type NumberBuyData
    local numberBuyData = self.numberBuyDataDict:Get(eventActionType)
    if numberBuyData == nil then
        numberBuyData = NumberBuyData()
        self.numberBuyDataDict:Add(eventActionType, numberBuyData)
    end
    return numberBuyData
end

function EventNewYear2023Model:GetNumberBuy(eventActionType, id)
    ---@type NumberBuyData
    local numberBuyData = self:_GetNumberBuyData(eventActionType)
    return numberBuyData.buyStatsDict:Get(id) or 0
end

function EventNewYear2023Model:AddNumberBuy(eventActionType, id, number)
    ---@type NumberBuyData
    local numberBuyData = self:_GetNumberBuyData(eventActionType)
    local current = numberBuyData.buyStatsDict:Get(id) or 0
    numberBuyData.buyStatsDict:Add(id, current + number)
end

function EventNewYear2023Model:IsClaim()
    if self.eventHalloweenLoginData ~= nil then
        return self.eventHalloweenLoginData:IsClaim()
    end
    return nil
end
function EventNewYear2023Model:IsFreeClaim()
    if self.eventHalloweenLoginData ~= nil then
        return self.eventHalloweenLoginData:IsFreeClaim()
    end
    return nil
end

--- @return EventNewYear2023Config
function EventNewYear2023Model:GetConfig()
    return EventPopupModel.GetConfig(self)
end

function EventNewYear2023Model:HasClaimableDailyQuest()
    --- @param v QuestUnitInBound
    for _, v in pairs(self.listDailyQuest:GetItems()) do
        if v.questState == QuestState.DONE_REWARD_NOT_CLAIM then
            return true
        end
    end
end

--- @return List
function EventNewYear2023Model:GetListSortedDailyQuestData()
    QuestDataInBound.SortQuestByQuestId(self.listDailyQuest)
    return self:SortQuestByListQuestData(self.listDailyQuest)
end

--- @return List
function EventNewYear2023Model:GetListDailyQuestData()
    return self.listDailyQuest
end

function EventNewYear2023Model:OnClaimQuestDailySuccess(questId)
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
function EventNewYear2023Model:SortQuestByListQuestData(listQuestData)
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

--- @class NewYear2023Tab
NewYear2023Tab = {
    GOLDEN_TIME = 1,
    LUCKY_WISH = 2,
    QUEST = 3,
    EXCHANGE = 4,
    --DAILY_CHECK_IN = 5,
    SPECIAL_OFFER = 6,
    SHOP = 7,
}

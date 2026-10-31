require "lua.client.core.network.event.eventThankGiving.EventThankGivingIdleTimeData"
require "lua.client.core.network.event.eventThankGiving.EventThankGivingLoginData"
require "lua.client.core.network.event.eventMidAutumnModel.FeedBeastQuestInBound"
require "lua.client.core.network.iap.LimitedPackStatisticsInBound"

--- @class EventLunarNewYear2024Model : EventPopupModel
EventLunarNewYear2024Model = Class(EventLunarNewYear2024Model, EventPopupModel)

function EventLunarNewYear2024Model:Ctor()
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

function EventLunarNewYear2024Model:HasNotification()
    return self:IsTabNotified(LunarNewYear2024Tab.GOLDEN_TIME)
            or self:IsTabNotified(LunarNewYear2024Tab.BINGO)
            or self:IsTabNotified(LunarNewYear2024Tab.EXCHANGE)
            or self:IsTabNotified(LunarNewYear2024Tab.SPECIAL_OFFER)
            or self:IsTabNotified(LunarNewYear2024Tab.QUEST)
            or self:IsTabNotified(LunarNewYear2024Tab.SHOP)
end

--- @param newYear2023Tab NewYear2023Tab
function EventLunarNewYear2024Model:IsTabNotified(newYear2023Tab)
    if newYear2023Tab == LunarNewYear2024Tab.GOLDEN_TIME then
        -- return self:IsGoldenTimeHasNotification()
    elseif newYear2023Tab == LunarNewYear2024Tab.EXCHANGE then
           --return self:IsExchangeHasNotification()
    elseif newYear2023Tab == LunarNewYear2024Tab.BINGO then
        return false
    elseif newYear2023Tab == LunarNewYear2024Tab.SPECIAL_OFFER then
         --return self:IsSpecialOfferHasNotification()
    elseif newYear2023Tab == LunarNewYear2024Tab.QUEST then
        return self:HasClaimableDailyQuest()
    elseif newYear2023Tab == LunarNewYear2024Tab.SHOP then

    end
    return false
end

function EventLunarNewYear2024Model:IsWishHasNotification()
    local require = self:GetConfig():GetWishConfig().require
    return InventoryUtils.IsEnoughSingleResourceRequirement(require, false)
end

function EventLunarNewYear2024Model:IsDailyLoginHasNotification()
    return not self:IsFreeClaim()
end

function EventLunarNewYear2024Model:ReadInnerData(buffer)
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

    self.openedCardPositionDict = Dictionary()
    size = buffer:GetByte()
    for i = 1, size do
        self.openedCardPositionDict:Add(buffer:GetInt(), buffer:GetInt())
    end

    self.totalBingo = buffer:GetInt()
    self.totalOpenTime = buffer:GetInt()

    self.listQuestData = List()
    local sizeQuest = buffer:GetByte()
    for _ = 1, sizeQuest do
        local feedBeastQuestInBound = FeedBeastQuestInBound()
        feedBeastQuestInBound:ReadBuffer(buffer)
        self.listQuestData:Add(feedBeastQuestInBound)
    end

    local sizeDailyQuest = buffer:GetByte()
    self.listDailyQuest = QuestDataInBound.ReadListQuestFromBuffer(buffer, self.config:GetDailyQuestConfig(),sizeDailyQuest)
end

function EventLunarNewYear2024Model:AddOpenCardPosition(index, idCard)
    if not self.openedCardPositionDict:IsContainKey(index) then
        self.openedCardPositionDict:Add(index, idCard)
    end
end

---@return boolean
function EventLunarNewYear2024Model:CheckCanOpenCard(index)
    if self.openedCardPositionDict:IsContainKey(index) == false then
        return true
    end
    return false
end

function EventLunarNewYear2024Model:SetOpenedCardDict(openedCardDictInbound)
    self.openedCardPositionDict = Dictionary()
    self.openedCardPositionDict = openedCardDictInbound
end

function EventLunarNewYear2024Model:GetRewardById(id)
    for k,v in pairs(self.openedCardPositionDict:GetItems()) do
        if k == id then
            return v
        end
    end
    return nil
end

---@return Dictionary
function EventLunarNewYear2024Model:GetOpenedCard()
    return self.openedCardPositionDict
end

--- @return LimitedPackStatisticsInBound
--- @param packId number
function EventLunarNewYear2024Model:GetLimitedPackStatisticsInBound(packId)
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
function EventLunarNewYear2024Model:IncreaseNumberOfBoughtLimitedPack(packId)
    local pack = self:GetLimitedPackStatisticsInBound(packId)
    if pack ~= nil then
        pack:IncreaseNumberOfBought()
    else
        XDebug.Error(string.format("Limited Pack %d isn't exist", packId))
    end
end

function EventLunarNewYear2024Model:GetLoginData()
    return self.eventHalloweenLoginData
end
function EventLunarNewYear2024Model:_GetNumberBuyData(eventActionType)
    ---@type NumberBuyData
    local numberBuyData = self.numberBuyDataDict:Get(eventActionType)
    if numberBuyData == nil then
        numberBuyData = NumberBuyData()
        self.numberBuyDataDict:Add(eventActionType, numberBuyData)
    end
    return numberBuyData
end

function EventLunarNewYear2024Model:GetNumberBuy(eventActionType, id)
    ---@type NumberBuyData
    local numberBuyData = self:_GetNumberBuyData(eventActionType)
    return numberBuyData.buyStatsDict:Get(id) or 0
end

function EventLunarNewYear2024Model:AddNumberBuy(eventActionType, id, number)
    ---@type NumberBuyData
    local numberBuyData = self:_GetNumberBuyData(eventActionType)
    local current = numberBuyData.buyStatsDict:Get(id) or 0
    numberBuyData.buyStatsDict:Add(id, current + number)
end

function EventLunarNewYear2024Model:IsClaim()
    if self.eventHalloweenLoginData ~= nil then
        return self.eventHalloweenLoginData:IsClaim()
    end
    return nil
end
function EventLunarNewYear2024Model:IsFreeClaim()
    if self.eventHalloweenLoginData ~= nil then
        return self.eventHalloweenLoginData:IsFreeClaim()
    end
    return nil
end

--- @return EventLunarNewY
function EventLunarNewYear2024Model:GetConfig()
    return EventPopupModel.GetConfig(self)
end

function EventLunarNewYear2024Model:HasClaimableDailyQuest()
    --- @param v QuestUnitInBound
    for _, v in pairs(self.listDailyQuest:GetItems()) do
        if v.questState == QuestState.DONE_REWARD_NOT_CLAIM then
            return true
        end
    end
end

--- @return List
function EventLunarNewYear2024Model:GetListSortedDailyQuestData()
    QuestDataInBound.SortQuestByQuestId(self.listDailyQuest)
    return self:SortQuestByListQuestData(self.listDailyQuest)
end

--- @return List
function EventLunarNewYear2024Model:GetListDailyQuestData()
    return self.listDailyQuest
end

function EventLunarNewYear2024Model:OnClaimQuestDailySuccess(questId)
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
function EventLunarNewYear2024Model:SortQuestByListQuestData(listQuestData)
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

--- @class LunarNewYear2024Tab
LunarNewYear2024Tab = {
    GOLDEN_TIME = 1,
    BINGO = 2,
    QUEST = 3,
    EXCHANGE = 4,
    SPECIAL_OFFER = 5,
    SHOP = 6,
}

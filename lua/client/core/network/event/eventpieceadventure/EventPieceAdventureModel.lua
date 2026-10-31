require "lua.client.core.network.event.eventPieceAdventure.PieceAdventureOpenCardData"

--- @class EventPieceAdventureModel : EventPopupModel
EventPieceAdventureModel = Class(EventPieceAdventureModel, EventPopupModel)

function EventPieceAdventureModel:Ctor()
    ---@type List
    self.listOfLimitedPackStatistics = List()
    ---@type List
    self.listDailyQuest = List()
    ---@type number
    self.currentFloor = nil
    ---@type boolean
    self.isFirstTime = nil
    --- @type PieceAdventureOpenCardData
    self.openedCardDict = nil
    EventPopupModel.Ctor(self)
end

--- @return EventPieceAdventureConfig
function EventPieceAdventureModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventPieceAdventureModel:ReadInnerData(buffer)
    ---@type EventPieceAdventureConfig
    self.config = self:GetConfig()
    self.numberBuyDataDict = EventPopupModel.ReadNumberBuyDataDict(buffer)

    self.currentFloor = buffer:GetInt()

    --- @type PieceAdventureOpenCardData
    self.openedCardDict = PieceAdventureOpenCardData(buffer)

    self.listOfLimitedPackStatistics = List()
    for _ = 1, buffer:GetByte() do
        self.listOfLimitedPackStatistics:Add(LimitedPackStatisticsInBound.CreateByBuffer(buffer))
    end

    self.isFirstTime = buffer:GetBool()

    local sizeQuest = buffer:GetByte()
    self.listDailyQuest = QuestDataInBound.ReadListQuestFromBuffer(buffer, self.config:GetDailyQuestConfig(), sizeQuest)
end

function EventPieceAdventureModel:AddNumberOfBoughtLimitedPack(id)
    ---@type LimitedPackStatisticsInBound
    local pack = self:GetPackData(id)
    if pack ~= nil then
        pack:IncreaseNumberOfBought()
    else
        XDebug.Error(string.format("Limited Pack %d isn't exist", id))
    end
end

function EventPieceAdventureModel:GetPackData(id)
    ---@param v LimitedPackStatisticsInBound
    for _, v in pairs(self.listOfLimitedPackStatistics:GetItems()) do
        if v.packId == id then
            return v
        end
    end
    local default = LimitedPackStatisticsInBound()
    default.packId = id
    self.listOfLimitedPackStatistics:Add(default)
    return default
end

function EventPieceAdventureModel:GetNumberOfBoughtLimitedPack(id)
    ---@param v LimitedPackStatisticsInBound
    for _, v in pairs(self.listOfLimitedPackStatistics:GetItems()) do
        if v.packId == id then
            return v:GetNumberOfBought()
        end
    end
    return 0
end

function EventPieceAdventureModel:_GetNumberBuyData(eventActionType)
    ---@type NumberBuyData
    local numberBuyData = self.numberBuyDataDict:Get(eventActionType)
    if numberBuyData == nil then
        numberBuyData = NumberBuyData()
        self.numberBuyDataDict:Add(eventActionType, numberBuyData)
    end
    return numberBuyData
end

function EventPieceAdventureModel:GetNumberBuy(eventActionType, id)
    ---@type NumberBuyData
    local numberBuyData = self:_GetNumberBuyData(eventActionType)
    return numberBuyData.buyStatsDict:Get(id) or 0
end

function EventPieceAdventureModel:AddNumberBuy(eventActionType, id, number)
    ---@type NumberBuyData
    local numberBuyData = self:_GetNumberBuyData(eventActionType)
    local current = numberBuyData.buyStatsDict:Get(id) or 0
    numberBuyData.buyStatsDict:Add(id, current + number)
end

--- @return List
function EventPieceAdventureModel:GetListSortedDailyQuestData()
    QuestDataInBound.SortQuestByQuestId(self.listDailyQuest)
    return self:SortQuestByListQuestData(self.listDailyQuest)
end

function EventPieceAdventureModel:OnClaimQuestDailySuccess(questId)
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
function EventPieceAdventureModel:SortQuestByListQuestData(listQuestData)
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

--- @return PieceAdventureOpenCardData
function EventPieceAdventureModel:GetPieceAdventureOpenCardByFloor(id)
    return self.openedCardDict
end

function EventPieceAdventureModel:HasNotification()
    return self:IsTabNotified(EventPieceAdventureTab.PIECE_ADVENTURE)
            or self:IsTabNotified(EventPieceAdventureTab.PIECE_STORE)
            or self:IsTabNotified(EventPieceAdventureTab.DAILY_QUEST)
            or self:IsTabNotified(EventPieceAdventureTab.EXCHANGE)
end

--- @param pieceAdventureTab EventPieceAdventureTab
function EventPieceAdventureModel:IsTabNotified(pieceAdventureTab)
    if pieceAdventureTab == EventPieceAdventureTab.PIECE_ADVENTURE then
        return false
    elseif pieceAdventureTab == EventPieceAdventureTab.PIECE_STORE then
        return self:HasFreeOrAdsBundleLeft()
    elseif pieceAdventureTab == EventPieceAdventureTab.DAILY_QUEST then
        return self:HasClaimableDailyQuest()
    elseif pieceAdventureTab == EventPieceAdventureTab.EXCHANGE then
        return false
    end
    return false
end

function EventPieceAdventureModel:HasTicket()
    local currentValue = InventoryUtils.GetMoney(MoneyType.EVENT_PIECE_ADVENTURE_KEY)
    return currentValue > 0
end

function EventPieceAdventureModel:HasClaimableDailyQuest()
    --- @param v QuestUnitInBound
    for _, v in pairs(self.listDailyQuest:GetItems()) do
        if v.questState == QuestState.DONE_REWARD_NOT_CLAIM then
            return true
        end
    end
end

function EventPieceAdventureModel:HasFreeOrAdsBundleLeft()
    self.listData = ResourceMgr.GetPurchaseConfig():GetEventPieceAdventureBundleStore():GetPack(self.timeData.dataId).packDict
    --- @param v ProductConfig
    for k, v in ipairs(self.listData:GetItems()) do
        if v.priceType == IapPackPriceType.FREE or v.priceType == IapPackPriceType.WATCH_ADS then
            if self:GetNumberOfBoughtLimitedPack(v.id) < v.stock then
                return true
            end
        end
    end
    return false
end

--- @return EventValentineConfig
function EventPieceAdventureModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end

--- @class EventPieceAdventureTab
EventPieceAdventureTab = {
    PIECE_ADVENTURE = 1,
    DAILY_QUEST = 2,
    EXCHANGE = 3,
    PIECE_STORE = 4,
}
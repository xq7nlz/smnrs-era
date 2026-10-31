require "lua.client.core.network.event.eventHalloweenModel.EventDiceGameData"
require "lua.client.core.network.playerData.common.QuestDataInBound"
require "lua.client.core.network.event.eventLunarNewYear.EventLunarBossData"

--- @class EventLunarPathModel : EventPopupModel
EventLunarPathModel = Class(EventLunarPathModel, EventPopupModel)

function EventLunarPathModel:Ctor()
    --- @type EventDiceGameData
    self.eventDiceGameData = nil
    --- @type Dictionary
    self.receivedRewardHistory = Dictionary()
    --- @type boolean
    self.isInGuild = false
    --- @type EventLunarBossData
    self.eventLunarBossData = nil
    --- @type Dictionary
    self.numberBuyDataDict = Dictionary()

    --- @type Dictionary<number, QuestElementConfig>
    self.questConfig = nil
    EventPopupModel.Ctor(self)
end

function EventLunarPathModel:HasNotification()
    return self:IsLunarPathTabNotified(LunarPathTab.DICE)
            or self:IsLunarPathTabNotified(LunarPathTab.QUEST)
            or self:IsLunarPathTabNotified(LunarPathTab.BOSS)
            or self:IsLunarPathTabNotified(LunarPathTab.SHOP)
end

--- @param lunarPathTab LunarPathTab
function EventLunarPathModel:IsLunarPathTabNotified(lunarPathTab)
    if lunarPathTab == LunarPathTab.DICE then
        return InventoryUtils.Get(ResourceType.Money, MoneyType.EVENT_LUNAR_NEW_YEAR_DICE) > 0
    elseif lunarPathTab == LunarPathTab.QUEST then
        return QuestDataInBound.HasDoneNotClaimQuest(self.listQuest)
    elseif lunarPathTab == LunarPathTab.BOSS then
        return InventoryUtils.Get(ResourceType.Money, MoneyType.EVENT_LUNAR_NEW_YEAR_CHALLENGE_STAMINA) > 0
                and self.eventLunarBossData ~= nil
                and self.eventLunarBossData.currentChap > self.eventLunarBossData.recentPassedChap
    end
    return false
end

function EventLunarPathModel:ReadInnerData(buffer)
    local size = buffer:GetByte()
    for i = 1, size do
        --- @type EventActionType
        local eventActionType = buffer:GetByte()
        local numberBuyData = NumberBuyData()
        numberBuyData:ReadBuffer(buffer)
        self.numberBuyDataDict:Add(eventActionType, numberBuyData)
    end

    local size = buffer:GetByte()
    for i = 1, size do
        self.receivedRewardHistory:Add(buffer:GetInt(), buffer:GetBool())
    end

    self.eventDiceGameData = EventDiceGameData(buffer)

    self.isInGuild = buffer:GetBool()
    if self.isInGuild == true then
        self.eventLunarBossData = EventLunarBossData()
        self.eventLunarBossData:ReadBuffer(buffer)
    else
        self.eventLunarBossData = nil
    end

    self:ReadQuestBuffer(buffer)
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventLunarPathModel:ReadQuestBuffer(buffer)
    self:GetQuestConfig()
    self.listQuest = QuestDataInBound.ReadListQuestFromBuffer(buffer, self.questConfig)
    self:_FilterDailyQuest()
end

function EventLunarPathModel:GetQuestConfig()
    self.questConfig = Dictionary()
    --- @type EventLunarPathModel
    local eventLunarPathModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_LUNAR_PATH)
    if eventLunarPathModel ~= nil then
        --- @type EventLunarPathConfig
        local eventConfig = eventLunarPathModel:GetConfig()
        self.questConfig = eventConfig:GetQuestConfig()
    end
end

function EventLunarPathModel:_FilterDailyQuest()
    local totalHidden = 0
    --- @type QuestUnitInBound
    local questData
    local questCount = self.listQuest:Count()
    for i = questCount, 1, -1 do
        --- @type QuestUnitInBound
        local questUnitData = self.listQuest:Get(i)
        if questUnitData.questState == QuestState.HIDDEN then
            self.listQuest:RemoveByIndex(i)
            totalHidden = totalHidden + 1
        elseif questData == nil then
            --- @type QuestElementConfig
            local questElementConfig = self.questConfig:Get(questUnitData.questId)
            if questElementConfig:GetQuestType() == QuestType.DAILY_QUEST_COMPLETE then
                questData = questUnitData
            end
        end
    end
    if questData ~= nil then
        questData.number = questData.number - totalHidden
    end
    self:SortQuestByData()
end

function EventLunarPathModel:OnClaimQuestSuccess(questId)
    for i = 1, self.listQuest:Count() do
        --- @type QuestUnitInBound
        local questData = self.listQuest:Get(i)
        if questData.questId == questId then
            questData.questState = QuestState.COMPLETED
            break
        end
    end
    self:SortQuestByData()
end

function EventLunarPathModel:SortQuestByData()
    self.listQuest = QuestDataInBound.SortQuestByData(self.listQuest)
end

--- @param eventActionType EventActionType
function EventLunarPathModel:_GetNumberBuyData(eventActionType)
    ---@type NumberBuyData
    local numberBuyData = self.numberBuyDataDict:Get(eventActionType)
    if numberBuyData == nil then
        numberBuyData = NumberBuyData()
        self.numberBuyDataDict:Add(eventActionType, numberBuyData)
    end
    return numberBuyData
end

--- @param eventActionType EventActionType
function EventLunarPathModel:GetNumberBuy(eventActionType, id)
    ---@type NumberBuyData
    local numberBuyData = self:_GetNumberBuyData(eventActionType)
    return numberBuyData.buyStatsDict:Get(id) or 0
end

--- @param eventActionType EventActionType
function EventLunarPathModel:AddNumberBuy(eventActionType, id, number)
    ---@type NumberBuyData
    local numberBuyData = self:_GetNumberBuyData(eventActionType)
    local current = numberBuyData.buyStatsDict:Get(id) or 0
    numberBuyData.buyStatsDict:Add(id, current + number)
end

--- @return EventNewYearConfig
function EventLunarPathModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end

function EventLunarPathModel:CheckResourceOnSeason()
    local endTime = self.timeData.endTime
    local savedEndSeason = zg.playerData.remoteConfig.eventLunarNewYearEnd or endTime
    if savedEndSeason ~= endTime then
        self:ClearMoneyType()
        zg.playerData.remoteConfig.eventLunarNewYearEnd = endTime
        zg.playerData:SaveRemoteConfig()
    end
end

function EventLunarPathModel:ClearMoneyType()
    local clearResource = function(moneyType)
        local currentValue = InventoryUtils.Get(ResourceType.Money, moneyType)
        InventoryUtils.Sub(ResourceType.Money, moneyType, currentValue)
    end
    clearResource(MoneyType.SUMMON_ELITE_SCROLL)
    clearResource(MoneyType.EVENT_LUNAR_NEW_YEAR_SUMMON_POINT)
end

---@return LimitedPackStatisticsInBound
function EventLunarPathModel:GetLimitedPackStatisticsInBound(packId)
    ---@type LimitedPackStatisticsInBound
    local pack = self.dictLimitedPackStatistics:Get(packId)
    if pack == nil then
        ---@type NumberBuyData
        local numberBuyData = self.numberBuyDataDict:Get(EventActionType.LUNAR_NEW_YEAR_ELITE_BUNDLE_PURCHASE)
        if numberBuyData == nil then
            numberBuyData = NumberBuyData()
            self.numberBuyDataDict:Add(EventActionType.LUNAR_NEW_YEAR_ELITE_BUNDLE_PURCHASE, numberBuyData)
        end
        pack = LimitedPackStatisticsInBound()
        pack.numberOfBought = numberBuyData:GetNumberOfBoughtWithPackId(packId)
        self.dictLimitedPackStatistics:Add(packId, pack)
    end
    return pack
end

--- @class LunarPathTab
LunarPathTab = {
    DICE = 1,
    QUEST = 2,
    BOSS = 3,
    SHOP = 4,
    BUNDLE = 5,
}
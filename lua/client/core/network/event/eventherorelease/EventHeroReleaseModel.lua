--- @class EventHeroReleaseModel : EventPopupModel
EventHeroReleaseModel = Class(EventHeroReleaseModel, EventPopupModel)

function EventHeroReleaseModel:ReadInnerData(buffer)
    self.numberSummon = buffer:GetInt()
    self.lastFreeSummon = buffer:GetLong()
    self.numberBuyDataDict = EventPopupModel.ReadNumberBuyDataDict(buffer)
    --- @type List
    self.listCollectionQuestData = QuestDataInBound.ReadListQuestFromBuffer(buffer, self:GetConfig():GetCollectionQuestConfig(), buffer:GetByte())
    self.listCollectionQuestData = QuestDataInBound.SortQuestByData(self.listCollectionQuestData)
    self.listCollectionQuestData = QuestDataInBound.FilterHiddenQuest(self.listCollectionQuestData)
    --- @type List
    self.listSummonQuestData = QuestDataInBound.ReadListQuestFromBuffer(buffer, self:GetConfig():GetSummonQuestConfig(), buffer:GetByte())
    self.listSummonQuestData = QuestDataInBound.SortQuestByData(self.listSummonQuestData)
    self.listSummonQuestData = QuestDataInBound.FilterHiddenQuest(self.listSummonQuestData)
    --- @type List
    self.listDailyQuestData = QuestDataInBound.ReadListQuestFromBuffer(buffer, self:GetConfig():GetDailyQuestConfig(), buffer:GetByte())
    self.listDailyQuestData = QuestDataInBound.SortQuestByData(self.listDailyQuestData)
    self.listDailyQuestData = QuestDataInBound.FilterHiddenQuest(self.listDailyQuestData)
end

--- @return number
function EventHeroReleaseModel:GetTimeFreeSummon()
    local serverTime = TimeUtils.GetTimeEndDayFromSec(zg.timeMgr:GetServerTime())
    return serverTime - zg.timeMgr:GetServerTime() + 1
end

--- @return number
function EventHeroReleaseModel:IsAvailableFreeSummon()
    local serverTime = zg.timeMgr:GetServerTime()
    return self.lastFreeSummon - TimeUtils.GetTimeStartDayFromSec(serverTime) < 0
end

--- @return boolean
function EventHeroReleaseModel:IsNotifySummon()
    return self:IsAvailableFreeSummon()
end

--- @return EventHeroReleaseConfig
function EventHeroReleaseModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end

--- @return QuestUnitInBound
--- @param indexOfList number
function EventHeroReleaseModel:GetDataByIndexOfList(indexOfList)
    return self.listCollectionQuestData:Get(indexOfList)
end

function EventHeroReleaseModel:HasNotification()
    return self:IsTabNotified(EventHeroReleaseTab.DailyQuest)
            or self:IsTabNotified(EventHeroReleaseTab.Collection)
            or self:IsTabNotified(EventHeroReleaseTab.Bundle)
end

function EventHeroReleaseModel:IsTabNotified(eventHeroReleaseTab)
    if eventHeroReleaseTab == EventHeroReleaseTab.DailyQuest then
        return QuestDataInBound.HasDoneNotClaimQuest(self.listDailyQuestData)
    elseif eventHeroReleaseTab == EventHeroReleaseTab.Collection then
        return QuestDataInBound.HasDoneNotClaimQuest(self.listCollectionQuestData)
    end
    return false
end

--- @param eventTab EventHeroReleaseTab
function EventHeroReleaseModel:OnClaimQuestSuccess(eventTab, questId)
    local listQuestData
    if eventTab == EventHeroReleaseTab.DailyQuest then
        listQuestData = self.listDailyQuestData
    else
        listQuestData = self.listCollectionQuestData
    end

    for i = 1, listQuestData:Count() do
        --- @type QuestUnitInBound
        local questUnitInBound = listQuestData:Get(i)
        if questUnitInBound.questId == questId then
            questUnitInBound.questState = QuestState.COMPLETED
            break
        end
    end
    listQuestData = QuestDataInBound.SortQuestByData(listQuestData)
end

function EventHeroReleaseModel:GetNumberBuy(eventActionType, id)
    ---@type NumberBuyData
    local numberBuyData = self:_GetNumberBuyData(eventActionType)
    return numberBuyData.buyStatsDict:Get(id) or 0
end

function EventHeroReleaseModel:AddNumberBuy(eventActionType, id, number)
    ---@type NumberBuyData
    local numberBuyData = self:_GetNumberBuyData(eventActionType)
    local current = numberBuyData.buyStatsDict:Get(id) or 0
    numberBuyData.buyStatsDict:Add(id, current + number)
end

function EventHeroReleaseModel:_GetNumberBuyData(eventActionType)
    ---@type NumberBuyData
    local numberBuyData = self.numberBuyDataDict:Get(eventActionType)
    if numberBuyData == nil then
        numberBuyData = NumberBuyData()
        self.numberBuyDataDict:Add(eventActionType, numberBuyData)
    end
    return numberBuyData
end

--- @param opCode OpCode
--- @param packId number
function EventHeroReleaseModel:AddNumberBuyOpCode(opCode, packId, number)
    if opCode == OpCode.EVENT_HERO_RELEASE_BUNDLE_PURCHASE then
        self:AddNumberBuy(EventActionType.NEW_HERO_RELEASE_BUNDLE_PURCHASE, packId, number)
    end
end

--- @param opCode OpCode
--- @param packId number
---@return number
function EventHeroReleaseModel:GetNumberBuyOpCode(opCode, packId)
    if opCode == OpCode.EVENT_HERO_RELEASE_BUNDLE_PURCHASE then
        return self:GetNumberBuy(EventActionType.NEW_HERO_RELEASE_BUNDLE_PURCHASE, packId)
    end
    return 0
end

---@return UnityEngine_Sprite
function EventHeroReleaseModel:GetEventIcon()
    return self:GetConfig():GetEventIcon(self.timeData.dataId)
end

--- @class EventHeroReleaseTab
EventHeroReleaseTab = {
    Overview = 1,
    DailyQuest = 2,
    Collection = 3,
    Bundle = 4,
    OverviewOtherHero = 5
}
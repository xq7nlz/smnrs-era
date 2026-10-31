require "lua.client.core.network.event.EventPopupModel"
require "lua.client.core.network.event.EventLoginDataByWeek"
require "lua.client.core.network.event.eventAiryuu.EventAiryuuTrialData"
--- @class EventAiryuuModel : EventPopupModel
EventAiryuuModel = Class(EventAiryuuModel, EventPopupModel)

function EventAiryuuModel:Ctor()
    ---@type boolean
    self.isHasData = false
    ---@type EventLoginData
    self.loginData = nil
    ---@type NumberBuyData
    self.numberBuyData = NumberBuyData()
    ---@type EventAiryuuTrialData
    self.eventAiryuuTrialData = EventAiryuuTrialData()
    ---@type List
    self.listTreasureQuest = List()
    ---@type List
    self.listCollectionQuest = List()
    ---@type List
    self.listOfLimitedPackStatistics = List()
    ---@type Dictionary
    self.loginRewardDict = Dictionary()
    ---@type Dictionary
    self.treasureQuestDict = Dictionary()
    ---@type List
    self.listTreasureReward = nil
    ---@type number
    self.loginDayCount = nil
    EventPopupModel.Ctor(self)
end

--- @return EventAiryuuConfig
function EventAiryuuModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventAiryuuModel:ReadInnerData(buffer)
    self.config = self:GetConfig()
    self:ClearData()
    self.loginData = EventLoginData(buffer)
    local size = buffer:GetByte()
    for i = 1, size do
        self.listOfLimitedPackStatistics:Add(LimitedPackStatisticsInBound.CreateByBuffer(buffer))
    end
    self.treasureFreeDaily = buffer:GetInt()
    self.eventAiryuuTrialData = EventAiryuuTrialData(buffer)
    self.listCollectionQuest = QuestDataInBound.ReadListQuestFromBuffer(buffer, self.config:GetCollectionQuestConfig())
    self.listTreasureQuest = QuestDataInBound.ReadListQuestFromBuffer(buffer, self.config:GetTreasureQuestConfig())

    self:CheckResourceOnSeason()
end

function EventAiryuuModel:ClearData()
    if self.listOfLimitedPackStatistics:Count() > 0 then
        self.listOfLimitedPackStatistics:Clear()
    end
    if self.listTreasureQuest:Count() > 0 then
        self.listTreasureQuest:Clear()
    end
    if self.listCollectionQuest:Count() > 0 then
        self.listCollectionQuest:Clear()
    end
end

function EventAiryuuModel:GetLoginData()
    return self.loginData
end

function EventAiryuuModel:GetTreasureFreeDaily()
    return self.treasureFreeDaily or 0
end

function EventAiryuuModel:AddTreasureFreeDaily()
    self.treasureFreeDaily = self.treasureFreeDaily + 1
    return self.treasureFreeDaily
end

--- @return LimitedPackStatisticsInBound
--- @param packId number
function EventAiryuuModel:GetLimitedPackStatisticsInBound(packId)
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

function EventAiryuuModel:HasKey()
    local currentValue = InventoryUtils.GetMoney(MoneyType.EVENT_AIRYUU_TREASURE_KEY)
    return currentValue > 0
end

function EventAiryuuModel:HasFreeOpenTreasure()
    return self.treasureFreeDaily < self.config:GetTrialStaminaConfig().dailyFree
end

--- @param packId number
function EventAiryuuModel:IncreaseNumberOfBoughtLimitedPack(packId)
    local pack = self:GetLimitedPackStatisticsInBound(packId)
    if pack ~= nil then
        pack:IncreaseNumberOfBought()
    else
        XDebug.Error(string.format("Limited Pack %d isn't exist", packId))
    end
end

function EventAiryuuModel:HasNotification()
    return self:IsTabNotified(EventAiryuuTab.HERO_TREASURE)
            or self:IsTabNotified(EventAiryuuTab.HERO_QUEST)
            or self:IsTabNotified(EventAiryuuTab.HERO_EVOLUTION)
            or self:IsTabNotified(EventAiryuuTab.HERO_BUNDLE)
            or self:IsTabNotified(EventAiryuuTab.CHECK_IN)
            or self:IsTabNotified(EventAiryuuTab.HERO_TRIAL)
end

function EventAiryuuModel:IsTabNotified(eventAiryuuTab)
    if eventAiryuuTab == EventAiryuuTab.HERO_TREASURE then
        return self:HasKey() or self:HasFreeOpenTreasure()
    elseif eventAiryuuTab == EventAiryuuTab.HERO_EVOLUTION then
        return self:HasQuestCollectionDoneButNotClaim()
    elseif eventAiryuuTab == EventAiryuuTab.HERO_QUEST then
        return self:HasQuestTreasureDoneButNotClaim()
    elseif eventAiryuuTab == EventAiryuuTab.HERO_BUNDLE then
        return self:HasAdsBundleLeft()
    elseif eventAiryuuTab == EventAiryuuTab.CHECK_IN then
        return not self:GetLoginData():IsClaimed()
    elseif eventAiryuuTab == EventAiryuuTab.HERO_TRIAL then
        return self.eventAiryuuTrialData:GetCurrentStamina() > 0
    end
    return false
end

function EventAiryuuModel:OnClaimQuestTreasureSuccess(questId)
    for i = 1, self:GetListTreasureQuestData():Count() do
        --- @type QuestUnitInBound
        local questData = self.listTreasureQuest:Get(i)
        if questData.questId == questId then
            questData.questState = QuestState.COMPLETED
            break
        end
    end
    self:SortQuestByData(self.listTreasureQuest)
end

function EventAiryuuModel:OnClaimQuestCollectionSuccess(questId)
    for i = 1, self:GetListCollectionQuestData():Count() do
        --- @type QuestUnitInBound
        local questData = self.listCollectionQuest:Get(i)
        if questData.questId == questId then
            questData.questState = QuestState.COMPLETED
            break
        end
    end
    self:SortQuestByData(self.listCollectionQuest)
end

function EventAiryuuModel:HasQuestCollectionDoneButNotClaim()
    --- @param questUnitInBound QuestUnitInBound
    for i, questUnitInBound in pairs(self:GetListCollectionQuestData():GetItems()) do
        if questUnitInBound.questState == QuestState.DONE_REWARD_NOT_CLAIM then
            return true
        end
    end
end

function EventAiryuuModel:HasQuestTreasureDoneButNotClaim()
    --- @param questUnitInBound QuestUnitInBound
    for i, questUnitInBound in pairs(self:GetListTreasureQuestData():GetItems()) do
        if questUnitInBound.questState == QuestState.DONE_REWARD_NOT_CLAIM then
            return true
        end
    end
end

--- @return List
function EventAiryuuModel:GetListTreasureQuestData()
    return self.listTreasureQuest
end

--- @return List
function EventAiryuuModel:GetListCollectionQuestData()
    return self.listCollectionQuest
end

function EventAiryuuModel:SortQuestByData(listQuest)
    return self:SortQuestByListQuestData(listQuest)
end

--- @param listQuestData List|QuestUnitInBound
function EventAiryuuModel:SortQuestByListQuestData(listQuestData)
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

function EventAiryuuModel:CheckResourceOnSeason()
    local endTime = self.timeData.endTime
    local savedEndSeason = zg.playerData.remoteConfig.eventAiryuuEnd or endTime
    if savedEndSeason ~= endTime then
        self:ClearMoneyType()
    end
    zg.playerData.remoteConfig.eventAiryuuEnd = endTime
    zg.playerData:SaveRemoteConfig()
end

function EventAiryuuModel:ClearMoneyType()
    local currentValue = InventoryUtils.GetMoney(MoneyType.EVENT_AIRYUU_TREASURE_KEY)
    InventoryUtils.Sub(ResourceType.Money, MoneyType.EVENT_AIRYUU_TREASURE_KEY, currentValue)
end

function EventAiryuuModel:GetNumberBuy(id)
    ---@param v LimitedPackStatisticsInBound
    for _, v in pairs(self.listOfLimitedPackStatistics:GetItems()) do
        if v.packId == id then
            return v:GetNumberOfBought()
        end
    end
    return 0
end

function EventAiryuuModel:GetPackData(id)
    ---@param v LimitedPackStatisticsInBound
    for _, v in pairs(self.listOfLimitedPackStatistics:GetItems()) do
        if v.packId == id then
            return v
        end
    end
    local default = LimitedPackStatisticsInBound()
    default.packId = id
    default.numberOfBought = 0
    self.listOfLimitedPackStatistics:Add(default)
    return default
end

function EventAiryuuModel:AddNumberBuy(id)
    ---@type LimitedPackStatisticsInBound
    local pack = self:GetPackData(id)
    if pack ~= nil then
        pack:IncreaseNumberOfBought()
    else
        XDebug.Error(string.format("Limited Pack %d isn't exist", id))
    end
end

function EventAiryuuModel:HasFreeBundleLeft()
    local freeBundle = self:GetNumberBuy(1)
    if freeBundle < 1 then
        return true
    end
end

function EventAiryuuModel:HasAdsBundleLeft()
    local adsBundle = self:GetNumberBuy(1)
    if adsBundle < 1 then
        return true
    end
    return false
end

--- @class EventAiryuuTab
EventAiryuuTab = {
    CHECK_IN = 1,
    HERO_TREASURE = 2,
    HERO_QUEST = 4,
    HERO_BUNDLE = 3,
    HERO_EVOLUTION = 5,
    HERO_TRIAL = 6,
}
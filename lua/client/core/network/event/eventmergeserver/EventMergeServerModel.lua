--- @class EventMergeServerModel : EventPopupModel
EventMergeServerModel = Class(EventMergeServerModel, EventPopupModel)

function EventMergeServerModel:Ctor()
    --- @type List
    self.listQuestData = List()
    --- @type List
    self.listAccumulateQuest = List()
    --- @type Dictionary
    self.numberBuyDataDict = nil
    --- @type EventLoginData
    self.eventLoginData = nil

    --- @type Dictionary
    self.itemSelectDict = nil

    EventPopupModel.Ctor(self)
end

function EventMergeServerModel:HasNotification()
    return self:IsTabNotified(MergeServerTab.CHECK_IN)
            or self:IsTabNotified(MergeServerTab.QUEST)
            or self:IsTabNotified(MergeServerTab.EXCHANGE)
            or self:IsTabNotified(MergeServerTab.BUNDLE)
            or self:IsTabNotified(MergeServerTab.ACCUMULATION)
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventMergeServerModel:ReadInnerData(buffer)
    self.eventLoginData = EventLoginData(buffer)

    self.numberBuyDataDict = EventPopupModel.ReadNumberBuyDataDict(buffer)

    self.itemSelectDict = Dictionary()
    local size = buffer:GetByte()
    for _ = 1, size do
        local key = buffer:GetInt()
        --- @type number
        local list = List()
        local s = buffer:GetByte()
        for _ = 1, s do
            list:Add(buffer:GetInt())
        end
        self.itemSelectDict:Add(key, list)
    end

    self.listQuestData = QuestDataInBound.ReadListQuestFromBuffer(buffer, self:GetConfig():GetQuestConfig())
    self.listQuestData = QuestDataInBound.SortQuestByData(self.listQuestData)

    self.listAccumulateQuest = QuestDataInBound.ReadListQuestFromBuffer(buffer, self:GetConfig():GetAccumulateQuestConfig(), buffer:GetByte())
    self.listAccumulateQuest = QuestDataInBound.SortQuestByData(self.listAccumulateQuest)
end

--- @return EventMergeServerConfig
function EventMergeServerModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end

--- @param mergeServerTab MergeServerTab
function EventMergeServerModel:IsTabNotified(mergeServerTab)
    if mergeServerTab == MergeServerTab.CHECK_IN then
        return self:IsDailyLoginHasNotification()
    elseif mergeServerTab == MergeServerTab.QUEST then
        return QuestDataInBound.HasDoneNotClaimQuest(self.listQuestData)
    elseif mergeServerTab == MergeServerTab.ACCUMULATION then
        return QuestDataInBound.HasDoneNotClaimQuest(self.listAccumulateQuest)
    end
    return false
end

function EventMergeServerModel:RequestClaimQuest(questId, callback)
    local onSuccess = function(rewardList)
        PopupUtils.ClaimAndShowRewardList(rewardList)
        self:OnClaimQuestSuccess(questId)
        if callback then
            callback()
        end
    end
    QuestDataInBound.RequestClaimQuest(OpCode.EVENT_SERVER_MERGE_DAILY_QUEST_CLAIM, questId, onSuccess)
end

function EventMergeServerModel:OnClaimQuestSuccess(questId)
    for i = 1, self.listQuestData:Count() do
        --- @type QuestUnitInBound
        local questUnitInBound = self.listQuestData:Get(i)
        if questUnitInBound.questId == questId then
            questUnitInBound.questState = QuestState.COMPLETED
            break
        end
    end
    self.listQuestData = QuestDataInBound.SortQuestByData(self.listQuestData)
end

function EventMergeServerModel:IsFreeClaim()
    if self.eventLoginData ~= nil then
        return self.eventLoginData:IsFreeClaim()
    end
    return false
end

function EventMergeServerModel:IsDailyLoginHasNotification()
    return not self:IsFreeClaim()
end

function EventMergeServerModel:IsClaim()
    if self.eventLoginData ~= nil then
        return self.eventLoginData:IsClaimed()
    end
    return nil
end

function EventMergeServerModel:IsFreeClaim()
    if self.eventLoginData ~= nil then
        return self.eventLoginData:IsFreeClaim()
    end
    return false
end

function EventMergeServerModel:GetLoginData()
    return self.eventLoginData
end

--- @param eventActionType EventActionType
function EventMergeServerModel:_GetNumberBuyData(eventActionType)
    ---@type NumberBuyData
    local numberBuyData = self.numberBuyDataDict:Get(eventActionType)
    if numberBuyData == nil then
        numberBuyData = NumberBuyData()
        self.numberBuyDataDict:Add(eventActionType, numberBuyData)
    end
    return numberBuyData
end

--- @param eventActionType EventActionType
function EventMergeServerModel:GetNumberBuy(eventActionType, id)
    ---@type NumberBuyData
    local numberBuyData = self:_GetNumberBuyData(eventActionType)
    return numberBuyData.buyStatsDict:Get(id) or 0
end

--- @param eventActionType EventActionType
function EventMergeServerModel:AddNumberBuy(eventActionType, id, number)
    ---@type NumberBuyData
    local numberBuyData = self:_GetNumberBuyData(eventActionType)
    local current = numberBuyData.buyStatsDict:Get(id) or 0
    numberBuyData.buyStatsDict:Add(id, current + number)
end

function EventMergeServerModel:RequestClaimAccumulateQuest(questId, callback)
    local onSuccess = function(rewardList)
        PopupUtils.ClaimAndShowRewardList(rewardList)
        self:OnClaimAccumulateQuestSuccess(questId)
        if callback then
            callback()
        end
    end
    QuestDataInBound.RequestClaimQuest(OpCode.EVENT_SERVER_MERGE_ACCUMULATE_QUEST_CLAIM, questId, onSuccess)
end

function EventMergeServerModel:OnClaimAccumulateQuestSuccess(questId)
    for i = 1, self.listAccumulateQuest:Count() do
        --- @type QuestUnitInBound
        local questUnitInBound = self.listAccumulateQuest:Get(i)
        if questUnitInBound.questId == questId then
            questUnitInBound.questState = QuestState.COMPLETED
            break
        end
    end
    self.listAccumulateQuest = QuestDataInBound.SortQuestByData(self.listAccumulateQuest)
end

function EventMergeServerModel:CheckResourceOnSeason()
    local endTime = self.timeData.endTime
    local savedEndSeason = zg.playerData.remoteConfig.eventMergeServerEnd or endTime
    if savedEndSeason ~= endTime then
        self:ClearMoneyType()
    end
    zg.playerData.remoteConfig.eventMergeServerEnd = endTime
    zg.playerData:SaveRemoteConfig()
end

function EventMergeServerModel:ClearMoneyType()
    local clearResource = function(moneyType)
        local currentValue = InventoryUtils.GetMoney(moneyType)
        InventoryUtils.Sub(ResourceType.Money, moneyType, currentValue)
    end
    clearResource(MoneyType.UNION_POINT)
end

function EventMergeServerModel:UpdateAccumulationProgress()
    local point = InventoryUtils.GetMoney(MoneyType.UNION_POINT)
    for i = 1, self.listAccumulateQuest:Count() do
        --- @type QuestUnitInBound
        local questUnitInBound = self.listAccumulateQuest:Get(i)
        questUnitInBound.number = point
        if questUnitInBound.questState ~= QuestState.COMPLETED
                and questUnitInBound.questState ~= QuestState.DONE_REWARD_NOT_CLAIM then
            if questUnitInBound.number >= questUnitInBound.config:GetMainRequirementTarget() then
                questUnitInBound.questState = QuestState.DONE_REWARD_NOT_CLAIM
            end
        end
    end
end

--- @class MergeServerTab
MergeServerTab = {
    CHECK_IN = 1,
    QUEST = 2,
    EXCHANGE = 3,
    BUNDLE = 4,
    ACCUMULATION = 5,
}
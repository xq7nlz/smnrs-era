require "lua.client.core.network.playerData.common.QuestDataInBound"

--- @class EventPopupQuestModel : EventPopupModel
EventPopupQuestModel = Class(EventPopupQuestModel, EventPopupModel)

function EventPopupQuestModel:Ctor()
    EventPopupModel.Ctor(self)
    --- @type Dictionary
    self.dataDict = Dictionary()
    self.dataList = List()
    self.currentRound = 1
    self.totalRound = 1
end

function EventPopupQuestModel:ReadInnerData(buffer)
    local size = buffer:GetByte()
    local serializeList = QuestDataInBound.ReadListQuestFromBuffer(buffer, self:GetConfig(), size)

    for i = 1, size do
        --- @type QuestUnitInBound
        local questUnit = serializeList:Get(1)
        self.dataDict:Add(questUnit.questId, questUnit)
    end

    self:_ModifyData(serializeList)
end

--- @return QuestUnitInBound|PurchasedPackInBound
function EventPopupQuestModel:GetData(id)
    local data = self.dataDict:Get(id)
    if data == nil then
        XDebug.Error(string.format("data_id is nil: %s", id))
    end
    return data
end

--- @return List
function EventPopupQuestModel:GetAllData()
    return self.dataList
end

--- @return number
function EventPopupQuestModel:GetEventQuestRoundConfig()
    return ResourceMgr.GetEventConfig():GetEventQuestRoundConfigByType(self.timeData.eventType)
end

--- @return Dictionary
function EventPopupQuestModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end

--- @param serializeList List
function EventPopupQuestModel:_ModifyData(serializeList)
    self.dataList = List()

    local configQuestCount = self:GetConfig():Count()
    self.totalRound = self:GetEventQuestRoundConfig()
    if serializeList:Count() < configQuestCount then
        configQuestCount = serializeList:Count()
        self.totalRound = 1
    end
    local numberOfQuestPerRound = math.floor(configQuestCount / self.totalRound)
    local questCount = 0
    local completedRound = 0
    for i = 1, configQuestCount do
        --- @type QuestUnitInBound
        local questUnitInBound = serializeList:Get(i)
        if questUnitInBound.questState == QuestState.DOING then
            break
        end
        questCount = questCount + 1
        if questCount == numberOfQuestPerRound then
            completedRound = completedRound + 1
            questCount = 0
        end
    end
    self.currentRound = math.min(completedRound, self.totalRound)

    local maxTargetARound = serializeList:Get(numberOfQuestPerRound).config:GetMainRequirementTarget()
    local fromIndex = completedRound * numberOfQuestPerRound + 1
    if completedRound == self.totalRound then
        fromIndex = (completedRound - 1) * numberOfQuestPerRound + 1
    end
    local minusProgress = math.min(completedRound * maxTargetARound, (self.totalRound - 1) * maxTargetARound)
    if fromIndex > serializeList:Count() then
        XDebug.Warning("Invalid index " + fromIndex)
        return
    end
    for i = fromIndex, fromIndex + numberOfQuestPerRound - 1 do
        --- @type QuestUnitInBound
        local questUnitInBound = serializeList:Get(i)
        questUnitInBound.fixedTarget = questUnitInBound.config:GetMainRequirementTarget() - minusProgress
        questUnitInBound.number = questUnitInBound.number - minusProgress
        self.dataList:Add(questUnitInBound)
    end
    self:SortListQuestData()
end

--- @return QuestUnitInBound
--- @param indexOfList number
function EventPopupQuestModel:GetDataByIndexOfList(indexOfList)
    return self.dataList:Get(indexOfList)
end

--- @param listQuestData List|QuestUnitInBound
function EventPopupQuestModel:SortListQuestData()
    local count = self.dataList:Count()
    local index = 1
    local firstIndex = 1
    for _ = 1, count do
        --- @type QuestUnitInBound
        local questData = self.dataList:Get(index)
        if questData.questState == QuestState.DONE_REWARD_NOT_CLAIM then
            self.dataList:RemoveByIndex(index)
            self.dataList:Insert(questData, firstIndex)
            firstIndex = firstIndex + 1
        elseif questData.questState == QuestState.COMPLETED then
            self.dataList:RemoveByIndex(index)
            self.dataList:Insert(questData, count)
            index = index - 1
        end
        index = index + 1
    end
    return listQuestData
end
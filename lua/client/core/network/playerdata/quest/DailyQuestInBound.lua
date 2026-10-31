--- @class DailyQuestInBound
DailyQuestInBound = Class(DailyQuestInBound)

function DailyQuestInBound:Ctor()
    --- @type boolean
    self.hasNotification = nil
    --- @type List
    self.listDailyQuest = nil
    --- @type Dictionary<number, QuestElementConfig>
    self.config = ResourceMgr.GetQuestConfig():GetDailyQuest()
    --- @type number
    self.totalHiddenQuest = 0
    --- @type number
    self.totalQuest = 0
end

--- @param buffer UnifiedNetwork_ByteBuf
function DailyQuestInBound:ReadBuffer(buffer)
    self.listDailyQuest = QuestDataInBound.ReadListDailyQuestFromBuffer(buffer, self.config)
    self:_FilterDailyQuest()
end

function DailyQuestInBound:_FilterDailyQuest()
    self.totalHiddenQuest = 0
    --- @type QuestUnitInBound
    local questData
    local questCount = self.listDailyQuest:Count()
    for i = questCount, 1, -1 do
        --- @type QuestUnitInBound
        local questUnitData = self.listDailyQuest:Get(i)
        if questUnitData.questState == QuestState.HIDDEN then
            self.totalHiddenQuest = self.totalHiddenQuest + 1
            self.listDailyQuest:RemoveByIndex(i)
        elseif questUnitData.questState == QuestState.HIDDEN_AND_WAIT then
            self.listDailyQuest:RemoveByIndex(i)
        elseif questData == nil then
            --- @type QuestElementConfig
            local questElementConfig = self.config:Get(questUnitData.questId)
            if questElementConfig:GetQuestType() == QuestType.DAILY_QUEST_COMPLETE then
                questData = questUnitData
            end
        end
    end
    if questData ~= nil then
        questData.number = questData.number - self.totalHiddenQuest
    end
    self.listDailyQuest = QuestDataInBound.SortQuestByData(self.listDailyQuest)
end

--- @return boolean
function DailyQuestInBound:CheckNotification()
    self.hasNotification = QuestDataInBound.HasDoneNotClaimQuest(self.listDailyQuest)
end

--- @return List|QuestUnitInBound
function DailyQuestInBound:GetListDailyQuestData()
    return self.listDailyQuest
end

--- @return number
function DailyQuestInBound:GetTotalDailyHiddenQuest()
    return self.totalHiddenQuest
end

--- @return number
function DailyQuestInBound:GetTotalDailyAvailableQuest()
    return self.listDailyQuest:Count()
end
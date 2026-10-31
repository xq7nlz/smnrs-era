--- @class QuestTreeDataInBound
QuestTreeDataInBound = Class(QuestTreeDataInBound)

function QuestTreeDataInBound:Ctor()
    --- @type boolean
    self.hasNotification = nil
    --- @type List
    self.listQuestTree = nil
    --- @type Dictionary
    self.questTreeIdDict = nil
    --- @type number
    self.closedQuestId = nil
    --- @type number
    self.isCollapsed = false

    --- @type Dictionary<number, QuestElementConfig>
    self.config = ResourceMgr.GetQuestConfig():GetQuestTree()
end

--- @param buffer UnifiedNetwork_ByteBuf
function QuestTreeDataInBound:ReadBuffer(buffer)
    local listQuestTree = QuestDataInBound.ReadListQuestFromBuffer(buffer, self.config)
    self:_FilterQuestByTreeId(listQuestTree)
end

function QuestTreeDataInBound:_FilterQuestByTreeId(listQuestTree)
    self.questTreeIdDict = Dictionary()
    for i = 1, listQuestTree:Count() do
        --- @type QuestUnitInBound
        local questData = listQuestTree:Get(i)
        local treeId = QuestDataInBound.GetQuestTreeIdByQuestId(questData.questId)
        local listQuestByTreeId = self.questTreeIdDict:Get(treeId)
        if listQuestByTreeId == nil then
            listQuestByTreeId = List()
            self.questTreeIdDict:Add(treeId, listQuestByTreeId)
        end
        listQuestByTreeId:Add(questData)
    end
    self:ClientAdjustQuestState()
end

function QuestTreeDataInBound:ClientAdjustQuestState()
    --- @param _ number
    --- @param listQuestByTreeId List
    for _, listQuestByTreeId in pairs(self.questTreeIdDict:GetItems()) do
        for i = 1, listQuestByTreeId:Count() do
            --- @type QuestUnitInBound
            local questData = listQuestByTreeId:Get(i)
            --- @type QuestState
            local questState = questData.questState
            if questState == QuestState.DOING
                    or questState == QuestState.DONE_REWARD_NOT_CLAIM then
                --- @type QuestElementConfig
                local questElementConfig = self.config:Get(questData.questId)
                for k = 1, questElementConfig:GetUnlockRequirements():Count() do
                    local unlockReqId = questElementConfig:GetUnlockRequirements():Get(k)
                    local unlockQuestReqData = self:FindQuestDataById(unlockReqId)
                    if unlockQuestReqData ~= nil then
                        if unlockQuestReqData.questState ~= QuestState.COMPLETED then
                            questData.questState = QuestState.LOCKED
                            break
                        end
                    end
                end
            end
        end
    end
end

--- @return List
--- @param treeId number
function QuestTreeDataInBound:GetQuestTreeDataByTreeId(treeId)
    return self.questTreeIdDict:Get(treeId)
end

--- @return QuestElementConfig
--- @param questId number
function QuestTreeDataInBound:GetQuestElementConfig(questId)
    return self.config:Get(questId)
end

--- @return boolean
function QuestTreeDataInBound:CheckNotification()
    self.hasNotification = false
    --- @param listQuestByTreeId List
    for _, listQuestByTreeId in pairs(self.questTreeIdDict:GetItems()) do
        for i = 1, listQuestByTreeId:Count() do
            --- @type QuestUnitInBound
            local unitData = listQuestByTreeId:Get(i)
            if unitData.questState == QuestState.DONE_REWARD_NOT_CLAIM then
                --- @type QuestElementConfig
                local questElementConfig = self.config:Get(unitData.questId)
                local isHasParentNotCompleted = false
                for j = 1, questElementConfig:GetUnlockRequirements():Count() do
                    local unlockReqId = questElementConfig:GetUnlockRequirements():Get(j)
                    local questUnitData = self:FindQuestDataById(unlockReqId)
                    if questUnitData ~= nil then
                        if questUnitData.questState ~= QuestState.COMPLETED then
                            isHasParentNotCompleted = true
                            break
                        end
                    end
                end
                if isHasParentNotCompleted == false then
                    self.hasNotification = true
                end
            end
        end
    end
end

--- @return QuestUnitInBound
--- @param questId number
function QuestTreeDataInBound:FindQuestDataById(questId)
    local listQuestByTreeId = self.questTreeIdDict:Get(QuestDataInBound.GetQuestTreeIdByQuestId(questId))
    for i = 1, listQuestByTreeId:Count() do
        --- @type QuestUnitInBound
        local questUnitData = listQuestByTreeId:Get(i)
        if questUnitData.questId == questId then
            return questUnitData
        end
    end
end

--- @return number
function QuestTreeDataInBound:SelectQuestTreeToShowOnMiniPanel()
    local listId = List()
    --- @param listQuestId List
    for _, listQuestId in pairs(self.questTreeIdDict:GetItems()) do
        --- @param quest QuestUnitInBound
        for __, quest in pairs(listQuestId:GetItems()) do
            if quest.questState == QuestState.DONE_REWARD_NOT_CLAIM then
                return quest.questId
            elseif quest.questState == QuestState.DOING then
                --- @type QuestElementConfig
                local questElementConfig = self.config:Get(quest.questId)
                if questElementConfig.groupId ~= -1 then
                    listId:Add(quest.questId)
                end
            end
        end
    end
    return listId:Get(1)
end

--- @param questId number
function QuestTreeDataInBound:SetQuestTreeComplete(questId)
    local treeId = QuestDataInBound.GetQuestTreeIdByQuestId(questId)
    --- @type List
    local data = self:GetQuestTreeDataByTreeId(treeId)
    QuestDataInBound.SetCompleteQuestById(data, questId, OpCode.QUEST_TREE_CLAIM)
    for i = 1, data:Count() do
        --- @type QuestUnitInBound
        local questData = data:Get(i)
        if questData.questState == QuestState.LOCKED
                or questData.questState == QuestState.LOCKED_NOT_CALCULATED then
            local isAllQuestCompleted = true
            --- @type QuestElementConfig
            local questElementConfig = self.config:Get(questData.questId)
            for k = 1, questElementConfig:GetUnlockRequirements():Count() do
                local unlockReqId = questElementConfig:GetUnlockRequirements():Get(k)
                local questUnitData = self:FindQuestDataById(unlockReqId)
                if questUnitData ~= nil then
                    if questUnitData.questState ~= QuestState.COMPLETED then
                        isAllQuestCompleted = false
                        break
                    end
                end
            end
            if isAllQuestCompleted == true then
                if questData.number >= questElementConfig:GetMainRequirementTarget() then
                    questData.questState = QuestState.DONE_REWARD_NOT_CLAIM
                else
                    questData.questState = QuestState.DOING
                end
            end
        end
    end
    self:ClientAdjustQuestState()
end

--- @return boolean
--- @param treeId number
function QuestTreeDataInBound:IsHasQuestTreeNotifyByGroup(treeId)
    local listQuestData = self:GetQuestTreeDataByTreeId(treeId)
    for i = 1, listQuestData:Count() do
        --- @type QuestUnitInBound
        local unitData = listQuestData:Get(i)
        if unitData.questState == QuestState.DONE_REWARD_NOT_CLAIM then
            --- @type QuestElementConfig
            local questElementConfig = self.config:Get(unitData.questId)
            local isHasParentNotCompleted = false
            for j = 1, questElementConfig:GetUnlockRequirements():Count() do
                local unlockReqId = questElementConfig:GetUnlockRequirements():Get(j)
                local questUnitData = self:FindQuestDataById(unlockReqId)
                if questUnitData ~= nil then
                    if questUnitData.questState ~= QuestState.COMPLETED then
                        isHasParentNotCompleted = true
                        break
                    end
                end
            end
            if isHasParentNotCompleted == false then
                return true
            end
        end
    end
    return false
end
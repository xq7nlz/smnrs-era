require "lua.client.core.network.email.EmailRequest"

--- @class QuestTreeView
QuestTreeView = Class(QuestTreeView)

--- @param transform UnityEngine_Transform
--- @param rectParent UnityEngine_RectTransform
function QuestTreeView:Ctor(transform, rectParent)
    --- @type UnityEngine_GameObject
    self.gameObject = transform.gameObject
    --- @type UnityEngine_RectTransform
    self.rectParent = rectParent
    --- @type UnityEngine_RectTransform
    self.rectTrans = transform:GetComponent(ComponentName.UnityEngine_RectTransform)

    --- @type Dictionary
    self.nodeViewDict = Dictionary()
    --- @type Dictionary
    self.lineViewDict = Dictionary()

    --- @type Dictionary -- {questId, QuestUnitInBound}
    self.questDataDict = Dictionary()
end

function QuestTreeView:Enable()
    self.rectTrans:SetParent(self.rectParent)
    self.rectTrans.localScale = U_Vector3.one
    self.rectTrans.anchoredPosition3D = U_Vector3.zero
    self.gameObject:SetActive(true)
end

--- @return UIQuestTreeNodeItem
--- @param nodeId number
function QuestTreeView:GetNodeViewById(nodeId)
    if self.nodeViewDict:IsContainKey(nodeId) == false then
        local nodeTrans = self.rectTrans:Find("node_" .. nodeId)
        --- @type UIQuestTreeNodeItem
        local nodeView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.QuestTreeNodeItem, nodeTrans)
        --- @type QuestElementConfig
        local questElementConfig = ResourceMgr.GetQuestConfig():GetQuestTree():Get(nodeId)
        nodeView:SetUp(nodeId, questElementConfig:GetRequirementsToLocalize())
        nodeView:AddOnClickListener(function(questState)
            self:OnSelectQuestId(nodeId, questState)
        end)
        self.nodeViewDict:Add(nodeId, nodeView)
    end
    return self.nodeViewDict:Get(nodeId)
end

--- @return QuestLineViewConfig
--- @param lineId number
function QuestTreeView:GetLineViewById(lineId)
    if self.lineViewDict:IsContainKey(lineId) == false then
        local lineTrans = self.rectTrans:Find("line_" .. lineId)
        if lineTrans ~= nil then
            local lineView = UIBaseConfig(lineTrans)
            self.lineViewDict:Add(lineId, lineView)
        else
            print("Cannot find line by id ", lineId)
        end
    end
    return self.lineViewDict:Get(lineId)
end

--- @return number
--- @param clientQuestTreeConfig QuestTree
--- @param questData List
function QuestTreeView:SetUpViewByData(questData, clientQuestTreeConfig)
    local lines = clientQuestTreeConfig:GetAllLinesIdFromTree()
    for i = 1, lines:Count() do
        self:GetLineViewById(lines:Get(i)).active:SetActive(false)
    end

    --- @return QuestUnitInBound
    --- @param questId number
    local findQuestDataById = function(questId)
        for i = 1, questData:Count() do
            --- @type QuestUnitInBound
            local questUnitData = questData:Get(i)
            if questUnitData.questId == questId then
                return questUnitData
            end
        end
    end

    local completedQuest = 0

    for i = 1, questData:Count() do
        --- @type QuestUnitInBound
        local data = questData:Get(i)
        --- @type UIQuestTreeNodeItem
        local questNode = self:GetNodeViewById(data.questId)
        --- @type QuestState
        local questState = data.questState
        questNode:SetState(data.questState)

        if questState == QuestState.COMPLETED then
            completedQuest = completedQuest + 1

            local linesId = clientQuestTreeConfig:GetAllLinesIdFromSourceNode(data.questId)
            for j = 1, linesId:Count() do
                --- @type QuestLineViewConfig
                local line = self:GetLineViewById(linesId:Get(j))
                line.active:SetActive(true)
            end
        elseif questState == QuestState.DOING
                or questState == QuestState.DONE_REWARD_NOT_CLAIM then
            --- @type QuestElementConfig
            local questElementConfig = self:GetQuestElementConfig(data.questId)
            for k = 1, questElementConfig:GetUnlockRequirements():Count() do
                local unlockReqId = questElementConfig:GetUnlockRequirements():Get(k)
                local questUnitData = findQuestDataById(unlockReqId)
                if questUnitData ~= nil then
                    if questUnitData.questState ~= QuestState.COMPLETED then
                        questNode:SetState(QuestState.LOCKED)
                        break
                    end
                end
            end
        end
    end
    self:SetQuestDataDict(questData)
    return completedQuest
end

--- @param listQuestData List
function QuestTreeView:SetQuestDataDict(listQuestData)
    self.questDataDict = Dictionary()
    for i = 1, listQuestData:Count() do
        --- @type QuestUnitInBound
        local questData = listQuestData:Get(i)
        self.questDataDict:Add(questData.questId, questData)
    end
end

--- @return QuestUnitInBound
--- @param questId number
function QuestTreeView:GetQuestDataById(questId)
    if self.questDataDict:IsContainKey(questId) == true then
        return self.questDataDict:Get(questId)
    end
    return nil
end

--- @param questId number
function QuestTreeView:OnSelectQuestId(questId, questState)
    --- @type {questUnitInBound : QuestUnitInBound, onClickComplete, questElementConfig}
    local data = {}
    local questUnitInBound = QuestUnitInBound()
    questUnitInBound.questId = questId

    local questData = self:GetQuestDataById(questId)
    if questData ~= nil then
        questUnitInBound.questState = questState
    else
        questUnitInBound.questState = QuestState.LOCKED
    end
    questUnitInBound.number = questData.number
    data.questElementConfig = ResourceMgr.GetQuestConfig():GetQuestTree():Get(questUnitInBound.questId)
    data.questUnitInBound = questUnitInBound
    data.onClickComplete = function()
        --- @param rewardList List
        local onSuccessWithClaim = function(rewardList)
            PopupUtils.ClaimAndShowRewardList(rewardList)
            PopupMgr.HidePopup(UIPopupName.UIPopupQuestNodeInfo)
            RxMgr.updateQuestTreeComplete:Next({['questId'] = questUnitInBound.questId })
        end
        EmailRequest.RequestClaimQuest(OpCode.QUEST_TREE_CLAIM, questUnitInBound.questId, onSuccessWithClaim, SmartPoolUtils.LogicCodeNotification)
    end
    PopupMgr.ShowPopup(UIPopupName.UIPopupQuestNodeInfo, data)
end

function QuestTreeView:OnReadyHide()
    --- @param v UIQuestTreeNodeItem
    for _, v in pairs(self.nodeViewDict:GetItems()) do
        v:ReturnPool()
    end
    self.nodeViewDict = Dictionary()
end

--- @return QuestElementConfig
--- @param questId number
function QuestTreeView:GetQuestElementConfig(questId)
    return ResourceMgr.GetQuestConfig():GetQuestTree():Get(questId)
end
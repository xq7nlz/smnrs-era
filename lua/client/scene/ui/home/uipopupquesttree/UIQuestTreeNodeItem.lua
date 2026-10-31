---COMMENT_CONFIG    require("lua.client.scene.ui.home.uiPopupQuestTree.questTree.UIQuestTreeNodeItemConfig")

--- @class UIQuestTreeNodeItem : IconView
UIQuestTreeNodeItem = Class(UIQuestTreeNodeItem, IconView)

function UIQuestTreeNodeItem:Ctor()
    --- @type UIQuestTreeNodeItemConfig
    self.config = nil
    --- @type QuestState
    self.questState = nil
    IconView.Ctor(self)
end

function UIQuestTreeNodeItem:SetPrefabName()
    self.prefabName = 'quest_tree_node_item'
    self.uiPoolType = UIPoolType.QuestTreeNodeItem
end

--- @param transform UnityEngine_Transform
function UIQuestTreeNodeItem:SetConfig(transform)
    ---@type UIQuestTreeNodeItemConfig
    self.config = UIBaseConfig(transform)
end

--- @param func function
function UIQuestTreeNodeItem:AddOnClickListener(func)
    self.config.button.onClick:AddListener(function()
        if func ~= nil then
            func(self.questState)
        end
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
end

function UIQuestTreeNodeItem:ReturnPool()
    IconView.ReturnPool(self)
end

--- @return void
function UIQuestTreeNodeItem:RemoveAllListeners()
    self.config.button.onClick:RemoveAllListeners()
end

--- @param questId number
--- @param target number
function UIQuestTreeNodeItem:SetUp(questId, target)
    self.config.questIcon.sprite = ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconQuestTree, questId)
    if target ~= nil then
        self.config.questName.text = string.gsub(QuestDataInBound.GetLocalizeQuestTreeName(questId), "{1}", target)
    else
        self.config.questName.text = QuestDataInBound.GetLocalizeQuestTreeName(questId)
    end
end

--- @param questState QuestState
function UIQuestTreeNodeItem:SetState(questState)
    self.questState = questState
    self.config.noti:SetActive(false)
    self.config.completeMark:SetActive(false)
    self.config.lockMark:SetActive(false)

    if questState == QuestState.COMPLETED then
        self.config.completeMark:SetActive(true)
    elseif questState == QuestState.LOCKED_NOT_CALCULATED
            or questState == QuestState.LOCKED then
        self.config.lockMark:SetActive(true)
    elseif questState == QuestState.DONE_REWARD_NOT_CLAIM then
        self.config.noti:SetActive(true)
    elseif questState == QuestState.INITIAL then
    elseif questState == QuestState.DOING then
    end
end

return UIQuestTreeNodeItem
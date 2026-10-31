require "lua.client.scene.ui.home.uiPopupQuestTree.QuestTreeView"

--- @class UIQuestTreeLayout : UIQuestLayout
UIQuestTreeLayout = Class(UIQuestTreeLayout, UIQuestLayout)

local UIQuestTreeTab = {
    BEGIN = 1,
    MONSTER_CONQUER = 2,
    ENDLESS_CHALLENGE = 3,
}

--- @param view UIQuestView
--- @param opCodeClaim OpCode
function UIQuestTreeLayout:Ctor(view, opCodeClaim)
    --- @type Dictionary
    self.tabDict = Dictionary()
    UIQuestLayout.Ctor(self, view, opCodeClaim)
    --- @type QuestTreeDataInBound
    self.questTreeDataInBound = nil
end

function UIQuestTreeLayout:_InitConfig()
    --- @type UIQuestTreeLayoutConfig
    self.layoutConfig = UIBaseConfig(self.config.questTreeLayout)
    self:_InitTabs()
end

function UIQuestTreeLayout:_InitTabs()
    self.selectTab = function(currentTab)
        self:ShowTabData(currentTab)
        --- @param v UITabItem
        for k, v in pairs(self.tabDict:GetItems()) do
            v:SetTabState(k == currentTab)
        end
    end
    local addTab = function(uiQuestTreeTab)
        self.tabDict:Add(uiQuestTreeTab, UITabItem(self.layoutConfig.tabQuestTree:GetChild(uiQuestTreeTab - 1),
                self.selectTab, function()
                    return QuestDataInBound.GetQuestTreeTittleByGroupId(uiQuestTreeTab)
                end, uiQuestTreeTab))
    end
    addTab(UIQuestTreeTab.BEGIN)
    addTab(UIQuestTreeTab.MONSTER_CONQUER)
    addTab(UIQuestTreeTab.ENDLESS_CHALLENGE)
end

function UIQuestTreeLayout:OnShow()
    UIQuestLayout.OnShow(self)
    self.questTreeDataInBound = self.questDataInBound.questTreeDataInBound
    self.questTreeUpdateListener = RxMgr.updateQuestTreeComplete:Subscribe(RxMgr.CreateFunction(self, self.OnUpdateQuestTree))
    self.selectTab(UIQuestTreeTab.BEGIN)
end

--- @param data {questId : number}
function UIQuestTreeLayout:OnUpdateQuestTree(data)
    self:UpdateQuestTreeOnCompleted(data.questId)
    self:CheckNotificationTab()
    RxMgr.notificationRequestQuest:Next()
end

--- @param questId number
function UIQuestTreeLayout:UpdateQuestTreeOnCompleted(questId)
    zg.playerData:GetQuest():SetQuestTreeComplete(questId)
    self:ShowTabData(self.currentTab)
end

--- @param tabIndex number
function UIQuestTreeLayout:ShowTabData(tabIndex)
    self:DespawnTree()
    self.currentTab = tabIndex
    local quest_data = self.questTreeDataInBound:GetQuestTreeDataByTreeId(tabIndex)
    local quest_tree_config = ResourceMgr.GetQuestConfig():GetUIQuestTree(tabIndex)

    --- @type QuestTreeView
    if self.questTreeView == nil then
        local touchObject = TouchUtils.Spawn("UIQuestTreeLayout:ShowTabData")
        local questTreeName = "quest_tree_" .. tabIndex
        local onSpawned = function(gameObject)
            self.questTreeView = QuestTreeView(gameObject.transform, self.layoutConfig.content)
            local sizeDelta = self.questTreeView.rectTrans.sizeDelta
            sizeDelta = U_Vector2(sizeDelta.x, self.layoutConfig.content.sizeDelta.y)
            self.layoutConfig.content.sizeDelta = sizeDelta
            self.layoutConfig.content.anchoredPosition3D = U_Vector3(0, 0, 0)
            self.questTreeView:Enable()
            local completedQuest = self.questTreeView:SetUpViewByData(quest_data, quest_tree_config)
            local totalQuestData = quest_data:Count()
            self:ShowProgress(completedQuest, totalQuestData)
            touchObject:Enable()
        end
        SmartPool.Instance:SpawnGameObjectAsync(AssetType.UI, questTreeName, onSpawned)
    end
end

function UIQuestTreeLayout:ShowProgress(completedQuest, totalQuestData)
    self.layoutConfig.textProgress.text = string.format("%d/%d %s", completedQuest, totalQuestData, LanguageUtils.LocalizeCommon("completed"))
    self.layoutConfig.progressBar.fillAmount = completedQuest / totalQuestData
end

function UIQuestTreeLayout:DespawnTree()
    if self.questTreeView ~= nil then
        self.questTreeView:OnReadyHide()
        local objectName = "quest_tree_" .. self.currentTab
        SmartPool.Instance:DespawnGameObject(AssetType.UI, objectName, self.questTreeView.gameObject.transform)
        self.questTreeView = nil
    end
end

function UIQuestTreeLayout:OnHide()
    self:DespawnTree()
    self:RemoveListener()
end

function UIQuestTreeLayout:RemoveListener()
    if self.questTreeUpdateListener ~= nil then
        self.questTreeUpdateListener:Unsubscribe()
        self.questTreeUpdateListener = nil
    end
end

function UIQuestTreeLayout:SetUpLayout()
    self.config.questTreeLayout.gameObject:SetActive(true)
    self:CheckNotificationTab()
end

function UIQuestTreeLayout:CheckNotificationTab()
    self:EnableTabNotification(UIQuestTreeTab.BEGIN, self.questDataInBound.questTreeDataInBound:IsHasQuestTreeNotifyByGroup(UIQuestTreeTab.BEGIN))
    self:EnableTabNotification(UIQuestTreeTab.MONSTER_CONQUER, self.questDataInBound.questTreeDataInBound:IsHasQuestTreeNotifyByGroup(UIQuestTreeTab.MONSTER_CONQUER))
    self:EnableTabNotification(UIQuestTreeTab.ENDLESS_CHALLENGE, self.questDataInBound.questTreeDataInBound:IsHasQuestTreeNotifyByGroup(UIQuestTreeTab.ENDLESS_CHALLENGE))
end

--- @param uiQuestTreeTab number
--- @param isEnableNotify boolean
function UIQuestTreeLayout:EnableTabNotification(uiQuestTreeTab, isEnableNotify)
    --- @type UITabItem
    local uiTabItem = self.tabDict:Get(uiQuestTreeTab)
    uiTabItem:EnableNotify(isEnableNotify)
end

function UIQuestTreeLayout:InitLocalization()
    UIQuestLayout.InitLocalization(self)
    if self.tabDict ~= nil then
        --- @param v UITabItem
        for _, v in pairs(self.tabDict:GetItems()) do
            v:InitLocalization()
        end
    end
end
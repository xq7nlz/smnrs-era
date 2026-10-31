require "lua.client.scene.ui.home.uiQuest.questLayout.UIQuestLayout"

--- @class UIQuestView : UIBaseView
UIQuestView = Class(UIQuestView, UIBaseView)

--- @return void
--- @param model UIQuestModel
function UIQuestView:Ctor(model)
    --- @type UIQuestConfig
    self.config = nil
    --- @type Dictionary
    self.tabDict = Dictionary()
    --- @type UISelect
    self.tabFilterAchievement = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type QuestDataInBound
    self.questDataInBound = nil
    --- @type List
    self.listQuestData = nil
    --- @type Dictionary --<number, QuestElementConfig>
    self.questConfig = nil

    --- @type Dictionary
    self.questLayoutDict = Dictionary()
    --- @type UIQuestLayout
    self.currentLayout = nil
    --- @type UIQuestTab
    self.questTab = nil
    UIBaseView.Ctor(self, model)
    --- @type UIQuestModel
    self.model = model
end

--- @return void
function UIQuestView:OnReadyCreate()
    ---@type UIQuestConfig
    self.config = UIBaseConfig(self.uiTransform)
    self:InitButtonListener()
    self:InitTabs()
    self:InitScroll()
end

function UIQuestView:InitScroll()
    --- @param questId number
    local onClickClaim = function(questId)
        --- @param rewardList List
        local onClaimSuccess = function(rewardList)
            PopupUtils.ClaimAndShowRewardList(rewardList)
            self.currentLayout:OnClaimSuccess(questId)
        end
        local readInjectData = false
        if self.currentLayout.opCodeClaim == OpCode.QUEST_DAILY_CLAIM then
            local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_DAILY_QUEST_PASS)
            if eventModel ~= nil and eventModel:IsOpening() then
                readInjectData = true
            end
            eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_EASTER_EGG)
            if eventModel ~= nil and eventModel:IsOpening() then
                readInjectData = true
            end
            eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BIRTHDAY)
            if eventModel ~= nil and eventModel:IsOpening() then
                readInjectData = true
            end
            eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_LUNAR_NEW_YEAR_2022)
            if eventModel ~= nil and eventModel:IsOpening() then
                readInjectData = true
            end
            eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_SEASONAL)
            if eventModel ~= nil and eventModel:IsOpening() then
                readInjectData = true
            end
        end
        QuestDataInBound.RequestClaimQuest(self.currentLayout.opCodeClaim, questId, onClaimSuccess, readInjectData)
    end

    --- @param questId number
    --- @param questElementConfig QuestElementConfig
    local onClickGo = function(questId, questElementConfig)
        QuestDataInBound.GoQuest(questId, questElementConfig, function()
            PopupMgr.HidePopup(self.model.uiName)
        end)
    end

    --- @param obj QuestItemView
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type QuestUnitInBound
        local questUnitInBound = self.listQuestData:Get(dataIndex)
        QuestDataInBound.OnCreateQuestItem(obj, dataIndex, self.listQuestData, self.questConfig,
                onClickClaim, onClickGo, self.currentLayout:GetExtraReward(questUnitInBound.questId))
    end
    self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.QuestItemView, onCreateItem, onCreateItem)
    self.uiScroll:SetUpMotion(MotionConfig(nil, nil, 0.1, 0.05))
end

function UIQuestView:InitTabs()
    self.selectTab = function(currentTab)
        self:ShowQuestLayout(currentTab)
        --- @param v UITabItem
        for k, v in pairs(self.tabDict:GetItems()) do
            v:SetTabState(k == currentTab)
        end
    end
    local addTab = function(uiQuestTab, localizeFunction)
        self.tabDict:Add(uiQuestTab, UITabItem(self.config.tab:GetChild(uiQuestTab - 1),
                self.selectTab, localizeFunction, uiQuestTab))
    end
    addTab(UIQuestTab.DailyQuest, function()
        return LanguageUtils.LocalizeCommon("daily_quest")
    end)
    addTab(UIQuestTab.QuestTree, function()
        return LanguageUtils.LocalizeCommon("quest_tree")
    end)
    addTab(UIQuestTab.Achievement, function()
        return LanguageUtils.LocalizeCommon("achievement")
    end)
    addTab(UIQuestTab.DailyQuestPass, function()
        return LanguageUtils.LocalizeCommon("daily_quest_pass")
    end)
end

function UIQuestView:DisableCommon()
    self.config.scroll.gameObject:SetActive(false)
    self.config.questTreeLayout.gameObject:SetActive(false)
    self.config.titleGroup.gameObject:SetActive(false)
    self.config.achivementLayout.gameObject:SetActive(false)
end

function UIQuestView:InitLocalization()
    if self.questLayoutDict ~= nil then
        --- @param v UIQuestLayout
        for k, v in pairs(self.questLayoutDict:GetItems()) do
            v:InitLocalization()
        end
    end
    if self.tabDict ~= nil then
        --- @param v UITabItem
        for _, v in pairs(self.tabDict:GetItems()) do
            v:InitLocalization()
        end
    end
end

function UIQuestView:InitButtonListener()
    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.bgClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

function UIQuestView:ShowDailyQuest()
    self.config.questInfoTab:SetActive(false)

    self.config.textTittle.text = LanguageUtils.LocalizeCommon("daily_quest")
    self.uiScroll:Resize(self.listQuestData:Count())
end

function UIQuestView:ShowQuestTreeInfo()
    self.config.questInfoTab:SetActive(true)

    self.config.textTittle.text = LanguageUtils.LocalizeCommon("quest_tree")

    --- @return UnityEngine_UI_Text
    --- @param questTreeId number
    local getTextProgressQuestTree = function(questTreeId)
        if questTreeId == 1 then
            return self.config.textQuestTree1Progress
        elseif questTreeId == 2 then
            return self.config.textQuestTree2Progress
        elseif questTreeId == 3 then
            return self.config.textQuestTree3Progress
        end
    end

    for i = 1, 3 do
        local questData = self.questDataInBound.questTreeDataInBound:GetQuestTreeDataByTreeId(i)

        local completedQuest = 0
        --- @param quest QuestUnitInBound
        for _, quest in ipairs(questData:GetItems()) do
            if quest.questState == QuestState.COMPLETED then
                completedQuest = completedQuest + 1
            end
        end
        local uiText = getTextProgressQuestTree(i)
        uiText.text = string.format("<color=#B1EC33>%d/%d</color> %s", completedQuest, questData:Count(), LanguageUtils.LocalizeCommon("completed"))
    end
end

--- @param data table
function UIQuestView:OnReadyShow(data)
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
    self.questDataInBound = zg.playerData:GetQuest()
    self.config.miniBar.gameObject:SetActive(false)
    self.listQuestData = self.questDataInBound.newDailyQuestInBound:GetListDailyQuestData()

    local tabIndex = 1
    if data ~= nil then
        tabIndex = data.tabIndex
    end
    self.selectTab(tabIndex)
    self:CheckTabEvent()
    self:CheckNotificationAll()
    self:InitEventListener()

    self.uiScroll:PlayMotion()
end

--- @return void
function UIQuestView:CheckTabEvent()
    local checkActiveTabEvent = function(eventTimeType, uiQuestTab)
        --- @type EventPopupModel
        local eventModel = zg.playerData:GetEvents():GetEvent(eventTimeType)
        --- @type IapShopTabItem
        local tabEvent = self.tabDict:Get(uiQuestTab)
        tabEvent:SetActive(eventModel ~= nil and eventModel:IsOpening())
    end

    checkActiveTabEvent(EventTimeType.EVENT_DAILY_QUEST_PASS, UIQuestTab.DailyQuestPass)
end

--- @return void
function UIQuestView:OnFinishAnimation()
    UIBaseView.OnFinishAnimation(self)
    self:CheckAndInitTutorial()
end

--- @return void
function UIQuestView:InitEventListener()
    self.listener = RxMgr.notificationRequestQuest:Subscribe(RxMgr.CreateFunction(self, self.CheckNotificationAll))
end

--- @return void
function UIQuestView:RemoveEventListener()
    self.listener:Unsubscribe()
end

function UIQuestView:Hide()
    UIBaseView.Hide(self)
    if self.uiScroll ~= nil then
        self.uiScroll:Hide()
    end
    self.config.questInfoTab:SetActive(false)
    self.questDataInBound:CheckLocalNotification()
    RxMgr.notificationRequestQuest:Next()
    self:RemoveEventListener()
    self:RemoveListenerTutorial()
    self:HideLayout()
end

--- @param questId number
function UIQuestView:UpdateUIOnClaimSuccess(questId)
    --self.listQuestData = self.questDataInBound.dailyQuestInBound:GetListDailyQuestData()
    --QuestDataInBound.SetCompleteQuestById(self.listQuestData, questId, OpCode.QUEST_DAILY_CLAIM)
    --self.listQuestData = QuestDataInBound.SortQuestByData(self.listQuestData)
    --self.uiScroll:Resize(self.listQuestData:Count())

    self.currentLayout:OnClaimSuccess(questId)
end

function UIQuestView:CheckNotificationAll()
    self:EnableTabNotification(UIQuestTab.DailyQuest, self.questDataInBound.newDailyQuestInBound.hasNotification)
    self:EnableTabNotification(UIQuestTab.QuestTree, self.questDataInBound.questTreeDataInBound.hasNotification)
    self:EnableTabNotification(UIQuestTab.Achievement, self.questDataInBound.achievementQuestInBound.hasNotification)
    local events = zg.playerData:GetEvents()
    if (events ~= nil) then
        local eventDailyQuestPassModel = events:GetEvent(EventTimeType.EVENT_DAILY_QUEST_PASS)
        self:EnableTabNotification(UIQuestTab.DailyQuestPass, eventDailyQuestPassModel ~= nil and eventDailyQuestPassModel:HasNotification())
    end
end

--- @return void
---@param tutorial UITutorialView
---@param step number
function UIQuestView:ShowTutorial(tutorial, step)
    if step == TutorialStep.CLICK_QUEST_TREE then
        self.selectTab(UIQuestTab.QuestTree)
        tutorial:ViewFocusCurrentTutorial(self.config.tab:GetChild(1),
                GetComponent(ComponentName.UnityEngine_UI_Button), U_Vector2(200, 200), nil, nil, TutorialHandType.CLICK)
    elseif step == TutorialStep.CLICK_MAIN_ACTION then
        tutorial:ViewFocusCurrentTutorial(self.config.mainAction, U_Vector2(600, 600), nil, nil, TutorialHandType.CLICK)
    end
end

--- @param uiQuestTab UIQuestTab
function UIQuestView:GetTabLayout(uiQuestTab)
    self.currentLayout = self.questLayoutDict:Get(uiQuestTab)
    if self.currentLayout == nil then
        if uiQuestTab == UIQuestTab.DailyQuest then
            require "lua.client.scene.ui.home.uiQuest.questLayout.UIDailyQuestLayout"
            self.currentLayout = UIDailyQuestLayout(self, OpCode.QUEST_DAILY_CLAIM)
        elseif uiQuestTab == UIQuestTab.QuestTree then
            require "lua.client.scene.ui.home.uiQuest.questLayout.UIQuestTreeLayout"
            self.currentLayout = UIQuestTreeLayout(self, OpCode.QUEST_TREE_CLAIM)
        elseif uiQuestTab == UIQuestTab.Achievement then
            require "lua.client.scene.ui.home.uiQuest.questLayout.UIAchievementLayout"
            self.currentLayout = UIAchievementLayout(self, OpCode.QUEST_ACHIEVEMENT_CLAIM)
        elseif uiQuestTab == UIQuestTab.DailyQuestPass then
            require "lua.client.scene.ui.home.uiIapShop.uiIapShopLayout.uiIapPassLayout.UIIapDailyQuestPassLayout"
            self.currentLayout = UIIapDailyQuestPassLayout(self, EventTimeType.EVENT_DAILY_QUEST_PASS)
        end
        self.questLayoutDict:Add(uiQuestTab, self.currentLayout)
    end
end

function UIQuestView:ShowQuestLayout(uiQuestTab)
    self:HideLayout()
    self:DisableCommon()
    self:GetTabLayout(uiQuestTab)
    self.currentLayout:OnShow()
end

function UIQuestView:HideLayout()
    if self.currentLayout ~= nil then
        self.currentLayout:OnHide() -- hide scroll
    end
end

--- @param uiQuestTab UIQuestTab
--- @param isEnableNotify boolean
function UIQuestView:EnableTabNotification(uiQuestTab, isEnableNotify)
    --- @type UITabItem
    local uiTabItem = self.tabDict:Get(uiQuestTab)
    uiTabItem:EnableNotify(isEnableNotify)
end

function UIQuestView:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_CLOSE)
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

--- @class UIQuestTab
UIQuestTab = {
    DailyQuest = 1,
    QuestTree = 2,
    Achievement = 3,
    DailyQuestPass = 4,
}
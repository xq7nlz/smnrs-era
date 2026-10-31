require "lua.client.scene.ui.home.uiEventPuzzle.eventLayout.UIEventPuzzleLayout"
--- @class UIEventPuzzleView : UIBaseView
UIEventPuzzleView = Class(UIEventPuzzleView, UIBaseView)

function UIEventPuzzleView:Ctor(model)
    --- @type UIEventPuzzleConfig
    self.config = nil
    --- @type UILoopScroll
    self.scrollLoopTab = nil
    --- @type UILoopScroll
    self.scrollLoopContent = nil

    --- @type Dictionary
    self.layoutDict = Dictionary()
    --- @type UIEventPuzzleLayout
    self.layout = nil
    --- @type Dictionary
    self.eventTabDict = Dictionary()

    --- @type EventPuzzleModel
    self.eventModel = nil

    ---@type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_PUZZLE
    --- @type boolean
    self.isReloadingData = nil
    UIBaseView.Ctor(self, model)
    --- @type UIEventPuzzleModel
    self.model = model
end

function UIEventPuzzleView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)
    self:_InitButtonListener()
    self:InitUpdateTime()
    self:GetAllLayout()
end

function UIEventPuzzleView:_InitButtonListener()
    self.config.backButton.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.tabPuzzle.onClick:AddListener(function()
        self:SelectTab(EventPuzzleTab.PUZZLE)
    end)
    self.config.tabQuest.onClick:AddListener(function()
        self:SelectTab(EventPuzzleTab.QUEST)
    end)
    self.config.buttonAsk.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickHelpInfo()
    end)
end

function UIEventPuzzleView:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
    self:OnReadyHide()
end

function UIEventPuzzleView:OnClickHelpInfo()
    ---@type EventTimeData
    local timeData = self.eventModel.timeData
    local dayStart = TimeUtils.GetDateMonthYearFromTimestamp(timeData.startTime)
    local dayEnd = TimeUtils.GetDateMonthYearFromTimestamp(timeData.endTime)
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("event_puzzle_help", dayStart, dayEnd))
end

function UIEventPuzzleView:InitLocalization()
    self.config.textTitleEvent.text = LanguageUtils.LocalizeCommon("event_puzzle_era")
    self.config.textTabPuzzle.text = LanguageUtils.LocalizeCommon("puzzle")
    self.config.textTabQuest.text = LanguageUtils.LocalizeCommon("quest")
end

function UIEventPuzzleView:OnReadyHide()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

function UIEventPuzzleView:OnReadyShow(result)
    self.isReloadingData = false
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    self.isOpen = self.eventModel:IsOpening()
    if self.isOpen then
        self.eventListener = RxMgr.eventStateChange:Subscribe(RxMgr.CreateFunction(self, self.OnEventStateChange))
    end
    self:CheckResourceOnSeason()
    self.model:InitListSubEvent(self.eventModel.timeData)
    local defauftTab = EventPuzzleTab.SELECT_HERO
    if self.eventModel.isConfirmed and self.eventModel.completedSlot < 4 then
        defauftTab = EventPuzzleTab.PUZZLE
    end
    if self.isOpen then
        if self.model.listSubEvent:Count() > 0 then
            if result ~= nil and result.tab ~= nil then
                self:OnClickSelectTab(result.tab)
            else
                self:SelectTab(self.model.listSubEvent:Get(defauftTab))
            end
            --- self:CheckAllNotificationTab()
        else
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
            self:OnReadyHide()
        end
    else
        self:SelectTab(self.model.listSubEvent:Get(defauftTab))
    end
    self:StartTime()
    self:UpdateNotificationAllTab()
end

function UIEventPuzzleView:CheckResourceOnSeason()
    local endTime = self.eventModel.timeData.endTime
    local savedEndSeason = zg.playerData.remoteConfig.eventLunarNewYearEnd or endTime
    if savedEndSeason ~= endTime then
        --- self:ClearMoneyType()
    end
    zg.playerData.remoteConfig.eventLunarNewYearEnd = endTime
    zg.playerData:SaveRemoteConfig()
end

--- @param eventPuzzleTab EventPuzzleTab
function UIEventPuzzleView:SelectTab(eventPuzzleTab)
    if eventPuzzleTab == EventPuzzleTab.SELECT_HERO then
        self.config.tabBottom:SetActive(false)
    else
        if eventPuzzleTab == EventPuzzleTab.PUZZLE then
            self.config.tabPuzzle.interactable = false
            self.config.tabQuest.interactable = true
            self.config.bgOnPuzzle:SetActive(true)
            self.config.bgOnQuest:SetActive(false)
        else
            self.config.tabPuzzle.interactable = true
            self.config.tabQuest.interactable = false
            self.config.bgOnPuzzle:SetActive(false)
            self.config.bgOnQuest:SetActive(true)
        end
        self.config.tabBottom:SetActive(true)
    end
    self:GetLayout(eventPuzzleTab)
    self.layout:OnShow()
end

--- @param eventPuzzleTab EventPuzzleTab
function UIEventPuzzleView:GetLayout(eventPuzzleTab)
    self:DisableCommon()
    self.layout = self.layoutDict:Get(eventPuzzleTab)
    if self.layout == nil then
        if eventPuzzleTab == EventPuzzleTab.SELECT_HERO then
            require "lua.client.scene.ui.home.uiEventPuzzle.eventLayout.selectHeroLayout.UIEventPuzzleSelectHeroLayout"
            self.layout = UIEventPuzzleSelectHeroLayout(self, eventPuzzleTab, self.config.selectHeroAnchor)
        elseif eventPuzzleTab == EventPuzzleTab.PUZZLE then
            require "lua.client.scene.ui.home.uiEventPuzzle.eventLayout.resovlePuzzleLayout.UIEventResolvePuzzleLayout"
            self.layout = UIEventResolvePuzzleLayout(self, eventPuzzleTab, self.config.puzzleAnchor, self.config.puzzleNoti)
        elseif eventPuzzleTab == EventPuzzleTab.QUEST then
            require "lua.client.scene.ui.home.uiEventPuzzle.eventLayout.puzzleQuest.UIPuzzleQuestLayout"
            self.layout = UIPuzzleQuestLayout(self, eventPuzzleTab, self.config.questAnchor, self.config.questNoti)
        else
            XDebug.Error("Missing layout type " .. eventPuzzleTab)
            return nil
        end
        self.layoutDict:Add(eventPuzzleTab, self.layout)
    end
end

function UIEventPuzzleView:GetAllLayout()
    require "lua.client.scene.ui.home.uiEventPuzzle.eventLayout.puzzleQuest.UIPuzzleQuestLayout"
    self.layoutDict:Add(EventPuzzleTab.QUEST,
            UIPuzzleQuestLayout(self, EventPuzzleTab.QUEST, self.config.questAnchor, self.config.questNoti))
    require "lua.client.scene.ui.home.uiEventPuzzle.eventLayout.resovlePuzzleLayout.UIEventResolvePuzzleLayout"
    self.layoutDict:Add(EventPuzzleTab.PUZZLE,
            UIEventResolvePuzzleLayout(self, EventPuzzleTab.PUZZLE, self.config.puzzleAnchor, self.config.puzzleNoti))
    require "lua.client.scene.ui.home.uiEventPuzzle.eventLayout.selectHeroLayout.UIEventPuzzleSelectHeroLayout"
    self.layoutDict:Add(EventPuzzleTab.SELECT_HERO,
            UIEventPuzzleSelectHeroLayout(self, EventPuzzleTab.SELECT_HERO, self.config.selectHeroAnchor))
    for _, value in pairs(self.layoutDict:GetItems()) do
        value:OnHide()
    end
end

function UIEventPuzzleView:InitUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            local timeServer = zg.timeMgr:GetServerTime()
            self.timeRemaining = self:_GetEventEndTime() - timeServer
        else
            self.timeRemaining = self.timeRemaining - 1
        end
        if self.timeRemaining > 0 then
            self.config.textTimeEndIn.text = string.format("%s %s",
                    LanguageUtils.LocalizeCommon("will_end_in"),
                    UIUtils.SetColorString(UIUtils.green_light, TimeUtils.GetDeltaTime(self.timeRemaining, 4)))
        else
            -- XDebug.Log("TIME REMAINING " ..  self.timeRemaining)
            self.config.textTimeEndIn.text = ""
            self:StopTime()
            self:OnReadyHide()
        end
    end
end

function UIEventPuzzleView:_GetEventEndTime()
    return self.eventModel.timeData.endTime
end

function UIEventPuzzleView:StartTime()
    if self.updateTime ~= nil then
        zg.timeMgr:AddUpdateFunction(self.updateTime)
    end
end

function UIEventPuzzleView:StopTime()
    if self.updateTime ~= nil then
        zg.timeMgr:RemoveUpdateFunction(self.updateTime)
    end
end

function UIEventPuzzleView:DisableCommon()
    self:HideCurrentLayout()
end

function UIEventPuzzleView:HideCurrentLayout()
    if self.layout ~= nil then
        self.layout:OnHide()
        self.layout = nil
    end
end

function UIEventPuzzleView:RemoveListener()
    if self.eventListener ~= nil then
        self.eventListener:Unsubscribe()
        self.eventListener = nil
    end
end

--- @param data {eventTimeType : EventTimeType, isAdded}
function UIEventPuzzleView:OnEventStateChange(data)
    local isAdded = data.isAdded
    if isAdded == false and self.isReloadingData ~= true then
        self.isReloadingData = true
        EventInBound.ValidateEventModel(function()
            ---@type EventNewYearModel
            local eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
            if eventModel:IsOpening() then
                self:HideCurrentLayout()
                self:RemoveListener()
                self:OnReadyShow()
            else
                if PopupUtils.IsPopupShowing(self.model.uiName) == false then
                    return
                end
                PopupMgr.HidePopup(self.model.uiName)
                PopupMgr.ShowPopup(UIPopupName.UIMainArea)
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
            end
        end, true)
    end
end

--- @param eventPuzzleTab EventPuzzleTab
function UIEventPuzzleView:OnClickSelectTab(eventPuzzleTab)
    if self:_IsTabChosen(eventPuzzleTab) then
        return
    end
    self:SelectTab(eventPuzzleTab)
end

function UIEventPuzzleView:UpdateNotificationAllTab()
    --- @param value UIEventPuzzleLayout
    for _, value in pairs(self.layoutDict:GetItems()) do
        value:UpdateNotification()
    end
end

--- @param eventPuzzleTab EventPuzzleTab
function UIEventPuzzleView:UpdateNotificationByTab(eventPuzzleTab)
    --- @type UIEventPuzzleLayout
    local objTab = self.layoutDict:Get(eventPuzzleTab)
    if objTab ~= nil then
        objTab:UpdateNotification()
    end
end

--- @param eventPuzzleTab EventPuzzleTab
function UIEventPuzzleView:_IsTabChosen(eventPuzzleTab)
    return self.layout ~= nil and self.layout.tab == eventPuzzleTab
end

function UIEventPuzzleView:Hide()
    UIBaseView.Hide(self)

    self:RemoveListener()
    self:StopTime()
    self:HideCurrentLayout()
end
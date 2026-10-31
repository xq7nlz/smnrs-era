require "lua.client.scene.ui.home.uiEventValentine.eventLayout.UIEventValentineLayout"

--- @class UIEventValentineView : UIBaseView
UIEventValentineView = Class(UIEventValentineView, UIBaseView)
local pivotTab = U_Vector2(0.865, 0.5)

--- @return void
--- @param model UIEventValentineModel
function UIEventValentineView:Ctor(model)
    --- @type UIEventValentineConfig
    self.config = nil
    --- @type UILoopScroll
    self.scrollLoopTab = nil
    --- @type UILoopScroll
    self.scrollLoopContent = nil

    --- @type Dictionary
    self.layoutDict = Dictionary()
    --- @type UIEventValentineLayout
    self.layout = nil
    --- @type Dictionary
    self.eventTabDict = Dictionary()

    --- @type EventValentineModel
    self.eventModel = nil

    ---@type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_VALENTINE
    --- @type boolean
    self.isReloadingData = nil
    UIBaseView.Ctor(self, model)
    --- @type UIEventValentineModel
    self.model = model
end

function UIEventValentineView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)
    self:_InitButtonListener()
    self:_InitScrollTab()
end

function UIEventValentineView:InitLocalization()
    if self.layoutDict ~= nil then
        --- @param v UIEventNewYearLayout
        for _, v in pairs(self.layoutDict:GetItems()) do
            v:InitLocalization()
        end
    end
end

function UIEventValentineView:_InitButtonListener()
    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonAsk.onClick:AddListener(function()
        self:OnClickHelpInfo()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
end

function UIEventValentineView:_InitScrollTab()
    --- @param obj UIEventPackageTabItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type ValentineTab
        local valentineTab = self.model.listSubEvent:Get(dataIndex)
        obj:SetText(self:_GetEventName(valentineTab))
        obj:SetSelectState(self:_IsTabChosen(valentineTab))
        obj:SetIcon(self:_GetEventIcon(valentineTab))
        obj:SetNotificationFunction(function()
            return self:_GetEventNotification(valentineTab)
        end)
        obj:SetEndEventTime(self.eventModel.timeData.endTime, function()
            self:_OnEventTimeEnded()
        end)
        obj:AddOnSelectListener(function()
            self:OnClickSelectTab(valentineTab)
        end)
        obj:SetPivot(pivotTab)
        self.eventTabDict:Add(valentineTab, obj)
    end

    --- @param obj UIEventPackageTabItem
    --- @param index number
    local onUpdateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type ValentineTab
        local valentineTab = self.model.listSubEvent:Get(dataIndex)
        obj:SetSelectState(self:_IsTabChosen(valentineTab))
    end
    self.scrollLoopTab = UILoopScroll(self.config.VerticalScrollTab, UIPoolType.EventPackageTabItem, onCreateItem, onUpdateItem)
    self.scrollLoopTab:SetUpMotion(MotionConfig(nil, nil, nil, 0.02))
end

function UIEventValentineView:OnReadyShow(result)
    self.isReloadingData = false
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    self.eventModel:CheckResourceOnSeason()
    self.model:InitListSubEvent(self.eventModel.timeData)
    if self.eventModel:IsOpening() == false then
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
        self:OnReadyHide()
        return
    elseif result ~= nil and result.tab ~= nil then
        self:OnClickSelectTab(result.tab)
    else
        if self.model.listSubEvent:Count() > 0 then
            self:SelectTab(self.model.listSubEvent:Get(1))
            self.scrollLoopTab:Resize(self.model.listSubEvent:Count())
            self:CheckAllNotificationTab()
        else
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
            self:OnReadyHide()
        end
    end
end

function UIEventValentineView:OnClickHelpInfo()
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("event_valentine_info"))
end

--- @param valentineTab ValentineTab
function UIEventValentineView:_GetEventName(valentineTab)
    if valentineTab == ValentineTab.CHECK_IN then
        return LanguageUtils.LocalizeCommon("valentine_checkin")
    elseif valentineTab == ValentineTab.LOVE_CHALLENGE then
        return LanguageUtils.LocalizeCommon("valentine_love_challenge")
    elseif valentineTab == ValentineTab.LOVE_BUNDLE then
        return LanguageUtils.LocalizeCommon("valentine_store")
    elseif valentineTab == ValentineTab.OPEN_CARD then
        return LanguageUtils.LocalizeCommon("event_valentine_open_card")
    else
        return LanguageUtils.LocalizeCommon("valentine_golden_time_name")
    end
end

--- @param valentineTab ValentineTab
function UIEventValentineView:_IsTabChosen(valentineTab)
    return self.layout ~= nil and self.layout.valentineTab == valentineTab
end

--- @param valentineTab ValentineTab
function UIEventValentineView:_GetEventIcon(valentineTab)
    return ResourceLoadUtils.LoadEventValentine(valentineTab)
end

--- @param valentineTab ValentineTab
function UIEventValentineView:_GetEventNotification(valentineTab)
    return self.eventModel:IsTabNotified(valentineTab)
end

function UIEventValentineView:_OnEventTimeEnded()
    if self.isReloadingData ~= true then
        self.isReloadingData = true
        EventInBound.ValidateEventModel(function()
            ---@type EventValentineModel
            local eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
            if eventModel:IsOpening() then
                self:HideCurrentLayout()
                --self:RemoveListener()
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

function UIEventValentineView:OnClickSelectTab(valentineTab)
    if self:_IsTabChosen(valentineTab) then
        return
    end
    self:SelectTab(valentineTab)
end

function UIEventValentineView:SelectTab(valentineTab)
    self:GetLayout(valentineTab)
    self.layout:OnShow()
    self.scrollLoopTab:RefreshCells()
end

--- @param valentineTab ValentineTab
function UIEventValentineView:GetLayout(valentineTab)
    self:DisableCommon()
    self.layout = self.layoutDict:Get(valentineTab)
    if self.layout == nil then
        if valentineTab == ValentineTab.CHECK_IN then
            require "lua.client.scene.ui.home.uiEventValentine.eventLayout.dailyCheckin.UIEventValentineCheckinLayout"
            self.layout = UIEventValentineCheckinLayout(self, valentineTab, self.config.loginEventAnchor)
        elseif valentineTab == ValentineTab.LOVE_CHALLENGE then
            require "lua.client.scene.ui.home.uiEventValentine.eventLayout.loveChallenge.UIEventValentineLoveChallengeLayout"
            self.layout = UIEventValentineLoveChallengeLayout(self, valentineTab, self.config.loveChallengeAnchor)
        elseif valentineTab == ValentineTab.LOVE_BUNDLE then
            require "lua.client.scene.ui.home.uiEventValentine.eventLayout.bundle.UIEventValentineBundleLayout"
            self.layout = UIEventValentineBundleLayout(self, valentineTab, self.config.loveBundle)
        elseif valentineTab == ValentineTab.OPEN_CARD then
            require "lua.client.scene.ui.home.uiEventValentine.eventLayout.openCard.UIEventValentineOpenCardLayout"
            self.layout = UIEventValentineOpenCardLayout(self, valentineTab, self.config.cardAnchor )
        else
            XDebug.Error("Missing layout type " .. valentineTab)
            return nil
        end
        self.layoutDict:Add(valentineTab, self.layout)
    end
end

function UIEventValentineView:DisableCommon()
    self:HideCurrentLayout()
    self.config.loginEventAnchor.gameObject:SetActive(false)
    self.config.loveChallengeAnchor.gameObject:SetActive(false)
    self.config.loveBundle.gameObject:SetActive(false)
    self.config.cardAnchor.gameObject:SetActive(false)
end

function UIEventValentineView:HideCurrentLayout()
    if self.layout ~= nil then
        self.layout:OnHide()
        self.layout = nil
    end
end

function UIEventValentineView:Hide()
    UIBaseView.Hide(self)
    self:HideCurrentLayout()
end

function UIEventValentineView:CheckAllNotificationTab()
    --- @param v ValentineTab
    --- @param v UIEventPackageTabItem
    for k, v in pairs(self.eventTabDict:GetItems()) do
        self:UpdateNotificationByTab(k)
    end
end

--- @param valentineTab ValentineTab
function UIEventValentineView:UpdateNotificationByTab(valentineTab)
    --- @type UIEventPackageTabItem
    local objTab = self.eventTabDict:Get(valentineTab)
    if objTab ~= nil then
        objTab:UpdateNotification()
    end
end

function UIEventValentineView:OnReadyHide()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end
